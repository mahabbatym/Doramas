class Favorite {
  final String dramaId;
  final DateTime addedAt;

  const Favorite({required this.dramaId, required this.addedAt});

  Map<String, Object?> toMap() => {
        'dramaId': dramaId,
        'addedAt': addedAt.toIso8601String(),
      };

  factory Favorite.fromMap(Map<String, Object?> map) => Favorite(
        dramaId: map['dramaId']! as String,
        addedAt: DateTime.parse(map['addedAt']! as String),
      );
}
