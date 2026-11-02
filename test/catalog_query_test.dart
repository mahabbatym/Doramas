import 'package:flutter/material.dart';
import 'package:dorama_nest/data/models/drama.dart';
import 'package:dorama_nest/data/models/drama_api_model.dart';
import 'package:dorama_nest/data/services/catalog_query.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('uses selected locale, then English, then any available translation',
      () {
    const rows = [
      {'locale': 'ru', 'title': 'Russian'},
      {'locale': 'en', 'title': 'English'},
    ];

    expect(
      DramaApiModel.localizedRow(rows,
          locale: 'kk', localeKey: 'locale')?['title'],
      'English',
    );
    expect(
      DramaApiModel.localizedRow([rows.first],
          locale: 'kk', localeKey: 'locale')?['title'],
      'Russian',
    );
    expect(
      DramaApiModel.localizedRow(rows,
          locale: 'ru', localeKey: 'locale')?['title'],
      'Russian',
    );
  });

  test('combines catalog filters and sorts in both directions', () {
    final koreanRomance = const CatalogQuery(
      country: 'Корея',
      genre: 'Романтика',
      sort: CatalogSort.rating,
      descending: true,
    ).apply([
      _drama('a', 'A Story', 'Корея', 'Романтика', 2020, 8.1),
      _drama('b', 'B Story', 'Корея', 'Романтика', 2022, 9.4),
      _drama('c', 'C Story', 'Китай', 'Романтика', 2024, 9.8),
      _drama('d', 'D Story', 'Корея', 'Комедия', 2024, 9.9),
    ]);
    expect(koreanRomance.map((drama) => drama.id), ['b', 'a']);

    final titleOrder = const CatalogQuery(sort: CatalogSort.title).apply([
      _drama('b', 'B', 'Корея', 'Романтика', 2024, 9),
      _drama('a', 'A', 'Корея', 'Романтика', 2024, 9),
    ]);
    expect(titleOrder.map((drama) => drama.id), ['a', 'b']);

    final narrowed = const CatalogQuery(
      country: 'Корея',
      genre: 'Романтика',
      year: 2024,
      status: 'completed',
    ).apply([
      _drama('a', 'A', 'Корея', 'Романтика', 2024, 9)
          .copyWithStatus('completed'),
      _drama('b', 'B', 'Корея', 'Романтика', 2024, 9),
    ]);
    expect(narrowed.map((drama) => drama.id), ['a']);
  });
}

Drama _drama(String id, String title, String country, String genre, int year,
        double score) =>
    Drama(
      id: id,
      title: title,
      originalTitle: title,
      country: country,
      year: year,
      genre: genre,
      episodes: 12,
      score: score,
      description: '',
      symbol: '✦',
      start: const Color(0xFFEDAAB1),
      end: const Color(0xFF925A8A),
    );

extension on Drama {
  Drama copyWithStatus(String value) => Drama(
        id: id,
        title: title,
        originalTitle: originalTitle,
        country: country,
        year: year,
        status: value,
        genre: genre,
        episodes: episodes,
        score: score,
        description: description,
        symbol: symbol,
        start: start,
        end: end,
      );
}
