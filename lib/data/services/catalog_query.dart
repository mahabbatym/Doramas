import 'package:dorama_nest/data/models/drama.dart';

class CatalogQuery {
  const CatalogQuery({
    this.country,
    this.genre,
    this.year,
    this.status,
    this.query = '',
    this.locale = 'en',
    this.sort = CatalogSort.title,
    this.descending = false,
  });

  final String? country;
  final String? genre;
  final int? year;
  final String? status;
  final String query;
  final String locale;
  final CatalogSort sort;
  final bool descending;

  List<Drama> apply(Iterable<Drama> source) {
    final needle = query.trim().toLowerCase();
    final results = source.where((drama) {
      if (country != null && drama.country != country) return false;
      if (genre != null && _genreKey(drama.genre) != _genreKey(genre!)) {
        return false;
      }
      if (year != null && drama.year != year) return false;
      if (status != null && drama.status != status) return false;
      if (needle.isEmpty) return true;
      return drama.localizedTitle(locale).toLowerCase().contains(needle) ||
          drama.translations.values.any(
              (row) => (row['title'] ?? '').toLowerCase().contains(needle)) ||
          drama.originalTitle.toLowerCase().contains(needle);
    }).toList();
    results.sort((left, right) {
      final compare = switch (sort) {
        CatalogSort.title =>
          left.localizedTitle(locale).toLowerCase().compareTo(
                right.localizedTitle(locale).toLowerCase(),
              ),
        CatalogSort.releaseYear => left.year.compareTo(right.year),
        CatalogSort.rating => left.score.compareTo(right.score),
      };
      return descending ? -compare : compare;
    });
    return results;
  }
}

String _genreKey(String value) => switch (value.toLowerCase()) {
      'романтика' || 'romance' || '로맨스' => 'romance',
      'комедия' || 'comedy' || '코미디' => 'comedy',
      'фэнтези' || 'fantasy' || '판타지' => 'fantasy',
      'музыка' || 'music' || '음악' => 'music',
      'драма' || 'drama' || '드라마' => 'drama',
      'отбасы' || 'семейная история' || 'family' || '가족' => 'family',
      'шытырман оқиға' || 'приключения' || 'action' || '액션' => 'action',
      'детектив' || 'mystery' || '미스터리' => 'mystery',
      _ => value.toLowerCase(),
    };

enum CatalogSort { title, releaseYear, rating }
