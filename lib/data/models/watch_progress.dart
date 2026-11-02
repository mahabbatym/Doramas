class WatchProgress {
  final String dramaId;
  final int episodesWatched;
  final DateTime updatedAt;

  const WatchProgress({
    required this.dramaId,
    required this.episodesWatched,
    required this.updatedAt,
  });

  Map<String, Object?> toMap() => {
        'dramaId': dramaId,
        'episodesWatched': episodesWatched,
        'updatedAt': updatedAt.toIso8601String(),
      };

  factory WatchProgress.fromMap(Map<String, Object?> map) => WatchProgress(
        dramaId: map['dramaId']! as String,
        episodesWatched: map['episodesWatched']! as int,
        updatedAt: DateTime.parse(map['updatedAt']! as String),
      );
}
