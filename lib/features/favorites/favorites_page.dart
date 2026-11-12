import 'package:dorama_nest/core/l10n/generated/app_localizations.dart';
import 'package:dorama_nest/data/models/watch_progress.dart';
import 'package:flutter/material.dart';
import 'package:dorama_nest/core/theme/app_theme.dart';
import 'package:dorama_nest/core/widgets/nest_widgets.dart';
import 'package:dorama_nest/state/app_controller.dart';
import 'package:dorama_nest/core/locale_text.dart';

class FavoritesPage extends StatefulWidget {
  final VoidCallback onCatalog;
  const FavoritesPage({super.key, required this.onCatalog});
  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}
class _FavoritesPageState extends State<FavoritesPage> {
  WatchStatus? filter;
  @override
  Widget build(BuildContext context) {
    final app = AppScope.of(context);
    final favorites = app.dramas.where((d) => filter == null ? app.isFavorite(d.id) : app.watchProgress[d.id]?.status == filter).toList();
    return ListView(padding: pagePadding, children: [
      const SizedBox(height: 25),
      NestPageTitle(
          title: tx(context, 'Истории в сердце ♡'),
          subtitle: tx(context, 'Всё любимое — всегда под рукой.')),
      const SizedBox(height: 16),
      Wrap(spacing: 7, children: [
        ChoiceChip(label: Text(tx(context, 'Избранное')), selected: filter == null, onSelected: (_) => setState(() => filter = null)),
        ...WatchStatus.values.map((status) => ChoiceChip(label: Text(watchStatusLabel(context, status)),
          selected: filter == status, onSelected: (_) => setState(() => filter = status))),
      ]),
      const SizedBox(height: 16),
      NestSectionHeading(
          title: '${filter == null ? tx(context, 'Избранное') : watchStatusLabel(context, filter!)} (${favorites.length})',
          more: tx(context, 'В каталог →'),
          onTap: widget.onCatalog),
      const SizedBox(height: 14),
      ...favorites.map((d) => Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: DramaListTile(
              drama: d,
              onTap: () =>
                  Navigator.pushNamed(context, '/detail', arguments: d.id)))),
      if (favorites.isEmpty)
        NestEmptyState(
            icon: Icons.favorite_border_rounded,
            title: tx(context, 'Твоя коллекция дорам'),
            message: tx(context,
                'Сохраняй истории, чтобы возвращаться к ним в любой момент.'),
            action: tx(context, 'Смотреть каталог →'),
            onAction: widget.onCatalog),
      if (favorites.isNotEmpty)
        Container(
            margin: const EdgeInsets.only(top: 15),
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
                color: context.nestSoftBlue,
                borderRadius: BorderRadius.circular(18)),
            child: Text(
                app.hasSession ? (app.pendingCount > 0 ? AppLocalizations.of(context)!.syncPending : app.realtimeConnected ? AppLocalizations.of(context)!.syncLive : AppLocalizations.of(context)!.syncConnecting) : AppLocalizations.of(context)!.guestLibrary,
                style: Theme.of(context).textTheme.bodySmall)),
    ]);
  }
}
