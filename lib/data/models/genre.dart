class Genre {
  final String id;
  final String name;

  const Genre({required this.id, required this.name});

  Map<String, Object?> toMap() => {'id': id, 'name': name};

  factory Genre.fromMap(Map<String, Object?> map) => Genre(
        id: map['id']! as String,
        name: map['name']! as String,
      );
}
