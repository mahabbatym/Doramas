import 'dart:convert';

import 'package:flutter/material.dart';

class Drama {
  final String id;
  final String title;
  final String originalTitle;
  final String country;
  final int year;
  final String status;
  final String genre;
  final int episodes;
  final double score;
  final String description;
  final String? posterUrl;
  final String? backdropUrl;
  final Map<String, Map<String, String>> translations;
  final String symbol;
  final Color start;
  final Color end;
  final bool isCustom;

  const Drama({
    required this.id,
    required this.title,
    required this.originalTitle,
    required this.country,
    required this.year,
    this.status = 'released',
    required this.genre,
    required this.episodes,
    required this.score,
    required this.description,
    this.posterUrl,
    this.backdropUrl,
    this.translations = const {},
    required this.symbol,
    required this.start,
    required this.end,
    this.isCustom = false,
  });

  bool get isKorean => country == 'Корея';

  String localizedTitle(String locale) =>
      translations[locale]?['title'] ?? translations['en']?['title'] ?? title;

  String localizedDescription(String locale) =>
      translations[locale]?['description'] ??
      translations['en']?['description'] ??
      description;

  Map<String, Object?> toMap() => {
        'id': id,
        'title': title,
        'originalTitle': originalTitle,
        'country': country,
        'year': year,
        'status': status,
        'genre': genre,
        'episodes': episodes,
        'score': score,
        'description': description,
        'translations': jsonEncode(translations),
        'posterUrl': posterUrl,
        'backdropUrl': backdropUrl,
        'symbol': symbol,
        'startColor': start.toARGB32(),
        'endColor': end.toARGB32(),
        'isCustom': isCustom ? 1 : 0,
      };

  factory Drama.fromMap(Map<String, Object?> map) {
    final rawTranslations = map['translations'];
    final translations = <String, Map<String, String>>{};
    final decodedTranslations = rawTranslations is String
        ? _decodeTranslations(rawTranslations)
        : rawTranslations;
    if (decodedTranslations is Map) {
      for (final entry in decodedTranslations.entries) {
        if (entry.value is Map) {
          translations[entry.key.toString()] = Map<String, String>.from((entry
                  .value as Map)
              .map((key, value) => MapEntry(key.toString(), value.toString())));
        }
      }
    }
    return Drama(
      id: map['id']! as String,
      title: map['title']! as String,
      originalTitle: map['originalTitle']! as String,
      country: map['country']! as String,
      year: map['year']! as int,
      status: map['status'] as String? ?? 'released',
      genre: map['genre']! as String,
      episodes: map['episodes']! as int,
      score: (map['score'] as num).toDouble(),
      description: map['description']! as String,
      posterUrl: map['posterUrl'] as String?,
      backdropUrl: map['backdropUrl'] as String?,
      translations: translations,
      symbol: map['symbol']! as String,
      start: Color(map['startColor']! as int),
      end: Color(map['endColor']! as int),
      isCustom: map['isCustom'] == 1,
    );
  }

  static Object? _decodeTranslations(String value) {
    try {
      return jsonDecode(value);
    } on FormatException {
      return null;
    }
  }
}
