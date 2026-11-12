enum DramaMood { romantic, emotional, funny, thriller, comfort }

class DnaPreferences {
  const DnaPreferences({this.genres = const {}, this.mood});
  final Set<String> genres;
  final DramaMood? mood;

  Map<String, Object?> toJson() => {
    'genres': genres.toList()..sort(), 'mood': mood?.name,
  };

  factory DnaPreferences.fromJson(Map<String, dynamic> json) => DnaPreferences(
    genres: (json['genres'] as List? ?? const []).whereType<String>().toSet(),
    mood: DramaMood.values.where((m) => m.name == json['mood']).firstOrNull,
  );
}
