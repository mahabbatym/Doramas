import 'package:dorama_nest/data/models/dna_preferences.dart';
import 'package:dorama_nest/data/models/review.dart';
import 'package:dorama_nest/data/models/watch_progress.dart';

class AccountSnapshot {
  const AccountSnapshot({this.favorites = const {}, this.progress = const {},
    this.reviews = const [], this.preferences = const DnaPreferences(),
    this.nickname = '', this.isAdmin = false});
  final Set<String> favorites;
  final Map<String, WatchProgress> progress;
  final List<DramaReview> reviews;
  final DnaPreferences preferences;
  final String nickname;
  final bool isAdmin;

  Map<String, Object?> toJson() => {
    'favorites': favorites.toList(),
    'progress': progress.values.map((p) => p.toMap()).toList(),
    'reviews': reviews.map((r) => r.toJson()).toList(),
    'preferences': preferences.toJson(), 'nickname': nickname,
    // Admin capability is always fetched from the server, never trusted from cache.
  };

  factory AccountSnapshot.fromJson(Map<String, dynamic> json) => AccountSnapshot(
    favorites: (json['favorites'] as List? ?? const []).whereType<String>().toSet(),
    progress: {for (final p in (json['progress'] as List? ?? const []))
      (p as Map)['dramaId'] as String: WatchProgress.fromMap(Map<String, Object?>.from(p))},
    reviews: (json['reviews'] as List? ?? const []).map((r) => DramaReview.fromJson(Map<String, dynamic>.from(r as Map))).toList(),
    preferences: DnaPreferences.fromJson(Map<String, dynamic>.from(json['preferences'] as Map? ?? const {})),
    nickname: json['nickname'] as String? ?? '',
  );
}

class PendingChange {
  const PendingChange({required this.kind, required this.id, required this.value, required this.revision});
  final String kind;
  final String id;
  final Map<String, dynamic> value;
  final int revision;
  String get key => '$kind:$id';
  Map<String, dynamic> toJson() => {'kind': kind, 'id': id, 'value': value, 'revision': revision};
  factory PendingChange.fromJson(Map<String, dynamic> json) => PendingChange(
    kind: json['kind'] as String, id: json['id'] as String,
    value: Map<String, dynamic>.from(json['value'] as Map), revision: json['revision'] as int);
}
