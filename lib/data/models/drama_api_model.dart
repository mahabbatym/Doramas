import 'package:flutter/material.dart';

import 'package:dorama_nest/data/models/drama.dart';

class DramaApiModel {
  const DramaApiModel._();

  static Drama fromJson(Map<String, dynamic> json, {required String locale}) {
    final translations = _maps(json['drama_translations']);
    final translation = localizedRow(
      translations,
      locale: locale,
      localeKey: 'locale',
    );
    final translationMap = <String, Map<String, String>>{};
    for (final row in translations) {
      final rowLocale = row['locale']?.toString();
      if (rowLocale == null) continue;
      translationMap[rowLocale] = {
        'title': row['title']?.toString() ?? '',
        'description': row['description']?.toString() ?? '',
      };
    }
    final links = _maps(json['drama_genres']);
    final genreNames = <String>[];
    for (final link in links) {
      final genre = _map(link['genres']);
      final genreTranslations = _maps(genre['genre_translations']);
      final row = localizedRow(
        genreTranslations,
        locale: locale,
        localeKey: 'locale',
      );
      final name = row?['name']?.toString();
      if (name != null && name.isNotEmpty) genreNames.add(name);
    }
    final episodeRows = _maps(json['episodes']);
    final countryCode = json['country']?.toString() ?? 'KR';
    final colors = _colors(genreNames.firstOrNull ?? '');
    return Drama(
      id: json['id']?.toString() ?? '',
      title: translation?['title']?.toString() ?? 'Untitled drama',
      originalTitle: translation?['title']?.toString() ?? 'Untitled drama',
      country: countryCode == 'CN' ? 'Китай' : 'Корея',
      year: _integer(json['release_year'], fallback: 2000),
      status: json['status']?.toString() ?? 'released',
      genre: genreNames.firstOrNull ?? _slugLabel(links),
      episodes: episodeRows.isEmpty ? 1 : episodeRows.length,
      score: _decimal(json['rating'], fallback: 0),
      description: translation?['description']?.toString() ?? '',
      posterUrl: json['poster_url']?.toString(),
      backdropUrl: json['backdrop_url']?.toString(),
      translations: translationMap,
      symbol: countryCode == 'CN' ? '✿' : '✦',
      start: colors.$1,
      end: colors.$2,
      isCustom: true,
    );
  }

  static Map<String, dynamic>? localizedRow(
    List<Map<String, dynamic>> rows, {
    required String locale,
    required String localeKey,
  }) {
    if (rows.isEmpty) return null;
    for (final wanted in [locale, 'en']) {
      for (final row in rows) {
        if (row[localeKey] == wanted) return row;
      }
    }
    return rows.first;
  }

  static List<Map<String, dynamic>> _maps(Object? value) {
    if (value is! List) return const [];
    return value
        .whereType<Map>()
        .map((row) => Map<String, dynamic>.from(row))
        .toList(growable: false);
  }

  static Map<String, dynamic> _map(Object? value) {
    if (value is Map<String, dynamic>) return value;
    if (value is Map) return Map<String, dynamic>.from(value);
    return const {};
  }

  static String _slugLabel(List<Map<String, dynamic>> links) {
    if (links.isEmpty) return 'Драма';
    final genre = _map(links.first['genres']);
    final slug = genre['slug']?.toString() ?? '';
    return switch (slug) {
      'romance' => 'Романтика',
      'comedy' => 'Комедия',
      'fantasy' => 'Фэнтези',
      'music' => 'Музыка',
      'drama' => 'Драма',
      'mystery' => 'Детектив',
      _ => slug,
    };
  }

  static (Color, Color) _colors(String genre) => switch (genre) {
        'Комедия' => (const Color(0xFFF4B99D), const Color(0xFFDE7F83)),
        'Музыка' => (const Color(0xFF68B7C3), const Color(0xFF343D83)),
        'Фэнтези' => (const Color(0xFF9F9BC8), const Color(0xFF53638C)),
        _ => (const Color(0xFFEDAAB1), const Color(0xFF925A8A)),
      };

  static int _integer(Object? value, {required int fallback}) =>
      value is num ? value.toInt() : fallback;

  static double _decimal(Object? value, {required double fallback}) =>
      value is num ? value.toDouble() : fallback;
}
