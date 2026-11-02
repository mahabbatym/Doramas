class DramaReview {
  final String id;
  final String dramaId;
  final String author;
  final int stars;
  final String content;
  final bool spoiler;
  final bool mine;
  final DateTime createdAt;

  const DramaReview({
    required this.id,
    required this.dramaId,
    required this.author,
    required this.stars,
    required this.content,
    required this.spoiler,
    required this.mine,
    required this.createdAt,
  });

  DramaReview copyWith({int? stars, String? content, bool? spoiler}) =>
      DramaReview(
        id: id,
        dramaId: dramaId,
        author: author,
        stars: stars ?? this.stars,
        content: content ?? this.content,
        spoiler: spoiler ?? this.spoiler,
        mine: mine,
        createdAt: createdAt,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'dramaId': dramaId,
        'author': author,
        'stars': stars,
        'content': content,
        'spoiler': spoiler,
        'mine': mine,
        'createdAt': createdAt.toIso8601String(),
      };

  Map<String, Object?> toMap() => {
        'id': id,
        'dramaId': dramaId,
        'author': author,
        'stars': stars,
        'content': content,
        'spoiler': spoiler ? 1 : 0,
        'mine': mine ? 1 : 0,
        'createdAt': createdAt.toIso8601String(),
      };

  factory DramaReview.fromJson(Map<String, dynamic> json) => DramaReview(
        id: json['id'] as String,
        dramaId: json['dramaId'] as String,
        author: json['author'] as String? ?? 'Гость',
        stars: json['stars'] as int? ?? 5,
        content: json['content'] as String? ?? '',
        spoiler: json['spoiler'] as bool? ?? false,
        mine: json['mine'] as bool? ?? false,
        createdAt: DateTime.tryParse(json['createdAt'] as String? ?? '') ??
            DateTime.now(),
      );

  factory DramaReview.fromMap(Map<String, Object?> map) => DramaReview(
        id: map['id']! as String,
        dramaId: map['dramaId']! as String,
        author: map['author']! as String,
        stars: map['stars']! as int,
        content: map['content']! as String,
        spoiler: map['spoiler'] == 1,
        mine: map['mine'] == 1,
        createdAt: DateTime.parse(map['createdAt']! as String),
      );
}
