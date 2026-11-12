import 'dart:convert';
import 'package:dorama_nest/data/api/api_exception.dart';

class ApiConfig {
  const ApiConfig({required this.url, required this.anonKey});

  factory ApiConfig.fromEnvironment() => const ApiConfig(
        url: String.fromEnvironment('SUPABASE_URL'),
        anonKey: String.fromEnvironment('SUPABASE_ANON_KEY'),
      );

  final String url;
  final String anonKey;

  bool get isConfigured {
    final uri = Uri.tryParse(url.trim());
    if (uri == null || uri.scheme != 'https' || uri.host.isEmpty ||
        uri.userInfo.isNotEmpty || uri.hasQuery || uri.hasFragment ||
        anonKey.trim().isEmpty || anonKey.startsWith('sb_secret_')) return false;
    if (anonKey.split('.').length == 3) {
      try {
        final payload = jsonDecode(utf8.decode(base64Url.decode(base64Url.normalize(anonKey.split('.')[1]))));
        return payload is Map && payload['role'] == 'anon';
      } catch (_) { return false; }
    }
    return true;
  }

  Uri restUri(String table, [Map<String, String> query = const {}]) {
    if (!isConfigured) {
      throw const ApiException(
          ApiFailureKind.configuration, 'Supabase configuration is missing.');
    }
    final base = Uri.parse(url.trim());
    return base.replace(
      path: '${base.path.replaceFirst(RegExp(r'/$'), '')}/rest/v1/$table',
      queryParameters: query.isEmpty ? null : query,
    );
  }
}
