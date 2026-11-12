import 'dart:async';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:dorama_nest/data/api/api_client.dart';
import 'package:dorama_nest/data/api/api_exception.dart';
import 'package:dorama_nest/data/models/account_snapshot.dart';
import 'package:dorama_nest/data/models/dna_preferences.dart';
import 'package:dorama_nest/data/models/review.dart';
import 'package:dorama_nest/data/models/watch_progress.dart';

typedef CancelSubscription = Future<void> Function();

abstract interface class AccountRepository {
  Future<AccountSnapshot> load(String userId);
  Future<void> apply(String userId, PendingChange change);
  Future<List<DramaReview>> reviews(String dramaId, String? userId);
  Future<void> saveReview(String userId, String dramaId, int stars, String content, bool spoiler);
  Future<void> deleteReview(String userId, String reviewId);
  CancelSubscription watchAccount(String userId, void Function() refresh, void Function(bool) connection);
  CancelSubscription watchReviews(String dramaId, void Function() refresh, void Function(bool) connection);
}

class SupabaseAccountRepository implements AccountRepository {
  SupabaseAccountRepository({required this.api, required this.client});
  final ApiClient api;
  final SupabaseClient client;
  int _channelSequence = 0;

  @override
  Future<AccountSnapshot> load(String userId) async {
    final results = await Future.wait([
      api.getAllRows('favorites', query: {'user_id': 'eq.$userId', 'order': 'drama_id.asc'}),
      api.getAllRows('watch_progress', query: {'user_id': 'eq.$userId', 'order': 'drama_id.asc'}),
      api.getAllRows('reviews', query: {'user_id': 'eq.$userId', 'is_deleted': 'eq.false', 'order': 'id.asc'}),
      api.getRows('user_preferences', query: {'user_id': 'eq.$userId', 'limit': '1'}),
      api.getRows('profiles', query: {'id': 'eq.$userId', 'select': 'nickname,is_admin', 'limit': '1'}),
    ]);
    if (results[4].isEmpty) {
      throw const ApiException(ApiFailureKind.notFound, 'The linked profile is missing.');
    }
    return AccountSnapshot(
      favorites: results[0].where((r) => r['is_saved'] == true).map((r) => r['drama_id'] as String).toSet(),
      progress: {for (final row in results[1]) row['drama_id'] as String: WatchProgress(
        dramaId: row['drama_id'] as String, episodesWatched: (row['episodes_watched'] as num).toInt(),
        updatedAt: DateTime.parse(row['updated_at'] as String),
        status: WatchStatus.values.firstWhere((s) => s.name == row['status']))},
      reviews: results[2].map((r) => _review(r, userId)).toList(),
      preferences: DnaPreferences.fromJson(results[3].firstOrNull ?? {}),
      nickname: results[4].first['nickname'] as String? ?? '',
      isAdmin: results[4].first['is_admin'] == true,
    );
  }

  @override
  Future<void> apply(String userId, PendingChange change) async {
    final (table, conflict, body) = switch (change.kind) {
      'favorite' => ('favorites', 'user_id,drama_id', <String, Object?>{
        'user_id': userId, 'drama_id': change.id, 'is_saved': change.value['saved']}),
      'progress' => ('watch_progress', 'user_id,drama_id', <String, Object?>{
        'user_id': userId, 'drama_id': change.id,
        'episodes_watched': change.value['episodesWatched'], 'status': change.value['status']}),
      'preferences' => ('user_preferences', 'user_id', <String, Object?>{
        'user_id': userId, ...change.value}),
      _ => throw const ApiException(ApiFailureKind.invalidRequest, 'Unsupported account mutation.'),
    };
    await api.postRows(table, body, query: {'on_conflict': conflict},
      prefer: 'resolution=merge-duplicates,return=minimal');
  }

  @override
  Future<List<DramaReview>> reviews(String dramaId, String? userId) async =>
    (await api.getAllRows('reviews', query: {'drama_id': 'eq.$dramaId',
      'is_deleted': 'eq.false', 'order': 'created_at.desc,id.asc'})).map((r) => _review(r, userId)).toList();

  @override
  Future<void> saveReview(String userId, String dramaId, int stars, String content, bool spoiler) async {
    await api.postRows('reviews', {
      'user_id': userId, 'drama_id': dramaId, 'stars': stars,
      'content': content.trim(), 'spoiler': spoiler, 'is_deleted': false,
    }, query: const {'on_conflict': 'user_id,drama_id'},
      prefer: 'resolution=merge-duplicates,return=minimal');
  }

  @override
  Future<void> deleteReview(String userId, String reviewId) async {
    await api.patchRows('reviews', {'is_deleted': true, 'content': '', 'spoiler': false},
      query: {'id': 'eq.$reviewId', 'user_id': 'eq.$userId'});
  }

  @override
  CancelSubscription watchAccount(String userId, void Function() refresh, void Function(bool) connection) =>
    _watch('account', {
      for (final table in ['favorites', 'watch_progress', 'user_preferences', 'reviews'])
        table: PostgresChangeFilter(type: PostgresChangeFilterType.eq, column: 'user_id', value: userId),
    }, refresh, connection);

  @override
  CancelSubscription watchReviews(String dramaId, void Function() refresh, void Function(bool) connection) =>
    _watch('reviews', {'reviews': PostgresChangeFilter(type: PostgresChangeFilterType.eq,
      column: 'drama_id', value: dramaId)}, refresh, connection);

  CancelSubscription _watch(String name, Map<String, PostgresChangeFilter> tables,
      void Function() refresh, void Function(bool) connection) {
    var closed = false;
    final channel = client.channel('nest:$name:${_channelSequence++}');
    for (final entry in tables.entries) {
      channel.onPostgresChanges(event: PostgresChangeEvent.all, schema: 'public',
        table: entry.key, filter: entry.value, callback: (_) { if (!closed) refresh(); });
    }
    channel.subscribe((status, error) {
      if (closed) return;
      final connected = status == RealtimeSubscribeStatus.subscribed;
      connection(connected);
      // Every rejoin fetches a snapshot to recover events missed while offline.
      if (connected) refresh();
    });
    return () async {
      closed = true;
      await client.removeChannel(channel);
    };
  }

  DramaReview _review(Map<String, dynamic> row, String? userId) => DramaReview(
    id: row['id'] as String, dramaId: row['drama_id'] as String,
    author: row['author_name'] as String? ?? 'DoramaNest',
    stars: (row['stars'] as num).toInt(), content: row['content'] as String,
    spoiler: row['spoiler'] == true, mine: row['user_id'] == userId,
    createdAt: DateTime.parse(row['created_at'] as String));
}
