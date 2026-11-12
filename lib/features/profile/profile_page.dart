import 'package:flutter/material.dart';
import 'package:dorama_nest/core/theme/app_theme.dart';
import 'package:dorama_nest/core/widgets/nest_widgets.dart';
import 'package:dorama_nest/core/l10n/generated/app_localizations.dart';
import 'package:dorama_nest/state/app_controller.dart';
import 'package:dorama_nest/core/locale_text.dart';

class ProfilePage extends StatelessWidget {
  final void Function(int) onTab;
  const ProfilePage({super.key, required this.onTab});

  @override
  Widget build(BuildContext context) {
    final app = AppScope.of(context);
    return ListView(padding: pagePadding, children: [
      const SizedBox(height: 22),
      Row(children: [
        Text(tx(context, 'Мой профиль'),
            style: Theme.of(context).textTheme.titleLarge),
        const Spacer(),
        IconButton(
            onPressed: () => Navigator.pushNamed(context, '/settings'),
            tooltip: tx(context, 'Настройки'),
            icon: const Icon(Icons.settings_outlined, color: NestColors.blue))
      ]),
      const SizedBox(height: 20),
      Center(
          child: Container(
              width: 91,
              height: 91,
              decoration: BoxDecoration(
                  gradient: const LinearGradient(
                      colors: [Color(0xFFFFE7D9), Color(0xFFC1E4F9)]),
                  borderRadius: BorderRadius.circular(29)),
              child: const Icon(Icons.favorite_border_rounded,
                  size: 51, color: NestColors.blue))),
      const SizedBox(height: 16),
      Center(
          child: Text(tx(context, 'DORAMA LOVER'),
              style: const TextStyle(
                  color: NestColors.blue,
                  fontSize: 10,
                  letterSpacing: 1.6,
                  fontWeight: FontWeight.w900))),
      const SizedBox(height: 5),
      Center(
          child: Text(app.nickname.isEmpty ? AppLocalizations.of(context)!.guestName : app.nickname,
              style: Theme.of(context).textTheme.headlineSmall)),
      const SizedBox(height: 7),
      Center(
          child: Text(tx(context, 'Счастливые истории начинаются здесь ✦'),
              style: Theme.of(context).textTheme.bodySmall)),
      if (!app.loggedIn) TextButton(onPressed: () => Navigator.pushNamed(context, '/login'), child: Text(AppLocalizations.of(context)!.signInToSync)),
      const SizedBox(height: 25),
      Row(children: [
        Expanded(
            child: _Statistic(
                value: '${app.favoriteCount}',
                label: tx(context, 'Избранных'))),
        const SizedBox(width: 10),
        Expanded(
            child: _Statistic(
                value: '${app.reviewsCount}',
                label: tx(context, 'Моих отзывов'))),
        const SizedBox(width: 10),
        Expanded(
            child: _Statistic(
                value: '${app.dramas.map((d) => d.genre).toSet().length}',
                label: tx(context, 'Категории'))),
      ]),
      const SizedBox(height: 34),
      Text(tx(context, 'Моё пространство'),
          style: Theme.of(context).textTheme.titleLarge),
      const SizedBox(height: 15),
      _ProfileAction(
          icon: Icons.favorite_border_rounded,
          title: tx(context, 'Избранные дорамы'),
          detail: tx(context, 'Любимые истории и закладки'),
          onTap: () => onTab(3)),
      const SizedBox(height: 10),
      _ProfileAction(
          icon: Icons.rate_review_outlined,
          title: tx(context, 'Мои обсуждения'),
          detail: tx(context, 'Отзывы и комментарии'),
          onTap: () {
            if (app.ownReviews.isEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text(tx(context,
                      'Пока нет отзывов. Открой дораму и поделись впечатлением!'))));
              onTab(1);
            } else {
              showModalBottomSheet<void>(
                  context: context,
                  showDragHandle: true,
                  isScrollControlled: true,
                  builder: (sheetContext) => SafeArea(
                      child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: SingleChildScrollView(child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(tx(context, 'Мои отзывы'),
                                    style:
                                        Theme.of(context).textTheme.titleLarge),
                                const SizedBox(height: 13),
                                ...app.ownReviews.map((review) => ListTile(
                                    contentPadding: EdgeInsets.zero,
                                    title: Text(app.dramaById(review.dramaId)?.localizedTitle(app.language) ?? AppLocalizations.of(context)!.dramaMissing),
                                    subtitle: Text(review.content,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis),
                                    trailing: const Icon(Icons.chevron_right),
                                    onTap: () {
                                      Navigator.pop(sheetContext);
                                      Navigator.pushNamed(context, '/reviews',
                                          arguments: review.dramaId);
                                    })),
                              ])))));
            }
          }),
      const SizedBox(height: 10),
      _ProfileAction(
          icon: Icons.settings_outlined,
          title: tx(context, 'Настройки'),
          detail: tx(context, 'Уведомления и приватность'),
          onTap: () => Navigator.pushNamed(context, '/settings')),
      const SizedBox(height: 38),
      const SizedBox(height: 30),
    ]);
  }
}

class _Statistic extends StatelessWidget {
  final String value;
  final String label;
  const _Statistic({required this.value, required this.label});
  @override
  Widget build(BuildContext context) => Container(
      height: 89,
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 12),
      decoration: BoxDecoration(
          color: context.nestSurface, borderRadius: BorderRadius.circular(19)),
      child: Column(children: [
        Text(value,
            style: Theme.of(context)
                .textTheme
                .titleLarge
                ?.copyWith(color: NestColors.blue, fontSize: 24)),
        const SizedBox(height: 4),
        Text(label,
            textAlign: TextAlign.center,
            style:
                Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: 10)),
      ]));
}

class _ProfileAction extends StatelessWidget {
  final IconData icon;
  final String title;
  final String detail;
  final VoidCallback onTap;
  const _ProfileAction(
      {required this.icon,
      required this.title,
      required this.detail,
      required this.onTap});
  @override
  Widget build(BuildContext context) => Material(
      color: context.nestSurface,
      borderRadius: BorderRadius.circular(17),
      child: ListTile(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(17)),
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
        leading: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
                color: context.nestSoftBlue,
                borderRadius: BorderRadius.circular(13)),
            child: Icon(icon, color: NestColors.blue)),
        title: Text(title, style: Theme.of(context).textTheme.titleMedium),
        subtitle: Text(detail, style: Theme.of(context).textTheme.bodySmall),
        trailing:
            const Icon(Icons.chevron_right_rounded, color: NestColors.blue),
      ));
}
