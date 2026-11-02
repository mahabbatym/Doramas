import 'package:flutter/material.dart';
import 'package:dorama_nest/core/theme/app_theme.dart';
import 'package:dorama_nest/core/widgets/nest_widgets.dart';
import 'package:dorama_nest/data/models/drama.dart';
import 'package:dorama_nest/state/app_controller.dart';
import 'package:dorama_nest/core/locale_text.dart';

class HomePage extends StatelessWidget {
  final void Function(int, String) onTab;
  const HomePage({super.key, required this.onTab});

  @override
  Widget build(BuildContext context) {
    final app = AppScope.of(context);
    return CustomScrollView(slivers: [
      SliverToBoxAdapter(
          child: Padding(
              padding: pagePadding,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 19),
                    Row(children: [
                      Expanded(
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                            Text(tx(context, 'DORAMANEST · ТВОЙ УЮТНЫЙ МИР'),
                                style: const TextStyle(
                                    color: NestColors.blue,
                                    fontWeight: FontWeight.w900,
                                    letterSpacing: .1,
                                    fontSize: 10)),
                            const SizedBox(height: 7),
                            Text(greeting(context, app.nickname),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style:
                                    Theme.of(context).textTheme.headlineSmall),
                          ])),
                      InkWell(
                          onTap: () => onTab(4, 'Все'),
                          borderRadius: BorderRadius.circular(14),
                          child: Container(
                              width: 42,
                              height: 42,
                              decoration: BoxDecoration(
                                  gradient: const LinearGradient(colors: [
                                    Color(0xFFFFE7D9),
                                    Color(0xFFC1E4F9)
                                  ]),
                                  borderRadius: BorderRadius.circular(14)),
                              child: const Icon(Icons.favorite_border,
                                  color: NestColors.blue))),
                    ]),
                    const SizedBox(height: 29),
                    if (app.dramas.isNotEmpty)
                      LayoutBuilder(builder: (context, constraints) {
                        final narrow = constraints.maxWidth < 320;
                        return InkWell(
                            onTap: () => Navigator.pushNamed(context, '/detail',
                                arguments: app.dramas.first.id),
                            borderRadius: BorderRadius.circular(27),
                            child: Container(
                              height: 246,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(27),
                                  gradient: const LinearGradient(
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                      colors: [
                                        Color(0xFFD9EFFD),
                                        Color(0xFFFFEDE6)
                                      ])),
                              child: Padding(
                                  padding: const EdgeInsets.all(19),
                                  child: Row(children: [
                                    Expanded(
                                        child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                          Text(tx(context, '✦ ВЫБОР РЕДАКЦИИ'),
                                              style: const TextStyle(
                                                  fontSize: 10,
                                                  color: NestColors.blue,
                                                  fontWeight: FontWeight.w900)),
                                          const Spacer(),
                                          Text(
                                              tx(context,
                                                  'Твоя новая\nлюбовь ждёт!'),
                                              style: TextStyle(
                                                  fontSize: narrow ? 21 : 24,
                                                  fontWeight: FontWeight.w900,
                                                  height: 1.22,
                                                  color: NestColors.ink)),
                                          const SizedBox(height: 12),
                                          Text(
                                              tx(context,
                                                  'Моменты, которые\nостаются с нами.'),
                                              style: const TextStyle(
                                                  fontSize: 10,
                                                  height: 1.6,
                                                  color: NestColors.muted)),
                                          const Spacer(),
                                          Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 16,
                                                      vertical: 10),
                                              decoration: BoxDecoration(
                                                  color: NestColors.blue,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          30)),
                                              child: Text(
                                                  tx(context, 'Подробнее →'),
                                                  style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.w800,
                                                      fontSize: 10,
                                                      color: Colors.white))),
                                        ])),
                                    const SizedBox(width: 8),
                                    DramaPoster(
                                        drama: app.dramas.first,
                                        width: constraints.maxWidth * .38,
                                        height: 210),
                                  ])),
                            ));
                      }),
                    const SizedBox(height: 26),
                    NestSectionHeading(
                        title: tx(context, 'Под настроение'),
                        more: tx(context, 'Все →'),
                        onTap: () => onTab(1, 'Все')),
                    const SizedBox(height: 6),
                    SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                            children: [
                          'Романтика',
                          'Комедия',
                          'Фэнтези',
                          'Музыка'
                        ]
                                .map((genre) => Padding(
                                    padding: const EdgeInsets.only(right: 8),
                                    child: GenreChip(
                                        label: tx(context, genre),
                                        selected: false,
                                        onTap: () => onTab(1, genre))))
                                .toList())),
                    const SizedBox(height: 22),
                    NestSectionHeading(
                        title: tx(context, 'Популярные истории'),
                        more: tx(context, 'Все →'),
                        onTap: () => onTab(1, 'Все')),
                    const SizedBox(height: 12),
                    if (app.watchProgress.isNotEmpty) ...[
                      Builder(builder: (context) {
                        final progress = app.watchProgress.values.first;
                        final drama = app.dramas
                            .where((d) => d.id == progress.dramaId)
                            .firstOrNull;
                        if (drama == null) return const SizedBox.shrink();
                        return InkWell(
                          onTap: () => Navigator.pushNamed(context, '/detail',
                              arguments: drama.id),
                          borderRadius: BorderRadius.circular(18),
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 16),
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                                color: context.nestSoftBlue,
                                borderRadius: BorderRadius.circular(18)),
                            child: Row(children: [
                              const Icon(Icons.play_circle_fill_rounded,
                                  color: NestColors.blue, size: 34),
                              const SizedBox(width: 12),
                              Expanded(
                                  child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                    Text(tx(context, 'Продолжить просмотр'),
                                        style: const TextStyle(
                                            color: NestColors.blue,
                                            fontWeight: FontWeight.w900,
                                            fontSize: 11)),
                                    const SizedBox(height: 4),
                                    Text(
                                        progress.episodesWatched >=
                                                drama.episodes
                                            ? watchComplete(
                                                context,
                                                drama.localizedTitle(
                                                    app.language))
                                            : watchNext(
                                                context,
                                                drama.localizedTitle(
                                                    app.language),
                                                progress.episodesWatched + 1),
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleMedium),
                                  ])),
                              const Icon(Icons.chevron_right_rounded,
                                  color: NestColors.blue),
                            ]),
                          ),
                        );
                      }),
                    ],
                    if (app.dramas.isNotEmpty)
                      SizedBox(
                          height: 250,
                          child: ListView.separated(
                              scrollDirection: Axis.horizontal,
                              itemCount: app.dramas.length.clamp(0, 5).toInt(),
                              separatorBuilder: (context, index) =>
                                  const SizedBox(width: 13),
                              itemBuilder: (context, index) {
                                final d = app.dramas[index];
                                return _HomeDramaCard(drama: d);
                              })),
                    if (app.dramas.isEmpty)
                      NestEmptyState(
                          icon: Icons.auto_stories_outlined,
                          title: tx(context, 'Историй пока нет'),
                          message: tx(
                              context, 'Попробуй выбрать другую категорию.')),
                    const SizedBox(height: 23),
                    Container(
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                            color: context.nestSoftBlue,
                            borderRadius: BorderRadius.circular(20)),
                        child: Row(children: [
                          const Icon(Icons.chat_bubble_outline_rounded,
                              size: 33, color: NestColors.blue),
                          const SizedBox(width: 14),
                          Expanded(
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                Text(tx(context, 'Истории становятся ближе'),
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium),
                                const SizedBox(height: 4),
                                Text(
                                    tx(context,
                                        'Читай отзывы и делись эмоциями ♡'),
                                    style:
                                        Theme.of(context).textTheme.bodySmall)
                              ])),
                        ])),
                    const SizedBox(height: 35),
                  ]))),
    ]);
  }
}

class _HomeDramaCard extends StatelessWidget {
  final Drama drama;
  const _HomeDramaCard({required this.drama});
  @override
  Widget build(BuildContext context) => InkWell(
      onTap: () => Navigator.pushNamed(context, '/detail', arguments: drama.id),
      borderRadius: BorderRadius.circular(18),
      child: SizedBox(
          width: 137,
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            DramaPoster(drama: drama, width: 137, height: 179),
            const SizedBox(height: 7),
            Text(drama.localizedTitle(AppScope.of(context).language),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    fontSize: 12,
                    color: context.nestInk,
                    fontWeight: FontWeight.w800)),
            const SizedBox(height: 3),
            Text(
                '★ ${drama.score.toStringAsFixed(1)} · ${tx(context, drama.country)}',
                maxLines: 1,
                style: Theme.of(context)
                    .textTheme
                    .bodySmall
                    ?.copyWith(fontSize: 10)),
          ])));
}
