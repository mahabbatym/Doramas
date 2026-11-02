import 'dart:convert';

import 'package:dorama_nest/data/api/api_client.dart';
import 'package:dorama_nest/data/api/api_config.dart';
import 'package:dorama_nest/data/models/drama.dart';
import 'package:dorama_nest/data/services/supabase_drama_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('GET maps joined JSON and returns the saved catalog offline', () async {
    final repository = await _repository((request) async {
      expect(request.method, 'GET');
      return _jsonResponse(
        [
          {
            'id': 'drama-1',
            'country': 'KR',
            'release_year': 2024,
            'status': 'completed',
            'rating': 9.2,
            'poster_url': 'https://images.example/poster.jpg',
            'backdrop_url': null,
            'drama_translations': [
              {
                'locale': 'kk',
                'title': 'Жылы оқиға',
                'description': 'Достық туралы хикая.'
              },
              {
                'locale': 'en',
                'title': 'A Warm Story',
                'description': 'A story about friendship.'
              },
            ],
            'drama_genres': [
              {
                'genres': {
                  'slug': 'romance',
                  'genre_translations': [
                    {'locale': 'kk', 'name': 'Романтика'}
                  ],
                },
              },
            ],
            'episodes': [
              {'id': 'episode-1'},
              {'id': 'episode-2'},
            ],
          },
        ],
        200,
      );
    });

    final catalog = await repository.fetchCatalog('kk');
    final cached = await repository.cachedCatalog('kk');

    expect(catalog.single.title, 'Жылы оқиға');
    expect(catalog.single.genre, 'Романтика');
    expect(catalog.single.episodes, 2);
    expect(catalog.single.posterUrl, 'https://images.example/poster.jpg');
    expect(catalog.single.translations['en']?['title'], 'A Warm Story');
    expect(cached?.single.title, 'Жылы оқиға');
    repository.api.close();
  });

  test('POST creates a drama and its translations, genre and episodes',
      () async {
    final requests = <http.Request>[];
    final repository = await _repository((request) async {
      requests.add(request);
      return _writeResponse(request);
    });

    final saved = await repository.saveDrama(
      _drama('local-new'),
      'kk',
    );

    expect(saved.id, 'server-drama');
    expect(
        requests.any((request) =>
            request.method == 'POST' && request.url.path.endsWith('/dramas')),
        isTrue);
    expect(
      requests.where((request) =>
          request.method == 'POST' &&
          request.url.path.endsWith('/drama_translations')),
      hasLength(3),
    );
    expect(
      requests.any((request) => request.url.path.endsWith('/episodes')),
      isTrue,
    );
    repository.api.close();
  });

  test('PATCH updates a drama and DELETE removes it', () async {
    final requests = <http.Request>[];
    final repository = await _repository((request) async {
      requests.add(request);
      return _writeResponse(request, hasEpisode: true);
    });

    await repository.saveDrama(_drama('server-drama'), 'kk');
    await repository.deleteDrama('server-drama');

    expect(
      requests.any((request) =>
          request.method == 'PATCH' &&
          request.url.path.endsWith('/dramas') &&
          request.url.queryParameters['id'] == 'eq.server-drama'),
      isTrue,
    );
    expect(
      requests.any((request) =>
          request.method == 'DELETE' &&
          request.url.path.endsWith('/dramas') &&
          request.url.queryParameters['id'] == 'eq.server-drama'),
      isTrue,
    );
    repository.api.close();
  });
}

Future<SupabaseDramaRepository> _repository(
    Future<http.Response> Function(http.Request) handler) async {
  SharedPreferences.setMockInitialValues({});
  return SupabaseDramaRepository(
    api: ApiClient(
      config: const ApiConfig(
        url: 'https://example.supabase.co',
        anonKey: 'public-test-key',
      ),
      client: MockClient(handler),
    ),
    preferences: await SharedPreferences.getInstance(),
  );
}

http.Response _writeResponse(http.Request request, {bool hasEpisode = false}) {
  final table = request.url.pathSegments.last;
  if (request.method == 'GET' && table == 'genres') {
    return _jsonResponse(
      [
        {
          'id': 'genre-romance',
          'slug': 'romance',
          'genre_translations': [
            {'locale': 'kk', 'name': 'Романтика'},
          ],
        },
      ],
      200,
    );
  }
  if (request.method == 'GET' && table == 'episodes') {
    return _jsonResponse(
      hasEpisode
          ? [
              {'id': 'episode-1', 'number': 1}
            ]
          : [],
      200,
    );
  }
  if (request.method == 'POST' && table == 'dramas') {
    return _jsonResponse([
      {'id': 'server-drama'}
    ], 201);
  }
  if (request.method == 'PATCH' && table == 'dramas') {
    return _jsonResponse([
      {'id': 'server-drama'}
    ], 200);
  }
  if (request.method == 'POST' && table == 'episodes') {
    final body = jsonDecode(request.body) as List<dynamic>;
    return _jsonResponse(
      [
        for (var index = 0; index < body.length; index++)
          {'id': 'episode-$index', 'number': body[index]['number']},
      ],
      201,
    );
  }
  if (request.method == 'DELETE') return http.Response('', 204);
  if (request.method == 'POST') return _jsonResponse([], 201);
  return _jsonResponse({}, 200);
}

http.Response _jsonResponse(Object body, int status) => http.Response(
      jsonEncode(body),
      status,
      headers: const {'content-type': 'application/json; charset=utf-8'},
    );

Drama _drama(String id) => Drama(
      id: id,
      title: 'Жылы оқиға',
      originalTitle: 'A Warm Story',
      country: 'Корея',
      year: 2024,
      genre: 'Романтика',
      episodes: 1,
      score: 9.2,
      description: 'Достық туралы хикая.',
      translations: const {
        'kk': {
          'title': 'Жылы оқиға',
          'description': 'Достық туралы хикая.',
        },
        'ru': {
          'title': 'Тёплая история',
          'description': 'История о дружбе.',
        },
        'en': {
          'title': 'A Warm Story',
          'description': 'A story about friendship.',
        },
      },
      symbol: '✦',
      start: const Color(0xFFEDAAB1),
      end: const Color(0xFF925A8A),
    );
