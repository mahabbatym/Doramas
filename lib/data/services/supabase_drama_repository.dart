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
    final rows = await api.getAllRows('dramas', query: const {
      'select':
          '*,drama_translations(*),drama_genres(genre_id,genres(id,slug,genre_translations(locale,name))),episodes(id)',
      'order': 'created_at.desc,id.asc',
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
    final translations = <String, Map<String, String>>{
      ...drama.translations,
      if (!drama.translations.containsKey(locale))
        locale: {'title': drama.title, 'description': drama.description},
    };
    final rows = await api.postRows('rpc/save_drama', {'document': {
      'id': drama.id.startsWith('local-') ? null : drama.id,
      'country': drama.country == 'Китай' ? 'CN' : 'KR',
      'release_year': drama.year, 'status': drama.status, 'rating': drama.score,
      'poster_url': drama.posterUrl, 'backdrop_url': drama.backdropUrl,
      'original_title': drama.originalTitle, 'episodes': drama.episodes,
      'genre_slugs': drama.genreKeys.toList(), 'translations': translations,
    }});
    final id = rows.firstOrNull?['id'] as String?;
    if (id == null) throw const ApiException(ApiFailureKind.invalidResponse, 'No saved drama returned.');
    return Drama.fromMap({...drama.toMap(), 'id': id, 'translations': translations});
  }

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
      'is_saved': 'eq.true',
      'order': 'created_at.desc',
      'limit': '1000',
    });
    return rows.map((row) => row['drama_id'].toString()).toSet();
  }

  @override
  Future<void> setFavorite(String id, bool value, String userId) async {
    await api.postRows('favorites', {
      'user_id': userId, 'drama_id': id, 'is_saved': value,
    }, query: const {'on_conflict': 'user_id,drama_id'},
      prefer: 'resolution=merge-duplicates,return=minimal');
  }

  String _cacheKey(String locale) => 'remoteCatalog:$locale';
}
