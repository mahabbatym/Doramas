import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:dorama_nest/core/locale_text.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:dorama_nest/core/theme/app_theme.dart';
import 'package:dorama_nest/core/widgets/nest_widgets.dart';
import 'package:dorama_nest/data/models/watch_progress.dart';
import 'package:dorama_nest/core/l10n/generated/app_localizations.dart';
import 'package:dorama_nest/state/app_controller.dart';
import 'package:dorama_nest/data/api/api_exception.dart';

class DramaDetailPage extends StatelessWidget {
  final String dramaId;
  const DramaDetailPage({super.key, required this.dramaId});

  @override
  Widget build(BuildContext context) {
    final app = AppScope.of(context);
    final drama = app.dramaById(dramaId);
    if (drama == null) return Scaffold(appBar: NestBackBar(title: tx(context, 'О дораме')),
      body: Center(child: Padding(padding: pagePadding, child: Text(AppLocalizations.of(context)!.dramaMissing))));
    final favorite = app.isFavorite(drama.id);
    return Scaffold(
      appBar: NestBackBar(
          title: tx(context, 'О дораме'),
          action: Row(mainAxisSize: MainAxisSize.min, children: [
            if (drama.isCustom && app.canManageCatalog)
              IconButton(
                  tooltip: tx(context, 'Изменить дораму'),
                  onPressed: () => Navigator.pushNamed(context, '/dramaForm',
                      arguments: drama.id),
                  icon:
                      const Icon(Icons.edit_outlined, color: NestColors.blue)),
            if (drama.isCustom && app.canManageCatalog)
              IconButton(
                  tooltip: tx(context, 'Удалить дораму'),
                  onPressed: () => _deleteDrama(context, drama.id),
                  icon: const Icon(Icons.delete_outline_rounded,
                      color: NestColors.blue)),
            IconButton(
                onPressed: () => _toggleFavorite(context, app, drama.id),
                tooltip: tx(context,
                    favorite ? 'Убрать из избранного' : 'Добавить в избранное'),
                icon: Icon(
                    favorite
                        ? Icons.favorite_rounded
                        : Icons.favorite_border_rounded,
                    color:
                        favorite ? const Color(0xFFF39AA8) : NestColors.blue)),
          ])),
      body: ListView(padding: pagePadding, children: [
        const SizedBox(height: 12),
        DramaPoster(drama: drama, height: 260),
        const SizedBox(height: 25),
        Text(drama.localizedTitle(app.language),
            style: Theme.of(context).textTheme.headlineMedium),
        const SizedBox(height: 4),
        Text(drama.originalTitle, style: Theme.of(context).textTheme.bodySmall),
        const SizedBox(height: 8),
        Text(
            '★ ${drama.score.toStringAsFixed(1)}  ·  ${tx(context, drama.country)}  ·  ${drama.year}  ·  ${genreLabel(context, drama.genreKeys.first)}',
            style: const TextStyle(
                color: NestColors.blue,
                fontSize: 12,
                fontWeight: FontWeight.w800)),
        const SizedBox(height: 28),
        Text(drama.localizedDescription(app.language),
            style: Theme.of(context)
                .textTheme
                .bodySmall
                ?.copyWith(height: 1.8, fontSize: 13)),
        const SizedBox(height: 9),
        Text(
            '${drama.episodes} ${tx(context, 'Серий')} · ${drama.country == 'Корея' ? 'K-drama' : 'C-drama'}',
            style: Theme.of(context).textTheme.bodySmall),
        const SizedBox(height: 20),
        Text(AppLocalizations.of(context)!.watchStatus, style: Theme.of(context).textTheme.titleMedium),
        Wrap(spacing: 7, children: WatchStatus.values.map((status) => ChoiceChip(
          label: Text(watchStatusLabel(context, status)), selected: app.watchProgress[drama.id]?.status == status,
          onSelected: (_) async {
            try { await app.setEpisodesWatched(drama.id,
              status == WatchStatus.planned ? 0 : app.watchProgress[drama.id]?.episodesWatched ?? 0, status: status); }
            catch (_) { if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(tx(context, 'Не удалось сохранить')))); }
          })).toList()),
        const SizedBox(height: 20),
        if (app.watchProgress.containsKey(drama.id)) ...[
          Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
                color: context.nestSoftBlue,
                borderRadius: BorderRadius.circular(17)),
            child: Row(children: [
              const Icon(Icons.play_circle_outline_rounded,
                  color: NestColors.blue),
              const SizedBox(width: 10),
              Expanded(
                  child: Text(
                      app.watchProgress[drama.id]!.episodesWatched >=
                              drama.episodes
                          ? progressComplete(context, drama.episodes)
                          : progressNext(
                              context,
                              app.watchProgress[drama.id]!.episodesWatched + 1,
                              drama.episodes),
                      style: Theme.of(context).textTheme.titleMedium)),
              IconButton(
                  tooltip: tx(context, 'Обновить прогресс'),
                  onPressed: () => _updateProgress(
                      context,
                      drama.id,
                      drama.episodes,
                      app.watchProgress[drama.id]!.episodesWatched),
                  icon:
                      const Icon(Icons.edit_outlined, color: NestColors.blue)),
            ]),
          ),
          const SizedBox(height: 16),
        ] else
          Align(
              alignment: Alignment.centerLeft,
              child: TextButton.icon(
                  onPressed: () =>
                      _updateProgress(context, drama.id, drama.episodes, 0),
                  icon: const Icon(Icons.add_task_rounded),
                  label: Text(tx(context, 'Отметить просмотренные серии')))),
        Row(children: [
          Expanded(
              flex: 2,
              child: NestButton(
                  label: tx(context, 'Найти 1 серию ↗'),
                  icon: Icons.play_circle_outline_rounded,
                  onPressed: () => _findOfficialVideo(
                      context, drama.localizedTitle(app.language)))),
          const SizedBox(width: 12),
          IconButton.filledTonal(
              tooltip: tx(context,
                  favorite ? 'Убрать из избранного' : 'Добавить в избранное'),
              onPressed: () => _toggleFavorite(context, app, drama.id),
              icon: Icon(
                  favorite
                      ? Icons.favorite_rounded
                      : Icons.favorite_border_rounded,
                  color: favorite ? const Color(0xFFF39AA8) : NestColors.blue)),
        ]),
        const SizedBox(height: 27),
        Text(tx(context, 'Обсуждение'),
            style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 9),
        Text(tx(context, 'Отзывы зрителей и спойлеры — под контролем'),
            style: Theme.of(context).textTheme.bodySmall),
        const SizedBox(height: 13),
        NestButton(
            label: tx(context, 'Отзывы и оценки →'),
            secondary: true,
            onPressed: () =>
                Navigator.pushNamed(context, '/reviews', arguments: drama.id)),
        const SizedBox(height: 24),
        const SizedBox(height: 32),
      ]),
    );
  }

  Future<void> _findOfficialVideo(BuildContext context, String title) async {
    final uri = Uri.https('www.youtube.com', '/results',
        {'search_query': '$title episode 1 full official channel'});
    try {
      if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
        if (context.mounted)
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(tx(context,
                  'Не удалось открыть YouTube. Проверь подключение и настройки.'))));
      }
    } catch (_) {
      if (context.mounted)
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(
                tx(context, 'Не удалось открыть ссылку. Попробуй позже.'))));
    }
  }

  Future<void> _updateProgress(
      BuildContext context, String id, int total, int current) async {
    final selected = await showDialog<int>(
        context: context,
        builder: (dialogContext) =>
            _EpisodeProgressDialog(initialValue: current, total: total));
    if (selected != null && context.mounted) {
      try {
        await AppScope.of(context).setEpisodesWatched(id, selected);
      } catch (error) {
        if (context.mounted)
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(tx(context, 'Не удалось сохранить'))));
      }
    }
  }

  Future<void> _deleteDrama(BuildContext context, String id) async {
    final confirmed = await showDialog<bool>(
        context: context,
        builder: (dialogContext) => AlertDialog(
              title: Text(tx(context, 'Удалить дораму?')),
              content: Text(tx(context,
                  'Связанные отзывы, избранное и прогресс тоже будут удалены.')),
              actions: [
                TextButton(
                    onPressed: () => Navigator.pop(dialogContext, false),
                    child: Text(tx(context, 'Отмена'))),
                FilledButton(
                    onPressed: () => Navigator.pop(dialogContext, true),
                    child: Text(tx(context, 'Удалить')))
              ],
            ));
    if (confirmed == true && context.mounted) {
      try {
        await AppScope.of(context).deleteDrama(id);
        if (context.mounted) Navigator.pop(context);
      } on ApiException catch (error) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(apiStatusText(context, error.kind,
                  showingSavedData: AppScope.of(context).showingSavedData))));
        }
      }
    }
  }

  Future<void> _toggleFavorite(
      BuildContext context, AppController app, String id) async {
    try {
      await app.toggleFavorite(id);
    } catch (error) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(tx(context, 'Не удалось сохранить избранное'))));
      }
    }
  }
}

class _EpisodeProgressDialog extends StatefulWidget {
  final int initialValue;
  final int total;

  const _EpisodeProgressDialog(
      {required this.initialValue, required this.total});

  @override
  State<_EpisodeProgressDialog> createState() => _EpisodeProgressDialogState();
}

class _EpisodeProgressDialogState extends State<_EpisodeProgressDialog> {
  late final TextEditingController value;

  @override
  void initState() {
    super.initState();
    value = TextEditingController(text: '${widget.initialValue}');
  }

  @override
  void dispose() {
    value.dispose();
    super.dispose();
  }

  void save() {
    final selected = int.tryParse(value.text);
    if (selected == null || selected < 0 || selected > widget.total) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(episodeRange(context, widget.total))));
      return;
    }
    Navigator.pop(context, selected);
  }

  @override
  Widget build(BuildContext context) => AlertDialog(
        title: Text(tx(context, 'Прогресс просмотра')),
        content: TextField(
          controller: value,
          autofocus: true,
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          onSubmitted: (_) => save(),
          decoration:
              InputDecoration(labelText: episodeRange(context, widget.total)),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(tx(context, 'Отмена'))),
          FilledButton(onPressed: save, child: Text(tx(context, 'Сохранить'))),
        ],
      );
}
