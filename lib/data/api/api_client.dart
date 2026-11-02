import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import 'package:dorama_nest/data/api/api_config.dart';
import 'package:dorama_nest/data/api/api_exception.dart';

class ApiClient {
  ApiClient({
    required this.config,
    String? Function()? accessToken,
    http.Client? client,
    this.timeout = const Duration(seconds: 10),
  })  : _accessToken = accessToken,
        _client = client ?? http.Client();

  final ApiConfig config;
  final String? Function()? _accessToken;
  final http.Client _client;
  final Duration timeout;

  Future<List<Map<String, dynamic>>> getRows(
    String table, {
    Map<String, String> query = const {},
  }) async {
    final data = await _request('GET', table, query: query);
    if (data is! List) {
      throw const ApiException(
          ApiFailureKind.invalidResponse, 'Expected a JSON array.');
    }
    return data.map(_asMap).toList(growable: false);
  }

  Future<List<Map<String, dynamic>>> postRows(
    String table,
    Object body, {
    Map<String, String> query = const {},
    String prefer = 'return=representation',
  }) async {
    final data =
        await _request('POST', table, query: query, body: body, prefer: prefer);
    if (data == null) return const [];
    if (data is! List) {
      throw const ApiException(
          ApiFailureKind.invalidResponse, 'Expected a JSON array.');
    }
    return data.map(_asMap).toList(growable: false);
  }

  Future<List<Map<String, dynamic>>> patchRows(
    String table,
    Map<String, Object?> body, {
    Map<String, String> query = const {},
  }) async {
    final data = await _request('PATCH', table,
        query: query, body: body, prefer: 'return=representation');
    if (data == null) return const [];
    if (data is! List) {
      throw const ApiException(
          ApiFailureKind.invalidResponse, 'Expected a JSON array.');
    }
    return data.map(_asMap).toList(growable: false);
  }

  Future<void> deleteRows(
    String table, {
    Map<String, String> query = const {},
  }) async {
    await _request('DELETE', table, query: query, prefer: 'return=minimal');
  }

  Future<Object?> _request(
    String method,
    String table, {
    Map<String, String> query = const {},
    Object? body,
    String? prefer,
  }) async {
    try {
      final request = http.Request(method, config.restUri(table, query));
      request.headers.addAll({
        'apikey': config.anonKey,
        'Authorization': 'Bearer ${_accessToken?.call() ?? config.anonKey}',
        'Accept': 'application/json',
        'Content-Type': 'application/json; charset=utf-8',
      });
      if (prefer != null) request.headers['Prefer'] = prefer;
      if (body != null) request.body = jsonEncode(body);

      final response = await (() async {
        final streamed = await _client.send(request);
        return http.Response.fromStream(streamed);
      })()
          .timeout(timeout);

      if (response.statusCode < 200 || response.statusCode >= 300) {
        throw ApiException.fromStatus(
            response.statusCode, _responseMessage(response.body));
      }
      if (response.bodyBytes.isEmpty) return null;
      try {
        return jsonDecode(utf8.decode(response.bodyBytes));
      } on FormatException catch (error) {
        throw ApiException(
            ApiFailureKind.invalidResponse, 'Invalid JSON: ${error.message}');
      }
    } on ApiException {
      rethrow;
    } on TimeoutException {
      throw const ApiException(ApiFailureKind.timeout, 'Request timed out.');
    } on SocketException catch (error) {
      throw ApiException(ApiFailureKind.offline, error.message);
    } on HttpException catch (error) {
      throw ApiException(ApiFailureKind.offline, error.message);
    } on http.ClientException catch (error) {
      throw ApiException(ApiFailureKind.offline, error.message);
    } on FormatException catch (error) {
      throw ApiException(
          ApiFailureKind.invalidResponse, 'Invalid JSON: ${error.message}');
    } catch (error) {
      throw ApiException(ApiFailureKind.unknown, error.toString());
    }
  }

  String _responseMessage(String body) {
    if (body.isEmpty) return 'The server returned an error.';
    try {
      final value = jsonDecode(body);
      if (value is Map<String, dynamic>) {
        return (value['message'] ?? value['details'] ?? value['hint'] ?? body)
            .toString();
      }
    } on FormatException {
      return body;
    }
    return body;
  }

  Map<String, dynamic> _asMap(Object? value) {
    if (value is Map<String, dynamic>) return value;
    if (value is Map) return Map<String, dynamic>.from(value);
    throw const ApiException(
        ApiFailureKind.invalidResponse, 'Expected a JSON object.');
  }

  void close() => _client.close();
}
