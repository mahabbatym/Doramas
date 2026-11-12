import 'package:flutter/material.dart';
import 'package:dorama_nest/core/l10n/generated/app_localizations.dart';
import 'package:dorama_nest/core/locale_text.dart';
import 'package:dorama_nest/core/theme/app_theme.dart';
import 'package:dorama_nest/core/widgets/nest_widgets.dart';
import 'package:dorama_nest/data/models/dna_preferences.dart';
import 'package:dorama_nest/data/services/dna_engine.dart';
import 'package:dorama_nest/state/app_controller.dart';

class DnaPreview extends StatelessWidget {
  const DnaPreview({super.key});
  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return Semantics(button: true, child: InkWell(
      borderRadius: BorderRadius.circular(24),
      onTap: () => Navigator.pushNamed(context, '/dna'),
      child: Container(padding: const EdgeInsets.all(21), decoration: BoxDecoration(
        color: context.nestSoftBlue, borderRadius: BorderRadius.circular(24),
        border: Border.all(color: NestColors.blue.withValues(alpha: .18))),
        child: Row(children: [
          const Icon(Icons.auto_awesome_outlined, color: NestColors.blue, size: 32),
          const SizedBox(width: 15),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(l.dnaTitle, style: const TextStyle(color: NestColors.blue, fontWeight: FontWeight.w900, letterSpacing: 1.4)),
            const SizedBox(height: 6),
            Text(l.dnaSubtitle, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 7),
            Text(l.dnaOpen, style: Theme.of(context).textTheme.bodySmall),
          ])),
          const Icon(Icons.chevron_right_rounded, color: NestColors.blue),
        ])),
    ));
  }
}

class DnaPage extends StatelessWidget {
  const DnaPage({super.key});
  Future<void> _update(BuildContext context, DnaPreferences value) async {
    try { await AppScope.of(context).setDnaPreferences(value); }
    catch (_) {
      if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(AppLocalizations.of(context)!.apiUnknown)));
    }
  }
  @override
  Widget build(BuildContext context) {
    final app = AppScope.of(context);
    final l = AppLocalizations.of(context)!;
    final prefs = app.dnaPreferences;
    final matches = app.recommendations;
    return Scaffold(appBar: NestBackBar(title: l.dnaTitle,
      action: IconButton(tooltip: l.dnaWhy, icon: const Icon(Icons.info_outline_rounded),
        onPressed: () => showDialog<void>(context: context, builder: (context) => AlertDialog(
          title: Text(l.dnaWhy), content: SingleChildScrollView(child: Text(l.dnaMethod)),
          actions: [TextButton(onPressed: () => Navigator.pop(context), child: Text(tx(context, 'Закрыть')))])))),
      body: ListView(padding: pagePadding, children: [
        const SizedBox(height: 20),
        NestPageTitle(title: l.dnaSubtitle, subtitle: l.dnaColdStart),
        const SizedBox(height: 24),
        Text(l.dnaPreferences, style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 8),
        Wrap(spacing: 7, children: DnaEngine.supportedGenres.map((genre) => FilterChip(
          label: Text(genreLabel(context, genre)), selected: prefs.genres.contains(genre),
          onSelected: (selected) {
            final genres = {...prefs.genres};
            if (selected) { genres.add(genre); } else { genres.remove(genre); }
            _update(context, DnaPreferences(genres: genres, mood: prefs.mood));
          })).toList()),
        const SizedBox(height: 22),
        Text(l.dnaMood, style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 8),
        Wrap(spacing: 7, children: [
          ChoiceChip(label: Text(l.dnaAnyMood), selected: prefs.mood == null,
            onSelected: (_) => _update(context, DnaPreferences(genres: prefs.genres))),
          ...DramaMood.values.map((mood) => ChoiceChip(label: Text(moodLabel(context, mood)),
            selected: prefs.mood == mood,
            onSelected: (_) => _update(context, DnaPreferences(genres: prefs.genres, mood: mood)))),
        ]),
        const SizedBox(height: 22),
        if (matches.firstOrNull?.score != null)
          Padding(padding: const EdgeInsets.only(bottom: 14), child: Text(l.dnaSignals(matches.first.signals),
            style: Theme.of(context).textTheme.bodySmall)),
        if (matches.isEmpty) Padding(padding: const EdgeInsets.symmetric(vertical: 30), child: Text(l.dnaEmpty)),
        ...matches.map((match) => Padding(padding: const EdgeInsets.only(bottom: 16), child: _MatchCard(match: match))),
        const SizedBox(height: 24),
      ]));
  }
}

class _MatchCard extends StatelessWidget {
  const _MatchCard({required this.match});
  final DnaMatch match;
  @override
  Widget build(BuildContext context) {
    final app = AppScope.of(context);
    final l = AppLocalizations.of(context)!;
    final drama = match.drama;
    final saved = app.isFavorite(drama.id);
    final reasons = [
      if (match.genres.isNotEmpty) l.dnaGenreReason(match.genres.map((g) => genreLabel(context, g)).join(', ')),
      if (match.mood != null) l.dnaMoodReason,
      if (match.similarLength) l.dnaLengthReason,
      if (match.genres.isEmpty && match.mood == null && !match.similarLength) l.dnaDiscoveryReason,
    ];
    return Material(color: context.nestSurface, borderRadius: BorderRadius.circular(22),
      child: InkWell(borderRadius: BorderRadius.circular(22),
        onTap: () => Navigator.pushNamed(context, '/detail', arguments: drama.id),
        child: Padding(padding: const EdgeInsets.all(16), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            DramaPoster(drama: drama, width: 82, height: 112, compact: true),
            const SizedBox(width: 14),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(match.score == null ? l.dnaExplore : l.dnaMatch(match.score!),
                style: const TextStyle(color: NestColors.blue, fontWeight: FontWeight.w900)),
              const SizedBox(height: 8),
              Text(drama.localizedTitle(app.language), style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 6),
              Text('${drama.year} · ${drama.episodes} ${tx(context, 'Серий')}', style: Theme.of(context).textTheme.bodySmall),
            ])),
            IconButton(tooltip: tx(context, saved ? 'Убрать из избранного' : 'Добавить в избранное'),
              onPressed: () async {
                try { await app.toggleFavorite(drama.id); }
                catch (_) { if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l.apiUnknown))); }
              }, icon: Icon(saved ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                color: saved ? NestColors.blush : NestColors.blue)),
          ]),
          const SizedBox(height: 14),
          ...reasons.map((reason) => Padding(padding: const EdgeInsets.only(bottom: 4), child: Text(reason,
            style: Theme.of(context).textTheme.bodySmall))),
        ])),
      ));
  }
}
