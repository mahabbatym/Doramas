import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Supabase session persistence backed by the iOS Keychain.
/// The old session is removed only after a successful, verified migration.
class SecureAuthStorage extends LocalStorage {
  SecureAuthStorage({required this.sessionKey, FlutterSecureStorage? storage})
    : storage = storage ?? const FlutterSecureStorage(
        iOptions: IOSOptions(accessibility: KeychainAccessibility.first_unlock_this_device));
  final String sessionKey;
  final FlutterSecureStorage storage;

  @override
  Future<void> initialize() async {
    final prefs = await SharedPreferences.getInstance();
    final old = prefs.getString(sessionKey);
    if (old == null) return;
    if (await storage.read(key: sessionKey) == null) {
      await storage.write(key: sessionKey, value: old);
      if (await storage.read(key: sessionKey) != old) {
        throw StateError('The session could not be migrated securely.');
      }
    }
    await prefs.remove(sessionKey);
  }
  @override
  Future<bool> hasAccessToken() async => await accessToken() != null;
  @override
  Future<String?> accessToken() => storage.read(key: sessionKey);
  @override
  Future<void> persistSession(String persistSessionString) => storage.write(key: sessionKey, value: persistSessionString);
  @override
  Future<void> removePersistedSession() => storage.delete(key: sessionKey);
}

class SecurePkceStorage extends GotrueAsyncStorage {
  SecurePkceStorage(this.prefix, this.storage);
  final String prefix;
  final FlutterSecureStorage storage;
  @override
  Future<String?> getItem({required String key}) => storage.read(key: '$prefix:$key');
  @override
  Future<void> setItem({required String key, required String value}) => storage.write(key: '$prefix:$key', value: value);
  @override
  Future<void> removeItem({required String key}) => storage.delete(key: '$prefix:$key');
}
