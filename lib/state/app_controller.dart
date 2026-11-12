import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dorama_nest/data/api/api_exception.dart';
import 'package:dorama_nest/data/models/account_snapshot.dart';
import 'package:dorama_nest/data/models/dna_preferences.dart';
import 'package:dorama_nest/data/models/drama.dart';
import 'package:dorama_nest/data/models/review.dart';
import 'package:dorama_nest/data/models/watch_progress.dart';
import 'package:dorama_nest/data/services/account_repository.dart';
import 'package:dorama_nest/data/services/auth_repository.dart';
import 'package:dorama_nest/data/services/catalog_data.dart';
import 'package:dorama_nest/data/services/catalog_query.dart';
import 'package:dorama_nest/data/services/dna_engine.dart';
import 'package:dorama_nest/data/services/drama_repository.dart';
import 'package:dorama_nest/data/services/supabase_drama_repository.dart';

class AppController extends ChangeNotifier with WidgetsBindingObserver {
  AppController({DramaRepository? repository, RemoteDramaRepository? remoteRepository,
    AuthRepository? authRepository, AccountRepository? accountRepository,
    ApiFailureKind? startupFailure, this.cloudConfigured = false, this.watchConnectivity = true})
    : _repository = repository ?? DramaRepository(), _remoteRepository = remoteRepository,
      _auth = authRepository, _account = accountRepository, apiFailure = startupFailure;

  final DramaRepository _repository;
  final RemoteDramaRepository? _remoteRepository;
  final AuthRepository? _auth;
  final AccountRepository? _account;
  SharedPreferences? _prefs;
  StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription;
  StreamSubscription<SessionChange>? _authSubscription;
  CancelSubscription? _cancelAccount;
  Timer? _syncDebounce;
  Future<void>? _syncTask;
  Future<void>? _activation;
  bool _syncRequested = false;
  bool _sessionReady = false;
  bool _closed = false;
  int _sessionVersion = 0;
  int _catalogRequest = 0;
  int _revision = 0;
  NestUser? _user;
  final Map<String, PendingChange> _pending = {};
  final Map<String, List<DramaReview>> _communityReviews = {};
  final Map<String, CancelSubscription> _reviewChannels = {};
  final Map<String, int> _reviewReferences = {};
  final Map<String, Timer> _reviewDebounce = {};
  final Map<String, int> _reviewRequests = {};
  final Set<String> reviewsLoading = {};
  final Map<String, ApiFailureKind> reviewFailures = {};
  final Map<String, bool> reviewConnections = {};
  String nickname = '';
  bool get loggedIn => _user != null && !_user!.anonymous;
  bool get hasSession => _user != null;
  bool get hasAnonymousSession => _user?.anonymous == true;
  String? get remoteUserId => _user?.id;
  bool darkMode = false;
  bool notificationsOn = true;
  bool showSpoilers = false;
  String language = 'kk';
  bool loading = true;
  bool catalogLoading = false;
  bool showingSavedData = false;
  final bool cloudConfigured;
  final bool watchConnectivity;
  bool isAdmin = false;
  bool realtimeConnected = false;
  bool passwordRecovery = false;
  bool onboardingComplete = false;
  ApiFailureKind? apiFailure;
  ApiFailureKind? accountFailure;
  String? storageError;
  final Set<String> favorites = {};
  final List<DramaReview> ownReviews = [];
  List<Drama> dramas = CatalogData.dramas;
  List<String> genres = [];
  final Map<String, WatchProgress> watchProgress = {};
  DnaPreferences dnaPreferences = const DnaPreferences();
  int get pendingCount => _pending.length;
  bool get synchronizing => _syncTask != null;
  bool get canManageCatalog => !cloudConfigured || (hasSession && isAdmin);
  int get reviewsCount => ownReviews.length;
  int get favoriteCount => favorites.length;
  bool isFavorite(String id) => favorites.contains(id);
  List<DnaMatch> get recommendations => DnaEngine().recommend(catalog: dramas,
    favorites: favorites, progress: watchProgress, reviews: ownReviews, preferences: dnaPreferences);

  List<WatchProgress> get continueWatching => watchProgress.values.where((p) =>
    p.status == WatchStatus.watching && p.episodesWatched > 0 &&
    dramas.any((d) => d.id == p.dramaId && p.episodesWatched < d.episodes)).toList()
    ..sort((a, b) => b.updatedAt.compareTo(a.updatedAt));

  Drama? dramaById(String id) => dramas.where((d) => d.id == id).firstOrNull;
  List<DramaReview> reviewsFor(String dramaId) => (_account == null ? [
    ...CatalogData.sampleReviews.where((r) => r.dramaId == dramaId),
    ...ownReviews.where((r) => r.dramaId == dramaId),
  ] : _communityReviews[dramaId] ?? <DramaReview>[]).toList()
    ..sort((a, b) => b.createdAt.compareTo(a.createdAt));

  Future<void> init() async {
    WidgetsBinding.instance.addObserver(this);
    try {
      _prefs = await SharedPreferences.getInstance();
      darkMode = _prefs?.getBool('darkMode') ?? false;
      notificationsOn = _prefs?.getBool('notificationsOn') ?? true;
      showSpoilers = _prefs?.getBool('showSpoilers') ?? false;
      onboardingComplete = _prefs?.getBool('onboardingComplete') ?? false;
      final savedLanguage = _prefs?.getString('language') ?? 'kk';
      language = const {'kk', 'ru', 'en', 'ko'}.contains(savedLanguage) ? savedLanguage : 'kk';
      if (!(_prefs?.getBool('sqliteMigrationV1') ?? false)) {
        final legacyReviews = <DramaReview>[];
        try {
          final raw = _prefs?.getString('ownReviews');
          if (raw != null) legacyReviews.addAll((jsonDecode(raw) as List)
            .map((r) => DramaReview.fromJson(Map<String, dynamic>.from(r as Map))));
        } catch (_) { /* Retain damaged legacy data without overwriting it. */ }
        await _repository.importLegacy(favorites: _prefs?.getStringList('favorites') ?? [], reviews: legacyReviews);
        await _prefs?.setBool('sqliteMigrationV1', true);
      }
      await refreshCatalog();
      await _activateUser(_auth?.currentUser);
      _authSubscription = _auth?.changes.listen((event) {
        if (event.passwordRecovery) passwordRecovery = true;
        _activation = _activateUser(event.user);
        _activation!.catchError((Object _) { accountFailure = ApiFailureKind.unknown; _notify(); });
      }, onError: (Object _) { accountFailure = ApiFailureKind.unauthorized; _notify(); });
    } catch (_) {
      storageError = 'Не удалось загрузить локальную библиотеку';
    } finally {
      loading = false;
      _notify();
      if (_account != null && watchConnectivity) {
        _connectivitySubscription = Connectivity().onConnectivityChanged.listen((results) {
          if (results.any((r) => r != ConnectivityResult.none)) unawaited(retryCloud());
        }, onError: (Object _) {});
      }
    }
  }

  Future<void> _activateUser(NestUser? user) async {
    if (_closed) return;
    if (_sessionReady && user?.id == _user?.id) {
      _user = user;
      _notify();
      return;
    }
    _sessionReady = true;
    final epoch = ++_sessionVersion;
    _user = user;
    nickname = user?.nickname ?? '';
    isAdmin = false;
    realtimeConnected = false;
    accountFailure = null;
    favorites.clear(); watchProgress.clear(); ownReviews.clear(); _pending.clear();
    _communityReviews.clear(); reviewsLoading.clear(); reviewFailures.clear();
    dnaPreferences = const DnaPreferences();
    _syncDebounce?.cancel();
    _syncTask = null;
    final cancel = _cancelAccount;
    _cancelAccount = null;
    _notify();
    await cancel?.call();
    if (!_current(epoch)) return;
    if (user == null) {
      final savedFavorites = await _repository.favorites();
      final savedProgress = await _repository.allProgress();
      final savedReviews = await _repository.ownReviews();
      if (!_current(epoch)) return;
      favorites.addAll(savedFavorites.map((f) => f.dramaId));
      watchProgress.addEntries(savedProgress.map((p) => MapEntry(p.dramaId, p)));
      ownReviews.addAll(savedReviews);
      nickname = _prefs?.getString('nickname') ?? '';
      try {
        dnaPreferences = DnaPreferences.fromJson(jsonDecode(_prefs?.getString('guestDna') ?? '{}') as Map<String, dynamic>);
      } catch (_) { /* A corrupt optional preference must not prevent startup. */ }
    } else {
      try {
        final raw = _prefs?.getString('account:${user.id}');
        if (raw != null) {
          final json = jsonDecode(raw) as Map<String, dynamic>;
          _install(AccountSnapshot.fromJson(json));
          for (final value in json['pending'] as List? ?? const []) {
            final change = PendingChange.fromJson(Map<String, dynamic>.from(value as Map));
            _pending[change.key] = change;
            if (change.revision > _revision) _revision = change.revision;
          }
          _overlayPending();
        }
      } catch (_) { storageError = 'Не удалось загрузить локальную библиотеку'; }
      _cancelAccount = _account?.watchAccount(user.id, _scheduleSync, (connected) {
        if (_current(epoch)) { realtimeConnected = connected; _notify(); }
      });
      await syncAccount();
    }
    if (!_current(epoch)) return;
    for (final id in _reviewReferences.keys) { unawaited(refreshReviews(id)); }
    _notify();
  }

  bool _current(int epoch) => !_closed && epoch == _sessionVersion;
  void _notify() { if (!_closed) notifyListeners(); }

  void _install(AccountSnapshot snapshot) {
    favorites..clear()..addAll(snapshot.favorites);
    watchProgress..clear()..addAll(snapshot.progress);
    ownReviews..clear()..addAll(snapshot.reviews);
    dnaPreferences = snapshot.preferences;
    if (snapshot.nickname.isNotEmpty) nickname = snapshot.nickname;
    isAdmin = snapshot.isAdmin;
  }

  void _overlayPending() {
    for (final change in _pending.values) {
      switch (change.kind) {
        case 'favorite':
          if (change.value['saved'] == true) { favorites.add(change.id); }
          else { favorites.remove(change.id); }
        case 'progress': watchProgress[change.id] = WatchProgress.fromMap(change.value);
        case 'preferences': dnaPreferences = DnaPreferences.fromJson(change.value);
      }
    }
  }

  Future<void> _persistAccount(String userId) async {
    if (remoteUserId != userId) return;
    final snapshot = AccountSnapshot(favorites: favorites, progress: watchProgress,
      reviews: ownReviews, preferences: dnaPreferences, nickname: nickname);
    final saved = await _prefs?.setString('account:$userId', jsonEncode({
      ...snapshot.toJson(), 'pending': _pending.values.map((p) => p.toJson()).toList(),
    }));
    if (saved == false) throw StateError('Account cache could not be persisted.');
  }

  Future<void> _queue(String kind, String id, Map<String, dynamic> value) async {
    final userId = remoteUserId;
    if (userId == null || _account == null) throw const ApiException(ApiFailureKind.unauthorized, 'Sign in first.');
    final change = PendingChange(kind: kind, id: id, value: value, revision: ++_revision);
    _pending[change.key] = change;
    _overlayPending();
    await _persistAccount(userId);
    _notify();
    unawaited(syncAccount());
  }

  void _scheduleSync() {
    if (_closed) return;
    _syncRequested = true;
    _syncDebounce?.cancel();
    _syncDebounce = Timer(const Duration(milliseconds: 250), () => unawaited(syncAccount()));
  }

  Future<void> syncAccount() {
    if (_closed || remoteUserId == null || _account == null) return Future.value();
    if (_syncTask != null) { _syncRequested = true; return _syncTask!; }
    final epoch = _sessionVersion;
    final task = _synchronize(remoteUserId!, epoch);
    _syncTask = task;
    _notify();
    return task.whenComplete(() {
      if (_current(epoch)) { _syncTask = null; _notify(); }
    });
  }

  Future<void> _synchronize(String userId, int epoch) async {
    try {
      do {
        _syncRequested = false;
        ApiFailureKind? rejected;
        for (final change in _pending.values.toList()) {
          if (!_current(epoch)) return;
          try {
            await _account!.apply(userId, change);
          } on ApiException catch (error) {
            if (const {ApiFailureKind.offline, ApiFailureKind.timeout, ApiFailureKind.server,
              ApiFailureKind.unauthorized, ApiFailureKind.notFound}.contains(error.kind)) rethrow;
            rejected = error.kind;
          }
          if (!_current(epoch)) return;
          if (_pending[change.key]?.revision == change.revision) _pending.remove(change.key);
          await _persistAccount(userId);
        }
        final snapshot = await _account!.load(userId);
        if (!_current(epoch)) return;
        _install(snapshot);
        _overlayPending();
        accountFailure = rejected;
        await _persistAccount(userId);
        _notify();
      } while (_current(epoch) && (_syncRequested || _pending.isNotEmpty));
    } catch (error) {
      if (_current(epoch)) {
        accountFailure = error is ApiException ? error.kind : ApiFailureKind.unknown;
        isAdmin = false;
        _notify();
      }
    }
  }

  Future<void> refreshCatalog({String? country, String? genre, String sort = 'title'}) async {
    final request = ++_catalogRequest;
    final locale = language;
    catalogLoading = true; _notify();
    try {
      List<Drama> result;
      if (_remoteRepository != null) {
        try {
          result = await _remoteRepository.fetchCatalog(locale);
          if (_closed || request != _catalogRequest) return;
          for (final drama in result) { await _repository.saveDrama(drama); }
          apiFailure = null; showingSavedData = false;
        } on ApiException catch (error) {
          if (_closed || request != _catalogRequest) return;
          apiFailure = error.kind;
          final cached = await _remoteRepository.cachedCatalog(locale);
          result = cached ?? await _repository.allDramas();
          showingSavedData = true;
        }
      } else { result = await _repository.allDramas(); }
      if (_closed || request != _catalogRequest) return;
      dramas = result;
      genres = dramas.map((d) => d.genre).toSet().toList()..sort();
    } catch (_) { storageError = 'Не удалось загрузить локальную библиотеку'; }
    finally {
      if (request == _catalogRequest) { catalogLoading = false; _notify(); }
    }
  }

  Future<void> retryCloud() async {
    await syncAccount();
    if (apiFailure != null && !catalogLoading) await refreshCatalog();
    for (final id in _reviewReferences.keys.toList()) { await refreshReviews(id); }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) unawaited(retryCloud());
  }

  Future<List<Drama>> searchDramas(String query) async => CatalogQuery(query: query, locale: language).apply(dramas);

  Future<void> saveDrama(Drama drama) async {
    if (!canManageCatalog) throw const ApiException(ApiFailureKind.forbidden, 'Administrator access is required.');
    final saved = _remoteRepository == null ? drama : await _remoteRepository.saveDrama(drama, language);
    await _repository.saveDrama(saved);
    await refreshCatalog();
  }

  Future<void> deleteDrama(String id) async {
    if (!canManageCatalog) throw const ApiException(ApiFailureKind.forbidden, 'Administrator access is required.');
    await _remoteRepository?.deleteDrama(id);
    await _repository.deleteDrama(id);
    favorites.remove(id); watchProgress.remove(id); ownReviews.removeWhere((r) => r.dramaId == id);
    await refreshCatalog();
  }

  Future<void> setEpisodesWatched(String dramaId, int episodes, {WatchStatus? status}) async {
    final drama = dramaById(dramaId);
    if (drama == null || episodes < 0 || episodes > drama.episodes) throw ArgumentError('Invalid episode count.');
    final nextStatus = status ?? (episodes == drama.episodes ? WatchStatus.completed :
      episodes == 0 ? WatchStatus.planned : WatchStatus.watching);
    final progress = WatchProgress(dramaId: dramaId,
      episodesWatched: nextStatus == WatchStatus.completed ? drama.episodes : episodes,
      updatedAt: DateTime.now().toUtc(), status: nextStatus);
    if (hasSession) {
      await _queue('progress', dramaId, Map<String, dynamic>.from(progress.toMap()));
    } else {
      await _repository.saveDrama(drama);
      await _repository.setProgress(progress);
      watchProgress[dramaId] = progress; _notify();
    }
  }

  Future<void> toggleFavorite(String id) async {
    final next = !favorites.contains(id);
    if (hasSession) { await _queue('favorite', id, {'saved': next}); }
    else {
      final drama = dramaById(id);
      if (drama == null) return;
      await _repository.saveDrama(drama);
      await _repository.setFavorite(id, next);
      if (next) { favorites.add(id); } else { favorites.remove(id); }
      _notify();
    }
  }

  Future<void> setDnaPreferences(DnaPreferences value) async {
    if (hasSession) { await _queue('preferences', 'self', Map<String, dynamic>.from(value.toJson())); }
    else {
      await _prefs?.setString('guestDna', jsonEncode(value.toJson()));
      dnaPreferences = value; _notify();
    }
  }

  Future<void> signIn(String email, String password) async {
    if (_auth == null) throw const ApiException(ApiFailureKind.configuration, 'Cloud authentication is unavailable.');
    await _auth.signIn(email, password);
    await _activation;
    await _activateUser(_auth.currentUser);
  }

  Future<bool> signUp(String name, String email, String password) async {
    if (_auth == null) throw const ApiException(ApiFailureKind.configuration, 'Cloud authentication is unavailable.');
    final signedIn = await _auth.signUp(name, email, password);
    await _activation;
    await _activateUser(_auth.currentUser);
    return signedIn;
  }

  Future<void> signOut() async {
    await _auth?.signOut();
    await _activation;
    passwordRecovery = false;
    await _activateUser(null);
  }

  Future<void> sendPasswordReset(String email) async {
    if (_auth == null) throw const ApiException(ApiFailureKind.configuration, 'Cloud authentication is unavailable.');
    await _auth.sendPasswordReset(email);
  }
  Future<void> updatePassword(String password) async {
    if (_auth == null || !passwordRecovery) throw const ApiException(ApiFailureKind.unauthorized, 'Open a recovery link first.');
    await _auth.updatePassword(password);
    passwordRecovery = false; _notify();
  }
  Future<void> finishOnboarding() async {
    onboardingComplete = true;
    await _prefs?.setBool('onboardingComplete', true);
  }

  void retainReviews(String dramaId) {
    _reviewReferences[dramaId] = (_reviewReferences[dramaId] ?? 0) + 1;
    if (_account == null || _reviewChannels.containsKey(dramaId)) return;
    _reviewChannels[dramaId] = _account.watchReviews(dramaId, () {
      _reviewDebounce[dramaId]?.cancel();
      _reviewDebounce[dramaId] = Timer(const Duration(milliseconds: 250), () => unawaited(refreshReviews(dramaId)));
    }, (connected) { reviewConnections[dramaId] = connected; _notify(); });
    unawaited(refreshReviews(dramaId));
  }
  void releaseReviews(String dramaId) {
    final count = (_reviewReferences[dramaId] ?? 1) - 1;
    if (count > 0) { _reviewReferences[dramaId] = count; return; }
    _reviewReferences.remove(dramaId);
    _reviewDebounce.remove(dramaId)?.cancel();
    final cancel = _reviewChannels.remove(dramaId);
    if (cancel != null) unawaited(cancel());
  }
  Future<void> refreshReviews(String id) async {
    if (_account == null || _closed) return;
    final epoch = _sessionVersion;
    final request = (_reviewRequests[id] ?? 0) + 1;
    _reviewRequests[id] = request;
    reviewsLoading.add(id); _notify();
    try {
      final rows = await _account.reviews(id, remoteUserId);
      if (!_current(epoch) || _reviewRequests[id] != request) return;
      _communityReviews[id] = rows; reviewFailures.remove(id);
    } catch (error) {
      if (_current(epoch) && _reviewRequests[id] == request) {
        reviewFailures[id] = error is ApiException ? error.kind : ApiFailureKind.unknown;
      }
    } finally {
      if (_current(epoch) && _reviewRequests[id] == request) { reviewsLoading.remove(id); _notify(); }
    }
  }

  Future<void> saveReview({required String dramaId, required int stars,
    required String content, required bool spoiler, String? reviewId}) async {
    if (stars < 1 || stars > 5 || content.trim().length < 10 || content.trim().length > 1000) throw ArgumentError('Invalid review.');
    if (_account != null) {
      final id = remoteUserId;
      if (id == null || !loggedIn) throw const ApiException(ApiFailureKind.unauthorized, 'Sign in to publish.');
      final epoch = _sessionVersion;
      await _account.saveReview(id, dramaId, stars, content, spoiler);
      if (!_current(epoch)) return;
      await syncAccount(); await refreshReviews(dramaId);
    } else {
      final old = ownReviews.where((r) => r.dramaId == dramaId).firstOrNull;
      final review = DramaReview(id: old?.id ?? DateTime.now().microsecondsSinceEpoch.toString(),
        dramaId: dramaId, author: nickname.isEmpty ? 'DoramaNest' : nickname, stars: stars,
        content: content.trim(), spoiler: spoiler, mine: true, createdAt: old?.createdAt ?? DateTime.now());
      await _repository.saveReview(review);
      ownReviews.removeWhere((r) => r.id == review.id); ownReviews.add(review); _notify();
    }
  }
  Future<void> deleteReview(String id) async {
    final review = ownReviews.where((r) => r.id == id).firstOrNull;
    if (review == null) throw const ApiException(ApiFailureKind.forbidden, 'Review ownership required.');
    if (_account != null) {
      final userId = remoteUserId;
      if (userId == null) throw const ApiException(ApiFailureKind.unauthorized, 'Sign in first.');
      final epoch = _sessionVersion;
      await _account.deleteReview(userId, id);
      if (!_current(epoch)) return;
      await syncAccount(); await refreshReviews(review.dramaId);
    } else { await _repository.deleteReview(id); ownReviews.removeWhere((r) => r.id == id); _notify(); }
  }

  void dismissStorageError() { storageError = null; _notify(); }
  Future<void> setDarkMode(bool value) async { darkMode = value; _notify(); await _prefs?.setBool('darkMode', value); }
  Future<void> setNotifications(bool value) async { notificationsOn = value; _notify(); await _prefs?.setBool('notificationsOn', value); }
  Future<void> setShowSpoilers(bool value) async { showSpoilers = value; _notify(); await _prefs?.setBool('showSpoilers', value); }
  Future<void> setLanguage(String value) async {
    if (!const {'kk', 'ru', 'en', 'ko'}.contains(value)) return;
    language = value; _notify(); await _prefs?.setString('language', value);
    if (_remoteRepository != null) await refreshCatalog();
  }
  Future<void> close() async {
    if (_closed) return;
    _closed = true; _sessionVersion++;
    WidgetsBinding.instance.removeObserver(this);
    _syncDebounce?.cancel();
    for (final timer in _reviewDebounce.values) { timer.cancel(); }
    await _connectivitySubscription?.cancel(); await _authSubscription?.cancel();
    await _cancelAccount?.call();
    for (final cancel in _reviewChannels.values) { await cancel(); }
    await _repository.close();
    if (_remoteRepository case final SupabaseDramaRepository repository) repository.api.close();
  }
  @override
  void dispose() { unawaited(close()); super.dispose(); }
}

class AppScope extends InheritedNotifier<AppController> {
  const AppScope({super.key, required AppController controller, required super.child}) : super(notifier: controller);
  static AppController of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<AppScope>();
    assert(scope != null, 'DoramaNest AppScope is missing');
    return scope!.notifier!;
  }
}
