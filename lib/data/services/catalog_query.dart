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
      if (genre != null && !drama.genreKeys.contains(genreKey(genre!))) {
        return false;
      }
      if (year != null && drama.year != year) return false;
      if (status != null && drama.status != status) return false;
      if (needle.isEmpty) return true;
      return drama.localizedTitle(locale).toLowerCase().contains(needle) ||
          drama.translations.values.any(
              (row) => (row['title'] ?? '').toLowerCase().contains(needle)) ||
          drama.originalTitle.toLowerCase().contains(needle) ||
          drama.genre.toLowerCase().contains(needle) ||
          drama.genreKeys.any((g) => g.contains(needle)) ||
          drama.country.toLowerCase().contains(needle) || drama.year.toString() == needle;
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

enum CatalogSort { title, releaseYear, rating }
