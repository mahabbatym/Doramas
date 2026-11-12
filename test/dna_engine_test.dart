import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:dorama_nest/data/models/dna_preferences.dart';
import 'package:dorama_nest/data/models/drama.dart';
import 'package:dorama_nest/data/models/review.dart';
import 'package:dorama_nest/data/models/watch_progress.dart';
import 'package:dorama_nest/data/services/dna_engine.dart';

void main() {
  final catalog = [drama('romance', ['romance']), drama('comedy', ['comedy']),
    drama('both', ['romance', 'comedy']), drama('other-romance', ['romance'])];
  List<DnaMatch> recommend({Set<String> favorites = const {}, Map<String, WatchProgress> progress = const {},
    List<DramaReview> reviews = const [], DnaPreferences preferences = const DnaPreferences()}) =>
    DnaEngine().recommend(catalog: catalog, favorites: favorites, progress: progress, reviews: reviews, preferences: preferences);

  test('cold start has no fabricated personal percentages, even with a mood', () {
    expect(recommend().every((m) => m.score == null), isTrue);
    final filtered = recommend(preferences: const DnaPreferences(mood: DramaMood.romantic));
    expect(filtered.map((m) => m.drama.id), isNot(contains('comedy')));
    expect(filtered.every((m) => m.score == null && m.mood == DramaMood.romantic), isTrue);
  });
  test('explicit preference uses cosine similarity with normalized available weights', () {
    final matches = recommend(preferences: const DnaPreferences(genres: {'romance'}));
    expect(matches.firstWhere((m) => m.drama.id == 'romance').score, 100);
    expect(matches.firstWhere((m) => m.drama.id == 'both').score, 71);
    expect(matches.firstWhere((m) => m.drama.id == 'comedy').score, 0);
    expect(matches.first.genres, ['romance']);
  });
  test('completed and dropped dramas are excluded and negative history affects ranking', () {
    final matches = recommend(progress: {
      'romance': progress('romance', WatchStatus.completed, 16),
      'comedy': progress('comedy', WatchStatus.dropped, 3),
    });
    expect(matches.map((m) => m.drama.id), ['other-romance', 'both']);
    expect(matches.first.score, greaterThan(matches.last.score!));
  });
  test('favorites and high ratings change recommendations deterministically', () {
    final matches = recommend(favorites: {'comedy'}, reviews: [DramaReview(
      id: 'r', dramaId: 'comedy', author: 'A', stars: 5, content: 'A lovely comedy',
      spoiler: false, mine: true, createdAt: DateTime.utc(2026))]);
    expect(matches.first.drama.id, 'comedy');
    expect(matches.first.signals, 1);
    expect(matches.every((m) => m.score! >= 0 && m.score! <= 100), isTrue);
    expect(recommend(favorites: {'comedy'}).map((m) => m.drama.id), matches.map((m) => m.drama.id));
  });
  test('recommendations do not change when display language changes', () {
    final original = drama('a', ['romance', 'comedy']);
    final localized = Drama.fromMap({...original.toMap(), 'genre': '코미디'});
    final engine = DnaEngine();
    int? score(Drama d) => engine.recommend(catalog: [d], favorites: {}, progress: {}, reviews: [],
      preferences: const DnaPreferences(genres: {'romance'})).single.score;
    expect(score(original), score(localized));
  });
}

Drama drama(String id, List<String> genres) => Drama(id: id, title: id, originalTitle: id,
  country: 'Корея', year: 2024, genre: genres.first, genreSlugs: genres, episodes: 16,
  score: 8, description: '', symbol: '', start: Colors.blue, end: Colors.pink);
WatchProgress progress(String id, WatchStatus status, int episodes) => WatchProgress(
  dramaId: id, episodesWatched: episodes, status: status, updatedAt: DateTime.utc(2026));
