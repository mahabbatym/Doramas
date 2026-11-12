import 'dart:math' as math;
import 'package:dorama_nest/data/models/dna_preferences.dart';
import 'package:dorama_nest/data/models/drama.dart';
import 'package:dorama_nest/data/models/review.dart';
import 'package:dorama_nest/data/models/watch_progress.dart';

class DnaMatch {
  const DnaMatch({required this.drama, required this.score, required this.genres,
    required this.mood, required this.similarLength, required this.signals});
  final Drama drama;
  /// A content similarity index, not a probability of liking a drama.
  /// Null means there is no personal evidence, even if a mood was selected.
  final int? score;
  final List<String> genres;
  final DramaMood? mood;
  final bool similarLength;
  final int signals;
}

class DnaEngine {
  static const supportedGenres = ['romance', 'comedy', 'fantasy', 'music',
    'drama', 'mystery', 'family', 'action', 'thriller'];
  static const moodGenres = {
    DramaMood.romantic: {'romance'},
    DramaMood.emotional: {'drama'},
    DramaMood.funny: {'comedy'},
    DramaMood.thriller: {'thriller', 'mystery', 'action'},
    DramaMood.comfort: {'family', 'comedy', 'music'},
  };

  List<DnaMatch> recommend({required List<Drama> catalog,
    required Set<String> favorites, required Map<String, WatchProgress> progress,
    required List<DramaReview> reviews, required DnaPreferences preferences,
    int limit = 12}) {
    final weights = <String, double>{};
    final countries = <String, double>{};
    var episodeSum = 0.0;
    var episodeWeight = 0.0;
    var signals = preferences.genres.length;
    for (final genre in preferences.genres) { weights[genre] = 3; }
    for (final drama in catalog) {
      var weight = favorites.contains(drama.id) ? 3.0 : 0.0;
      final history = progress[drama.id];
      weight += switch (history?.status) {
        WatchStatus.completed => 2,
        WatchStatus.dropped => -3,
        WatchStatus.watching => drama.episodes > 0 ? history!.episodesWatched / drama.episodes : 0,
        _ => 0,
      };
      final rating = reviews.where((r) => r.dramaId == drama.id && r.mine).firstOrNull;
      if (rating != null) weight += (rating.stars - 3) * 2;
      if (weight == 0) continue;
      signals++;
      for (final genre in drama.genreKeys) {
        weights[genre] = (weights[genre] ?? 0) + weight / drama.genreKeys.length;
      }
      countries[drama.country] = (countries[drama.country] ?? 0) + weight;
      if (weight > 0) {
        episodeSum += drama.episodes * weight;
        episodeWeight += weight;
      }
    }
    final norm = math.sqrt(weights.values.fold(0.0, (sum, w) => sum + w * w));
    final maxCountry = countries.values.fold(0.0, (a, b) => math.max(a, b.abs()));
    final preferredEpisodes = episodeWeight == 0 ? null : episodeSum / episodeWeight;
    final mood = preferences.mood;
    final matches = <DnaMatch>[];
    for (final drama in catalog) {
      final history = progress[drama.id];
      if (history?.status == WatchStatus.completed || history?.status == WatchStatus.dropped ||
          (history?.episodesWatched ?? 0) >= drama.episodes) continue;
      if (drama.status == 'announced') continue;
      final keys = drama.genreKeys;
      final moodFits = mood != null && keys.intersection(moodGenres[mood]!).isNotEmpty;
      if (mood != null && !moodFits) continue;
      var weightedScore = 0.0;
      var denominator = 0.0;
      if (norm > 0) {
        final dot = keys.fold(0.0, (sum, g) => sum + (weights[g] ?? 0));
        weightedScore += .70 * (dot / (norm * math.sqrt(keys.length))).clamp(0.0, 1.0);
        denominator += .70;
      }
      if (maxCountry > 0) {
        weightedScore += .15 * ((countries[drama.country] ?? 0) / maxCountry).clamp(0.0, 1.0);
        denominator += .15;
      }
      final lengthFit = preferredEpisodes == null ? 0.0 :
        (1 - (drama.episodes - preferredEpisodes).abs() / math.max(drama.episodes, preferredEpisodes)).clamp(0.0, 1.0);
      if (preferredEpisodes != null) { weightedScore += .15 * lengthFit; denominator += .15; }
      final matchingGenres = keys.where((g) => (weights[g] ?? 0) > 0).toList()
        ..sort((a, b) => weights[b]!.compareTo(weights[a]!));
      matches.add(DnaMatch(drama: drama,
        score: signals == 0 || denominator == 0 ? null : (100 * weightedScore / denominator).round().clamp(0, 100),
        genres: matchingGenres.take(2).toList(), mood: moodFits ? mood : null,
        similarLength: preferredEpisodes != null && lengthFit >= .8, signals: signals));
    }
    matches.sort((a, b) {
      final score = (b.score ?? -1).compareTo(a.score ?? -1);
      if (score != 0) return score;
      final rating = b.drama.score.compareTo(a.drama.score);
      return rating != 0 ? rating : a.drama.id.compareTo(b.drama.id);
    });
    return matches.take(limit).toList();
  }
}
