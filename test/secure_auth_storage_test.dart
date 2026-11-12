import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dorama_nest/data/services/secure_auth_storage.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  test('migrates the existing session and removes its plaintext preference', () async {
    SharedPreferences.setMockInitialValues({'session': 'legacy-session'});
    FlutterSecureStorage.setMockInitialValues({});
    final storage = SecureAuthStorage(sessionKey: 'session');
    await storage.initialize();
    expect(await storage.accessToken(), 'legacy-session');
    expect((await SharedPreferences.getInstance()).containsKey('session'), isFalse);
    await storage.removePersistedSession();
    expect(await storage.hasAccessToken(), isFalse);
  });
  test('existing Keychain session takes precedence over an old preference', () async {
    SharedPreferences.setMockInitialValues({'session': 'old'});
    FlutterSecureStorage.setMockInitialValues({'session': 'current'});
    final storage = SecureAuthStorage(sessionKey: 'session');
    await storage.initialize();
    expect(await storage.accessToken(), 'current');
  });
}
