import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dorama_nest/data/api/api_client.dart';
import 'package:dorama_nest/data/api/api_config.dart';
import 'package:dorama_nest/data/api/api_exception.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

void main() {
  const config = ApiConfig(
    url: 'https://example.supabase.co',
    anonKey: 'test-anon-key',
  );

  test('sends GET with PostgREST filters and session token', () async {
    late http.Request seen;
    final api = ApiClient(
      config: config,
      accessToken: () => 'user-jwt',
      client: MockClient((request) async {
        seen = request;
        return http.Response('[{"id":"1"}]', 200);
      }),
    );

    final rows = await api.getRows('dramas', query: const {'country': 'eq.KR'});

    expect(rows.single['id'], '1');
    expect(seen.method, 'GET');
    expect(seen.url.queryParameters['country'], 'eq.KR');
    expect(seen.headers['apikey'], 'test-anon-key');
    expect(seen.headers['Authorization'], 'Bearer user-jwt');
    api.close();
  });

  test('sends POST, PATCH and DELETE requests independently', () async {
    final seen = <http.Request>[];
    final api = ApiClient(
      config: config,
      client: MockClient((request) async {
        seen.add(request);
        return switch (request.method) {
          'DELETE' => http.Response('', 204),
          'PATCH' => http.Response('[{"id":"1","rating":9}]', 200),
          _ => http.Response('[{"id":"1"}]', 201),
        };
      }),
    );

    final created = await api.postRows('dramas', const {'country': 'KR'});
    final changed = await api
        .patchRows('dramas', const {'rating': 9}, query: const {'id': 'eq.1'});
    await api.deleteRows('dramas', query: const {'id': 'eq.1'});

    expect(created.single['id'], '1');
    expect(changed.single['rating'], 9);
    expect(seen.map((request) => request.method), ['POST', 'PATCH', 'DELETE']);
    expect(jsonDecode(seen[0].body), {'country': 'KR'});
    expect(jsonDecode(seen[1].body), {'rating': 9});
    expect(seen[1].url.queryParameters['id'], 'eq.1');
    expect(seen[2].headers['Prefer'], 'return=minimal');
    api.close();
  });

  test('times out a slow request', () async {
    final never = Completer<http.Response>();
    final api = ApiClient(
      config: config,
      timeout: const Duration(milliseconds: 10),
      client: MockClient((_) => never.future),
    );

    await expectLater(
      api.getRows('dramas'),
      throwsA(isA<ApiException>().having(
        (error) => error.kind,
        'kind',
        ApiFailureKind.timeout,
      )),
    );
    api.close();
  });

  test('maps a missing network connection', () async {
    final api = ApiClient(
      config: config,
      client: MockClient((_) async => throw const SocketException('offline')),
    );

    await expectLater(
      api.getRows('dramas'),
      throwsA(isA<ApiException>().having(
        (error) => error.kind,
        'kind',
        ApiFailureKind.offline,
      )),
    );
    api.close();
  });

  for (final (status, kind) in [
    (400, ApiFailureKind.invalidRequest),
    (401, ApiFailureKind.unauthorized),
    (403, ApiFailureKind.forbidden),
    (404, ApiFailureKind.notFound),
    (409, ApiFailureKind.conflict),
    (503, ApiFailureKind.server),
  ]) {
    test('maps HTTP $status', () async {
      final api = ApiClient(
        config: config,
        client: MockClient((_) async => http.Response(
            '{"message":"request failed"}', status,
            headers: {'content-type': 'application/json'})),
      );

      await expectLater(
        api.getRows('dramas'),
        throwsA(isA<ApiException>()
            .having((error) => error.kind, 'kind', kind)
            .having((error) => error.statusCode, 'statusCode', status)),
      );
      api.close();
    });
  }

  test('rejects malformed JSON', () async {
    final api = ApiClient(
      config: config,
      client: MockClient((_) async => http.Response('not-json', 200)),
    );

    await expectLater(
      api.getRows('dramas'),
      throwsA(isA<ApiException>().having(
        (error) => error.kind,
        'kind',
        ApiFailureKind.invalidResponse,
      )),
    );
    api.close();
  });
}
