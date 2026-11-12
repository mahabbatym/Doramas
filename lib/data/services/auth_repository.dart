import 'dart:async';
import 'package:supabase_flutter/supabase_flutter.dart';

class NestUser {
  const NestUser(this.id, this.nickname, {this.anonymous = false});
  final String id;
  final String nickname;
  final bool anonymous;
}

class SessionChange {
  const SessionChange(this.user, {this.passwordRecovery = false});
  final NestUser? user;
  final bool passwordRecovery;
}

abstract interface class AuthRepository {
  NestUser? get currentUser;
  Stream<SessionChange> get changes;
  Future<void> signIn(String email, String password);
  Future<bool> signUp(String nickname, String email, String password);
  Future<void> signOut();
  Future<void> sendPasswordReset(String email);
  Future<void> updatePassword(String password);
}

class SupabaseAuthRepository implements AuthRepository {
  SupabaseAuthRepository(this.client);
  final SupabaseClient client;
  static const redirectUrl = 'doramanest://auth-callback';
  NestUser? _user(User? user) => user == null ? null : NestUser(
    user.id, user.userMetadata?['nickname'] as String? ?? '', anonymous: user.isAnonymous);

  @override
  NestUser? get currentUser => _user(client.auth.currentUser);
  @override
  Stream<SessionChange> get changes => client.auth.onAuthStateChange.map((state) =>
    SessionChange(_user(state.session?.user), passwordRecovery: state.event == AuthChangeEvent.passwordRecovery));
  @override
  Future<void> signIn(String email, String password) async {
    await client.auth.signInWithPassword(email: email.trim(), password: password).timeout(const Duration(seconds: 20));
  }
  @override
  Future<bool> signUp(String nickname, String email, String password) async {
    if (currentUser?.anonymous == true) {
      // Upgrade the old anonymous account in place, retaining its user ID and data.
      await client.auth.updateUser(UserAttributes(email: email.trim(), password: password,
        data: {'nickname': nickname.trim()}), emailRedirectTo: redirectUrl).timeout(const Duration(seconds: 20));
      return false;
    }
    final response = await client.auth.signUp(email: email.trim(), password: password,
      data: {'nickname': nickname.trim()}, emailRedirectTo: redirectUrl).timeout(const Duration(seconds: 20));
    return response.session != null;
  }
  @override
  Future<void> signOut() => client.auth.signOut(scope: SignOutScope.local);
  @override
  Future<void> sendPasswordReset(String email) => client.auth.resetPasswordForEmail(
    email.trim(), redirectTo: redirectUrl).timeout(const Duration(seconds: 20));
  @override
  Future<void> updatePassword(String password) async {
    await client.auth.updateUser(UserAttributes(password: password)).timeout(const Duration(seconds: 20));
  }
}
