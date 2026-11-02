import 'package:dorama_nest/data/api/api_exception.dart';

class ApiConfig {
  const ApiConfig({required this.url, required this.anonKey});

  factory ApiConfig.fromEnvironment() => const ApiConfig(
        url: String.fromEnvironment('SUPABASE_URL'),
        anonKey: String.fromEnvironment('SUPABASE_ANON_KEY'),
      );

  final String url;
  final String anonKey;

  bool get isConfigured =>
      url.startsWith('https://') && anonKey.trim().isNotEmpty;

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
