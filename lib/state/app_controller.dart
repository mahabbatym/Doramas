import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dorama_nest/data/api/api_exception.dart';
import 'package:dorama_nest/data/models/drama.dart';
import 'package:dorama_nest/data/models/review.dart';
import 'package:dorama_nest/data/models/watch_progress.dart';
import 'package:dorama_nest/data/services/catalog_data.dart';
import 'package:dorama_nest/data/services/catalog_query.dart';
import 'package:dorama_nest/data/services/drama_repository.dart';
import 'package:dorama_nest/data/services/supabase_drama_repository.dart';

class AppController extends ChangeNotifier {
  AppController({
    DramaRepository? repository,
    RemoteDramaRepository? remoteRepository,
    String? remoteUserId,
    Future<String?> Function()? authenticateAnonymously,
    ApiFailureKind? startupFailure,
    bool cloudConfigured = false,
  })  : _repository = repository ?? DramaRepository(),
        _remoteRepository = remoteRepository,
        _authenticateAnonymously = authenticateAnonymously,
        remoteUserId = remoteUserId,
        apiFailure = startupFailure,
        cloudConfigured = cloudConfigured;

  final DramaRepository _repository;
  final RemoteDramaRepository? _remoteRepository;
  final Future<String?> Function()? _authenticateAnonymously;
  StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription;
  SharedPreferences? _prefs;
  String? remoteUserId;
  String nickname = 'Mia';
  bool loggedIn = false;
  bool darkMode = false;
  bool notificationsOn = true;
  bool showSpoilers = false;
  String language = 'kk';
  bool loading = true;
  bool catalogLoading = false;
  bool showingSavedData = false;
  bool cloudConfigured;
  bool isAdmin = false;
  ApiFailureKind? apiFailure;
  String? storageError;
  final Set<String> favorites = {};
  final List<DramaReview> ownReviews = [];
  List<Drama> dramas = CatalogData.dramas;
  List<String> genres = [];
  final Map<String, WatchProgress> watchProgress = {};

  List<DramaReview> reviewsFor(String dramaId) => [
        ...CatalogData.sampleReviews.where((r) => r.dramaId == dramaId),
        ...ownReviews.where((r) => r.dramaId == dramaId),
      ]..sort((a, b) => b.createdAt.compareTo(a.createdAt));

  int get reviewsCount => ownReviews.length;
  int get favoriteCount => favorites.length;
  bool isFavorite(String id) => favorites.contains(id);

  Future<void> init() async {
    try {
      _prefs = await SharedPreferences.getInstance();
      nickname = _prefs?.getString('nickname') ?? 'Mia';
      loggedIn = _prefs?.getBool('loggedIn') ?? false;
      darkMode = _prefs?.getBool('darkMode') ?? false;
      notificationsOn = _prefs?.getBool('notificationsOn') ?? true;
      showSpoilers = _prefs?.getBool('showSpoilers') ?? false;
      final savedLanguage = _prefs?.getString('language') ?? 'kk';
      language = const {'kk', 'ru', 'en', 'ko'}.contains(savedLanguage)
          ? savedLanguage
          : 'kk';
      if (!(_prefs?.getBool('sqliteMigrationV1') ?? false)) {
        final legacyFavorites =
            _prefs?.getStringList('favorites') ?? ['hidden-love'];
        final legacyReviews = <DramaReview>[];
        final raw = _prefs?.getString('ownReviews');
        if (raw != null) {
          try {
            final decoded = jsonDecode(raw) as List<dynamic>;
            legacyReviews.addAll(decoded.map((e) =>
                DramaReview.fromJson(Map<String, dynamic>.from(e as Map))));
          } catch (_) {
            /* Keep the rest of the existing profile if old review JSON is damaged. */
          }
        }
        await _repository.importLegacy(
            favorites: legacyFavorites, reviews: legacyReviews);
        await _prefs?.setBool('sqliteMigrationV1', true);
      }
      if (_remoteRepository != null) {
        favorites
          ..clear()
          ..addAll(_prefs?.getStringList('remoteFavorites') ?? const []);
      }
      await refreshCatalog();
      favorites
        ..addAll(_remoteRepository == null
            ? (await _repository.favorites()).map((f) => f.dramaId)
            : const <String>[]);
      await _refreshRemoteAccount();
      ownReviews
        ..clear()
        ..addAll(await _repository.ownReviews());
      genres = await _repository.genres();
      for (final drama in dramas) {
        final progress = await _repository.progressFor(drama.id);
        if (progress != null) watchProgress[drama.id] = progress;
      }
    } catch (error) {
      storageError = 'Не удалось загрузить локальную библиотеку';
    } finally {
      loading = false;
      notifyListeners();
      _watchConnectivity();
    }
  }

  Future<void> refreshCatalog(
      {String? country, String? genre, String sort = 'title'}) async {
    catalogLoading = true;
    notifyListeners();
    try {
      if (_remoteRepository != null) {
        try {
          final remote = await _remoteRepository.fetchCatalog(language);
          for (final drama in remote) {
            await _repository.saveDrama(drama);
          }
          dramas = remote;
          apiFailure =
              remoteUserId == null ? ApiFailureKind.unauthorized : null;
          showingSavedData = false;
        } on ApiException catch (error) {
          apiFailure = error.kind;
          final cached = await _remoteRepository.cachedCatalog(language);
          if (cached != null) {
            dramas = cached;
            showingSavedData = true;
          } else {
            dramas = await _repository.allDramas(
                country: country, genre: genre, sort: sort);
            showingSavedData = false;
          }
        }
      } else {
        dramas = await _repository.allDramas(
            country: country, genre: genre, sort: sort);
      }
    } finally {
      catalogLoading = false;
      notifyListeners();
    }
  }

  bool get canManageCatalog => !cloudConfigured || isAdmin;
  bool get hasAnonymousSession => remoteUserId != null;

  Map<String, bool> _pendingFavoriteChanges() {
    final raw = _prefs?.getString('pendingRemoteFavorites');
    if (raw == null) return {};
    try {
      final decoded = jsonDecode(raw) as Map<String, dynamic>;
      return decoded.map((key, value) => MapEntry(key, value == true));
    } on Object {
      return {};
    }
  }

  Future<void> _savePendingFavoriteChanges(Map<String, bool> changes) async {
    if (changes.isEmpty) {
      await _prefs?.remove('pendingRemoteFavorites');
    } else {
      await _prefs?.setString('pendingRemoteFavorites', jsonEncode(changes));
    }
  }

  Future<void> _refreshRemoteAccount() async {
    final repository = _remoteRepository;
    final userId = remoteUserId;
    if (repository == null || userId == null) return;

    ApiFailureKind? accountFailure;
    final pendingFavorites = _pendingFavoriteChanges();
    Set<String> serverFavorites;
    try {
      serverFavorites = await repository.favoriteIds();
      for (final change in pendingFavorites.entries.toList()) {
        try {
          await repository.setFavorite(change.key, change.value, userId);
          if (change.value) {
            serverFavorites.add(change.key);
          } else {
            serverFavorites.remove(change.key);
          }
          pendingFavorites.remove(change.key);
        } on ApiException catch (error) {
          accountFailure = error.kind;
        }
      }
    } on ApiException catch (error) {
      accountFailure = error.kind;
      serverFavorites =
          (_prefs?.getStringList('remoteFavorites') ?? const <String>[])
              .toSet();
    }
    favorites
      ..clear()
      ..addAll(serverFavorites);
    for (final change in pendingFavorites.entries) {
      if (change.value) {
        favorites.add(change.key);
      } else {
        favorites.remove(change.key);
      }
    }
    await _savePendingFavoriteChanges(pendingFavorites);
    await _prefs?.setStringList('remoteFavorites', favorites.toList());
    try {
      isAdmin = await repository.isAdmin(userId);
    } on ApiException catch (error) {
      accountFailure ??= error.kind;
    }
    if (accountFailure != null) {
      apiFailure = accountFailure;
    } else if (apiFailure == ApiFailureKind.unauthorized) {
      apiFailure = null;
    }
  }

  Future<void> _recoverCloudConnection() async {
    if (remoteUserId == null && _authenticateAnonymously != null) {
      try {
        remoteUserId = await _authenticateAnonymously()
            .timeout(const Duration(seconds: 10));
      } on Object {
        apiFailure = ApiFailureKind.offline;
        notifyListeners();
        return;
      }
    }
    await refreshCatalog();
    await _refreshRemoteAccount();
    notifyListeners();
  }

  Future<void> _watchConnectivity() async {
    if (_remoteRepository == null) return;
    await _connectivitySubscription?.cancel();
    _connectivitySubscription = Connectivity().onConnectivityChanged.listen(
      (results) {
        final onlineInterface =
            results.any((result) => result != ConnectivityResult.none);
        if (onlineInterface &&
            (apiFailure == ApiFailureKind.offline ||
                apiFailure == ApiFailureKind.timeout ||
                apiFailure == ApiFailureKind.unauthorized)) {
          _recoverCloudConnection().catchError((Object _) {
            apiFailure = ApiFailureKind.unknown;
            notifyListeners();
          });
        }
      },
      onError: (Object _) {},
    );
  }

  void dismissStorageError() {
    storageError = null;
    notifyListeners();
  }

  Future<List<Drama>> searchDramas(String query) => _remoteRepository == null
      ? _repository.search(query)
      : Future.value(CatalogQuery(query: query, locale: language).apply(dramas));

  Future<void> saveDrama(Drama drama) async {
    var toSave = drama;
    if (_remoteRepository != null) {
      try {
        if (!isAdmin) {
          throw const ApiException(
              ApiFailureKind.forbidden, 'Administrator access is required.');
        }
        toSave = await _remoteRepository.saveDrama(drama, language);
      } on ApiException catch (error) {
        apiFailure = error.kind;
        notifyListeners();
        rethrow;
      }
    }
    await _repository.saveDrama(toSave);
    await refreshCatalog();
    genres = await _repository.genres();
    notifyListeners();
  }

  Future<void> deleteDrama(String id) async {
    if (_remoteRepository != null) {
      try {
        if (!isAdmin) {
          throw const ApiException(
              ApiFailureKind.forbidden, 'Administrator access is required.');
        }
        await _remoteRepository.deleteDrama(id);
      } on ApiException catch (error) {
        apiFailure = error.kind;
        notifyListeners();
        rethrow;
      }
    }
    await _repository.deleteDrama(id);
    favorites.remove(id);
    watchProgress.remove(id);
    ownReviews.removeWhere((review) => review.dramaId == id);
    await refreshCatalog();
    notifyListeners();
  }

  Future<void> setEpisodesWatched(String dramaId, int episodes) async {
    final drama = dramas.where((d) => d.id == dramaId).firstOrNull ??
        await _repository.dramaById(dramaId);
    if (drama == null) throw StateError('Дорама не найдена');
    if (episodes < 0 || episodes > drama.episodes)
      throw ArgumentError('Укажи число серий от 0 до ${drama.episodes}');
    await _repository.saveDrama(drama);
    final progress = WatchProgress(
        dramaId: dramaId, episodesWatched: episodes, updatedAt: DateTime.now());
    await _repository.setProgress(progress);
    if (episodes == 0) {
      watchProgress.remove(dramaId);
    } else {
      watchProgress[dramaId] = progress;
    }
    notifyListeners();
  }

  Future<void> signIn(String name) async {
    nickname = name.trim().isEmpty ? 'Mia' : name.trim();
    loggedIn = true;
    notifyListeners();
    await _prefs?.setString('nickname', nickname);
    await _prefs?.setBool('loggedIn', true);
  }

  Future<void> signOut() async {
    loggedIn = false;
    notifyListeners();
    await _prefs?.setBool('loggedIn', false);
  }

  Future<void> toggleFavorite(String id) async {
    final next = !favorites.contains(id);
    if (next) {
      favorites.add(id);
    } else {
      favorites.remove(id);
    }
    if (_remoteRepository == null) {
      await _repository.setFavorite(id, next);
    } else {
      final pending = _pendingFavoriteChanges()..[id] = next;
      await _savePendingFavoriteChanges(pending);
      await _prefs?.setStringList('remoteFavorites', favorites.toList());
      if (remoteUserId != null) {
        try {
          await _remoteRepository.setFavorite(id, next, remoteUserId!);
          pending.remove(id);
          await _savePendingFavoriteChanges(pending);
          if (pending.isEmpty) apiFailure = null;
        } on ApiException catch (error) {
          apiFailure = error.kind;
        }
      }
    }
    notifyListeners();
  }

  Future<void> saveReview(
      {required String dramaId,
      required int stars,
      required String content,
      required bool spoiler,
      String? reviewId}) async {
    if (stars < 1 ||
        stars > 5 ||
        content.trim().length < 10 ||
        content.trim().length > 1000) {
      throw ArgumentError('Проверь оценку и длину отзыва (10–1000 символов).');
    }
    final existing = ownReviews.where((r) => r.id == reviewId).firstOrNull;
    final review = existing == null
        ? DramaReview(
            id: DateTime.now().microsecondsSinceEpoch.toString(),
            dramaId: dramaId,
            author: nickname,
            stars: stars,
            content: content.trim(),
            spoiler: spoiler,
            mine: true,
            createdAt: DateTime.now())
        : existing.copyWith(
            stars: stars, content: content.trim(), spoiler: spoiler);
    await _repository.saveReview(review);
    if (existing == null) {
      ownReviews.add(review);
    } else {
      ownReviews[ownReviews.indexOf(existing)] = review;
    }
    notifyListeners();
  }

  Future<void> deleteReview(String id) async {
    await _repository.deleteReview(id);
    ownReviews.removeWhere((r) => r.id == id);
    notifyListeners();
  }

  Future<void> setDarkMode(bool value) async {
    darkMode = value;
    notifyListeners();
    await _prefs?.setBool('darkMode', value);
  }

  Future<void> setNotifications(bool value) async {
    notificationsOn = value;
    notifyListeners();
    await _prefs?.setBool('notificationsOn', value);
  }

  Future<void> setShowSpoilers(bool value) async {
    showSpoilers = value;
    notifyListeners();
    await _prefs?.setBool('showSpoilers', value);
  }

  Future<void> setLanguage(String value) async {
    if (!const {'kk', 'ru', 'en', 'ko'}.contains(value)) return;
    language = value;
    notifyListeners();
    await _prefs?.setString('language', value);
    if (_remoteRepository != null) await refreshCatalog();
  }

  Future<void> close() async {
    await _connectivitySubscription?.cancel();
    await _repository.close();
  }
}

class AppScope extends InheritedNotifier<AppController> {
  const AppScope(
      {super.key, required AppController controller, required super.child})
      : super(notifier: controller);
  static AppController of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<AppScope>();
    assert(scope != null, 'DoramaNest AppScope is missing');
    return scope!.notifier!;
  }
}
