import 'package:flutter/material.dart';
import 'package:dorama_nest/core/theme/app_theme.dart';
import 'package:dorama_nest/core/widgets/nest_widgets.dart';
import 'package:dorama_nest/state/app_controller.dart';
import 'package:dorama_nest/core/locale_text.dart';

class FavoritesPage extends StatelessWidget {
  final VoidCallback onCatalog;
  const FavoritesPage({super.key, required this.onCatalog});
  @override
  Widget build(BuildContext context) {
    final app = AppScope.of(context);
    final favorites = app.dramas.where((d) => app.isFavorite(d.id)).toList();
    return ListView(padding: pagePadding, children: [
      const SizedBox(height: 25),
      NestPageTitle(
          title: tx(context, 'Истории в сердце ♡'),
          subtitle: tx(context, 'Всё любимое — всегда под рукой.')),
      const SizedBox(height: 29),
      NestSectionHeading(
          title: '${tx(context, 'Избранное')} (${favorites.length})',
          more: tx(context, 'В каталог →'),
          onTap: onCatalog),
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
            onAction: onCatalog),
      if (favorites.isNotEmpty)
        Container(
            margin: const EdgeInsets.only(top: 15),
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
                color: context.nestSoftBlue,
                borderRadius: BorderRadius.circular(18)),
            child: Text(
                tx(context,
                    '♡ Любимые истории сохраняются на этом устройстве.'),
                style: Theme.of(context).textTheme.bodySmall)),
    ]);
  }
}
