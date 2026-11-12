import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:dorama_nest/data/api/api_exception.dart';
import 'package:dorama_nest/data/models/account_snapshot.dart';
import 'package:dorama_nest/data/models/review.dart';
import 'package:dorama_nest/data/services/account_repository.dart';
import 'package:dorama_nest/data/services/auth_repository.dart';
import 'package:dorama_nest/data/services/drama_repository.dart';
import 'package:dorama_nest/state/app_controller.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  sqfliteFfiInit();
  late Directory directory;
  late FakeAuth auth;
  late FakeAccount remote;
  late AppController app;
  AppController create() => AppController(repository: DramaRepository(factory: databaseFactoryFfi,
    databasePath: '${directory.path}/test.db'), authRepository: auth, accountRepository: remote,
    cloudConfigured: true, watchConnectivity: false);
  setUp(() async {
    SharedPreferences.setMockInitialValues({'loggedIn': true, 'remoteFavorites': ['unowned-legacy'],
      'pendingRemoteFavorites': '{"unowned-legacy":true}'});
    directory = await Directory.systemTemp.createTemp('nest-sync-');
    auth = FakeAuth(); remote = FakeAccount(); app = create(); await app.init();
  });
  tearDown(() async { await app.close(); await auth.events.close(); await directory.delete(recursive: true); });

  test('a persisted demo flag does not authenticate or replay an unowned queue', () {
    expect(app.loggedIn, isFalse); expect(app.favorites, isEmpty); expect(remote.writes, isEmpty);
  });
  test('email confirmation does not create a fake signed-in session', () async {
    expect(await app.signUp('Reader', 'reader@example.com', 'password'), isFalse);
    expect(app.loggedIn, isFalse);
  });
  test('offline outbox survives restart and is isolated from the next account', () async {
    await app.signIn('a', 'password');
    remote.offline = true;
    await app.toggleFavorite('hidden-love'); await app.syncAccount();
    expect(app.pendingCount, 1); expect(app.favorites, {'hidden-love'});
    await app.signOut();
    await app.signIn('b', 'password');
    expect(app.favorites, isEmpty); expect(app.pendingCount, 0);
    await app.close(); app = create(); await app.init();
    expect(app.remoteUserId, 'b'); expect(app.favorites, isEmpty);
    remote.offline = false;
    await app.signIn('a', 'password'); await app.syncAccount();
    expect(app.favorites, {'hidden-love'}); expect(app.pendingCount, 0);
    expect(remote.data['b']?.favorites ?? {}, isEmpty);
    expect(remote.writes.every((w) => w.$1 == 'a'), isTrue);
  });
  test('rapid toggles preserve the latest intent while an earlier write is in flight', () async {
    await app.signIn('a', 'password');
    remote.writeGate = Completer<void>();
    await app.toggleFavorite('hidden-love');
    await remote.writeStarted.future;
    await app.toggleFavorite('hidden-love');
    remote.writeGate!.complete();
    await app.syncAccount();
    expect(app.favorites, isEmpty); expect(app.pendingCount, 0);
    expect(remote.data['a']!.favorites, isEmpty);
    expect(remote.writes.map((w) => w.$2.value['saved']), [true, false]);
  });
  test('a response from the previous user cannot overwrite the current library', () async {
    await app.signIn('a', 'password');
    remote.readGate = Completer<AccountSnapshot>();
    final oldSync = app.syncAccount();
    final oldGate = remote.readGate!;
    remote.readGate = null;
    await app.signIn('b', 'password');
    oldGate.complete(const AccountSnapshot(favorites: {'hidden-love'}, nickname: 'Account A', isAdmin: true));
    await oldSync;
    expect(app.remoteUserId, 'b'); expect(app.favorites, isEmpty); expect(app.isAdmin, isFalse);
    expect(remote.cancelledAccounts, greaterThanOrEqualTo(1));
  });
  test('foreground reconciliation incorporates another session changes', () async {
    await app.signIn('a', 'password');
    remote.data['a'] = const AccountSnapshot(favorites: {'hidden-love'});
    await app.retryCloud();
    expect(app.favorites, {'hidden-love'});
    final persisted = jsonDecode((await SharedPreferences.getInstance()).getString('account:a')!) as Map;
    expect(persisted['favorites'], ['hidden-love']); expect(persisted.containsKey('isAdmin'), isFalse);
  });
  test('review subscriptions are shared and released on the final listener', () async {
    app.retainReviews('hidden-love'); app.retainReviews('hidden-love');
    expect(remote.reviewSubscriptions, 1);
    app.releaseReviews('hidden-love'); expect(remote.cancelledReviews, 0);
    app.releaseReviews('hidden-love'); expect(remote.cancelledReviews, 1);
  });
}

class FakeAuth implements AuthRepository {
  final events = StreamController<SessionChange>.broadcast(sync: true);
  NestUser? user;
  @override NestUser? get currentUser => user;
  @override Stream<SessionChange> get changes => events.stream;
  @override Future<void> signIn(String email, String password) async {
    user = NestUser(email, email); events.add(SessionChange(user));
  }
  @override Future<bool> signUp(String nickname, String email, String password) async => false;
  @override Future<void> signOut() async { user = null; events.add(const SessionChange(null)); }
  @override Future<void> sendPasswordReset(String email) async {}
  @override Future<void> updatePassword(String password) async {}
}

class FakeAccount implements AccountRepository {
  bool offline = false;
  final data = <String, AccountSnapshot>{};
  final writes = <(String, PendingChange)>[];
  Completer<void>? writeGate;
  final writeStarted = Completer<void>();
  Completer<AccountSnapshot>? readGate;
  int cancelledAccounts = 0, reviewSubscriptions = 0, cancelledReviews = 0;
  @override Future<AccountSnapshot> load(String userId) async {
    if (offline) throw const ApiException(ApiFailureKind.offline, 'Offline');
    if (readGate != null) return readGate!.future;
    return data[userId] ?? const AccountSnapshot();
  }
  @override Future<void> apply(String userId, PendingChange change) async {
    if (offline) throw const ApiException(ApiFailureKind.offline, 'Offline');
    writes.add((userId, change));
    if (!writeStarted.isCompleted) writeStarted.complete();
    await writeGate?.future;
    final favorites = {...?data[userId]?.favorites};
    if (change.value['saved'] == true) { favorites.add(change.id); } else { favorites.remove(change.id); }
    data[userId] = AccountSnapshot(favorites: favorites);
  }
  @override CancelSubscription watchAccount(String userId, void Function() refresh, void Function(bool) connection) => () async { cancelledAccounts++; };
  @override CancelSubscription watchReviews(String dramaId, void Function() refresh, void Function(bool) connection) {
    reviewSubscriptions++; return () async { cancelledReviews++; };
  }
  @override Future<List<DramaReview>> reviews(String dramaId, String? userId) async => [];
  @override Future<void> saveReview(String userId, String dramaId, int stars, String content, bool spoiler) async {}
  @override Future<void> deleteReview(String userId, String reviewId) async {}
}
