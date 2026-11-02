import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import 'package:dorama_nest/data/api/api_client.dart';
import 'package:dorama_nest/data/api/api_exception.dart';
import 'package:dorama_nest/data/models/drama.dart';
import 'package:dorama_nest/data/models/drama_api_model.dart';

abstract interface class RemoteDramaRepository {
  Future<List<Drama>> fetchCatalog(String locale);
  Future<List<Drama>?> cachedCatalog(String locale);
  Future<Drama> saveDrama(Drama drama, String locale);
  Future<void> deleteDrama(String id);
  Future<bool> isAdmin(String userId);
  Future<Set<String>> favoriteIds();
  Future<void> setFavorite(String id, bool value, String userId);
}

class SupabaseDramaRepository implements RemoteDramaRepository {
  SupabaseDramaRepository({required this.api, required this.preferences});

  final ApiClient api;
  final SharedPreferences preferences;

  @override
  Future<List<Drama>> fetchCatalog(String locale) async {
    final rows = await api.getRows('dramas', query: const {
      'select':
          '*,drama_translations(*),drama_genres(genre_id,genres(id,slug,genre_translations(locale,name))),episodes(id)',
      'order': 'created_at.desc',
      'limit': '100',
      'offset': '0',
    });
    final dramas = rows
        .map((row) => DramaApiModel.fromJson(row, locale: locale))
        .toList(growable: false);
    await preferences.setString(
      _cacheKey(locale),
      jsonEncode(dramas
          .map((drama) => <String, Object?>{
                ...drama.toMap(),
                'translations': drama.translations,
              })
          .toList()),
    );
    return dramas;
  }

  @override
  Future<List<Drama>?> cachedCatalog(String locale) async {
    final raw = preferences.getString(_cacheKey(locale));
    if (raw == null) return null;
    try {
      final rows = jsonDecode(raw) as List<dynamic>;
      return rows
          .map((row) => Drama.fromMap(Map<String, Object?>.from(row as Map)))
          .toList(growable: false);
    } on Object {
      await preferences.remove(_cacheKey(locale));
      return null;
    }
  }

  @override
  Future<Drama> saveDrama(Drama drama, String locale) async {
    final values = <String, Object?>{
      'country': drama.country == 'Китай' ? 'CN' : 'KR',
      'release_year': drama.year,
      'status': drama.status,
      'rating': drama.score,
      'poster_url': drama.posterUrl,
      'backdrop_url': drama.backdropUrl,
    };
    final isNew = drama.id.startsWith('local-');
    final rows = isNew
        ? await api.postRows('dramas', values)
        : await api
            .patchRows('dramas', values, query: {'id': 'eq.${drama.id}'});
    final savedId = rows.firstOrNull?['id']?.toString() ?? drama.id;
    if (rows.isEmpty && !isNew) {
      throw const ApiException(
          ApiFailureKind.notFound, 'Drama was not returned after update.');
    }

    final translations = <String, Map<String, String>>{
      ...drama.translations,
      if (!drama.translations.containsKey(locale))
        locale: {'title': drama.title, 'description': drama.description},
    };
    for (final entry in translations.entries) {
      if (!const {'kk', 'ru', 'en'}.contains(entry.key)) continue;
      await api.postRows(
        'drama_translations',
        {
          'drama_id': savedId,
          'locale': entry.key,
          'title': entry.value['title'] ?? drama.title,
          'description': entry.value['description'] ?? drama.description,
        },
        query: const {'on_conflict': 'drama_id,locale'},
        prefer: 'resolution=merge-duplicates,return=representation',
      );
    }
    await _replaceGenre(savedId, drama.genre, locale);
    await _replaceEpisodes(savedId, drama.episodes);
    return Drama(
      id: savedId,
      title: drama.title,
      originalTitle: drama.originalTitle,
      country: drama.country,
      year: drama.year,
      status: drama.status,
      genre: drama.genre,
      episodes: drama.episodes,
      score: drama.score,
      description: drama.description,
      posterUrl: drama.posterUrl,
      backdropUrl: drama.backdropUrl,
      translations: translations,
      symbol: drama.symbol,
      start: drama.start,
      end: drama.end,
      isCustom: true,
    );
  }

  Future<void> _replaceGenre(String dramaId, String name, String locale) async {
    final genres = await api.getRows('genres', query: const {
      'select': 'id,slug,genre_translations(locale,name)',
    });
    Map<String, dynamic>? match;
    for (final genre in genres) {
      final rows = (genre['genre_translations'] as List<dynamic>? ?? const [])
          .whereType<Map>()
          .map((row) => Map<String, dynamic>.from(row));
      final sameName = rows.any((row) => row['name'] == name);
      final sameSlug = _knownSlugs[name] == genre['slug'];
      if (sameName || sameSlug) {
        match = genre;
        break;
      }
    }
    if (match == null) {
      throw const ApiException(ApiFailureKind.invalidRequest,
          'The selected genre is not in the server catalog.');
    }
    await api.deleteRows('drama_genres', query: {'drama_id': 'eq.$dramaId'});
    await api.postRows('drama_genres', {
      'drama_id': dramaId,
      'genre_id': match['id'],
    });
  }

  Future<void> _replaceEpisodes(String dramaId, int episodeCount) async {
    final existing = await api.getRows('episodes', query: {
      'select': 'id,number',
      'drama_id': 'eq.$dramaId',
      'order': 'number.asc',
    });
    final existingNumbers =
        existing.map((row) => (row['number'] as num).toInt()).toSet();
    if (existingNumbers.any((number) => number > episodeCount)) {
      await api.deleteRows('episodes', query: {
        'drama_id': 'eq.$dramaId',
        'number': 'gt.$episodeCount',
      });
    }
    final missingNumbers = [
      for (var number = 1; number <= episodeCount; number++)
        if (!existingNumbers.contains(number)) number,
    ];
    if (missingNumbers.isEmpty) return;
    final created = await api.postRows(
      'episodes',
      missingNumbers
          .map((number) => <String, Object?>{
                'drama_id': dramaId,
                'number': number,
                'youtube_video_id': null,
                'thumbnail_url': null,
                'duration_seconds': null,
              })
          .toList(),
    );
    final titles = <Map<String, Object?>>[];
    for (final episode in created) {
      final id = episode['id'];
      final number = (episode['number'] as num).toInt();
      for (final locale in const ['kk', 'ru', 'en']) {
        titles.add({
          'episode_id': id,
          'locale': locale,
          'title': _episodeTitle(locale, number),
        });
      }
    }
    if (titles.isNotEmpty) {
      await api.postRows('episode_translations', titles,
          prefer: 'resolution=merge-duplicates,return=representation');
    }
  }

  String _episodeTitle(String locale, int number) => switch (locale) {
        'kk' => '$number-серия',
        'ru' => 'Серия $number',
        _ => 'Episode $number',
      };

  static const _knownSlugs = {
    'Романтика': 'romance',
    'Комедия': 'comedy',
    'Фэнтези': 'fantasy',
    'Музыка': 'music',
    'Драма': 'drama',
    'Детектив': 'mystery',
  };

  @override
  Future<void> deleteDrama(String id) async =>
      api.deleteRows('dramas', query: {'id': 'eq.$id'});

  @override
  Future<bool> isAdmin(String userId) async {
    final rows = await api.getRows('profiles', query: {
      'select': 'is_admin',
      'id': 'eq.$userId',
      'limit': '1',
    });
    return rows.firstOrNull?['is_admin'] == true;
  }

  @override
  Future<Set<String>> favoriteIds() async {
    final rows = await api.getRows('favorites', query: const {
      'select': 'drama_id',
      'order': 'created_at.desc',
      'limit': '1000',
    });
    return rows.map((row) => row['drama_id'].toString()).toSet();
  }

  @override
  Future<void> setFavorite(String id, bool value, String userId) async {
    if (value) {
      await api.postRows(
          'favorites',
          {
            'user_id': userId,
            'drama_id': id,
          },
          prefer: 'resolution=merge-duplicates,return=minimal');
    } else {
      await api.deleteRows('favorites', query: {
        'user_id': 'eq.$userId',
        'drama_id': 'eq.$id',
      });
    }
  }

  String _cacheKey(String locale) => 'remoteCatalog:$locale';
}
