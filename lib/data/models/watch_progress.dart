enum WatchStatus { planned, watching, completed, dropped }

class WatchProgress {
  final String dramaId;
  final int episodesWatched;
  final DateTime updatedAt;
  final WatchStatus status;

  const WatchProgress({
    required this.dramaId,
    required this.episodesWatched,
    required this.updatedAt,
    this.status = WatchStatus.watching,
  });

  Map<String, Object?> toMap() => {
        'dramaId': dramaId,
        'episodesWatched': episodesWatched,
        'updatedAt': updatedAt.toIso8601String(),
        'status': status.name,
      };

  factory WatchProgress.fromMap(Map<String, Object?> map) => WatchProgress(
        dramaId: map['dramaId']! as String,
        episodesWatched: map['episodesWatched']! as int,
        updatedAt: DateTime.parse(map['updatedAt']! as String),
        status: WatchStatus.values.where((s) => s.name == map['status']).firstOrNull ?? WatchStatus.watching,
      );
}
