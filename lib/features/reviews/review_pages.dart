import 'package:flutter/material.dart';
import 'package:dorama_nest/core/locale_text.dart';
import 'package:dorama_nest/core/theme/app_theme.dart';
import 'package:dorama_nest/core/widgets/nest_widgets.dart';
import 'package:dorama_nest/core/validators.dart';
import 'package:dorama_nest/data/models/review.dart';
import 'package:dorama_nest/data/services/catalog_data.dart';
import 'package:dorama_nest/state/app_controller.dart';

class ReviewsPage extends StatelessWidget {
  final String dramaId;
  const ReviewsPage({super.key, required this.dramaId});

  @override
  Widget build(BuildContext context) {
    final app = AppScope.of(context);
    final drama = app.dramas.where((d) => d.id == dramaId).firstOrNull ??
        CatalogData.byId(dramaId);
    final reviews = app.reviewsFor(dramaId);
    return Scaffold(
        appBar: NestBackBar(title: tx(context, 'Отзывы о дораме')),
        body: ListView(padding: pagePadding, children: [
          const SizedBox(height: 21),
          NestPageTitle(
              title: '${drama.localizedTitle(app.language)} 💌',
              subtitle: tx(context, 'Эмоциями приятнее делиться.')),
          const SizedBox(height: 22),
          Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                  color: context.nestSoftBlue,
                  borderRadius: BorderRadius.circular(21)),
              child: Row(children: [
                Expanded(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                      Text('★ ${drama.score.toStringAsFixed(1)}',
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall
                              ?.copyWith(color: NestColors.blue)),
                      const SizedBox(height: 2),
                      Text(tx(context, 'Зрительская оценка'),
                          style: Theme.of(context).textTheme.bodySmall)
                    ])),
                SizedBox(
                    width: 130,
                    child: NestButton(
                        label: tx(context, '+ Мой отзыв'),
                        onPressed: () => Navigator.pushNamed(
                            context, '/reviewForm',
                            arguments: {'dramaId': dramaId}))),
              ])),
          const SizedBox(height: 24),
          Text(reviewCount(context, reviews.length),
              style: const TextStyle(
                  color: NestColors.blue,
                  fontSize: 11,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.2)),
          const SizedBox(height: 13),
          if (reviews.isEmpty)
            NestEmptyState(
                icon: Icons.forum_outlined,
                title: tx(context, 'Пока нет отзывов'),
                message: tx(context,
                    'Стань первым зрителем, который поделится эмоциями.')),
          ...reviews.map((r) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _ReviewCard(review: r))),
          const SizedBox(height: 20),
        ]));
  }
}

class _ReviewCard extends StatefulWidget {
  final DramaReview review;
  const _ReviewCard({required this.review});
  @override
  State<_ReviewCard> createState() => _ReviewCardState();
}

class _ReviewCardState extends State<_ReviewCard> {
  bool reveal = false;
  @override
  Widget build(BuildContext context) {
    final r = widget.review;
    final app = AppScope.of(context);
    final hidden = r.spoiler && !reveal && !app.showSpoilers;
    return Container(
        padding: const EdgeInsets.all(17),
        decoration: BoxDecoration(
            color: context.nestSurface,
            borderRadius: BorderRadius.circular(21)),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            CircleAvatar(
                radius: 20,
                backgroundColor: context.nestSoftBlue,
                child: Icon(
                    r.mine ? Icons.face_rounded : Icons.favorite_border_rounded,
                    color: NestColors.blue)),
            const SizedBox(width: 11),
            Expanded(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                  Text(r.author,
                      style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 2),
                  Text(
                      tx(context,
                          r.mine ? 'Мой отзыв' : 'Сообщество DoramaNest'),
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall
                          ?.copyWith(fontSize: 10))
                ])),
            if (r.mine)
              PopupMenuButton<String>(
                  tooltip: tx(context, 'Действия с отзывом'),
                  onSelected: (choice) {
                    if (choice == 'edit')
                      Navigator.pushNamed(context, '/reviewForm',
                          arguments: {'dramaId': r.dramaId, 'reviewId': r.id});
                    if (choice == 'delete') _confirmDelete(context, r);
                  },
                  itemBuilder: (context) => [
                        PopupMenuItem(
                            value: 'edit',
                            child: Text(tx(context, 'Редактировать'))),
                        PopupMenuItem(
                            value: 'delete',
                            child: Text(tx(context, 'Удалить')))
                      ])
            else
              const Icon(Icons.auto_awesome_rounded,
                  color: NestColors.blush, size: 19),
          ]),
          const SizedBox(height: 12),
          Text('${'★' * r.stars}${'☆' * (5 - r.stars)}',
              style: const TextStyle(
                  color: Color(0xFFE8A84F), fontSize: 19, letterSpacing: 2)),
          const SizedBox(height: 9),
          if (hidden)
            InkWell(
                onTap: () => setState(() => reveal = true),
                borderRadius: BorderRadius.circular(13),
                child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 15, vertical: 16),
                    decoration: BoxDecoration(
                        color: context.nestSoftBlue,
                        borderRadius: BorderRadius.circular(13)),
                    child: Row(children: [
                      const Icon(Icons.lock_outline_rounded,
                          color: NestColors.blue, size: 18),
                      const SizedBox(width: 9),
                      Expanded(
                          child: Text(tx(context, 'Спойлер скрыт · Показать →'),
                              style: const TextStyle(
                                  color: NestColors.blue,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w800)))
                    ])))
          else
            Text(r.content, style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(height: 14),
          Row(children: [
            Text(
                '${r.createdAt.day.toString().padLeft(2, '0')}.${r.createdAt.month.toString().padLeft(2, '0')}.${r.createdAt.year}',
                style: Theme.of(context)
                    .textTheme
                    .bodySmall
                    ?.copyWith(fontSize: 10)),
            const Spacer(),
            if (r.mine)
              Text(tx(context, 'Можно изменить ✎'),
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall
                      ?.copyWith(fontSize: 10))
            else
              Text(tx(context, '♡ Спасибо'),
                  style: const TextStyle(
                      color: NestColors.blue,
                      fontSize: 11,
                      fontWeight: FontWeight.w700)),
          ]),
        ]));
  }

  Future<void> _confirmDelete(BuildContext context, DramaReview review) async {
    final yes = await showDialog<bool>(
        context: context,
        builder: (dialogContext) => AlertDialog(
                title: Text(tx(context, 'Удалить отзыв?')),
                content: Text(tx(context, 'Это действие нельзя отменить.')),
                actions: [
                  TextButton(
                      onPressed: () => Navigator.pop(dialogContext, false),
                      child: Text(tx(context, 'Отмена'))),
                  TextButton(
                      onPressed: () => Navigator.pop(dialogContext, true),
                      child: Text(tx(context, 'Удалить')))
                ]));
    if (yes == true && context.mounted) {
      await AppScope.of(context).deleteReview(review.id);
      if (context.mounted)
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(tx(context, 'Отзыв удалён'))));
    }
  }
}

class ReviewFormPage extends StatefulWidget {
  final String dramaId;
  final String? reviewId;
  const ReviewFormPage({super.key, required this.dramaId, this.reviewId});
  @override
  State<ReviewFormPage> createState() => _ReviewFormPageState();
}

class _ReviewFormPageState extends State<ReviewFormPage> {
  final form = GlobalKey<FormState>();
  final content = TextEditingController();
  bool spoiler = false;
  int stars = 5;
  bool initialized = false;
  bool busy = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!initialized) {
      initialized = true;
      if (widget.reviewId != null) {
        final own = AppScope.of(context)
            .ownReviews
            .where((r) => r.id == widget.reviewId)
            .toList();
        if (own.isNotEmpty) {
          content.text = own.first.content;
          spoiler = own.first.spoiler;
          stars = own.first.stars;
        }
      }
    }
  }

  @override
  void dispose() {
    content.dispose();
    super.dispose();
  }

  Future<void> submit() async {
    if (!form.currentState!.validate()) return;
    setState(() => busy = true);
    try {
      await AppScope.of(context).saveReview(
          dramaId: widget.dramaId,
          reviewId: widget.reviewId,
          stars: stars,
          content: content.text,
          spoiler: spoiler);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(widget.reviewId == null
              ? tx(context, 'Отзыв опубликован ♡')
              : tx(context, 'Изменения сохранены ♡'))));
      Navigator.pop(context);
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(tx(context, 'Не удалось сохранить отзыв'))));
      }
    } finally {
      if (mounted) setState(() => busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final app = AppScope.of(context);
    final drama = app.dramas.where((d) => d.id == widget.dramaId).firstOrNull ??
        CatalogData.byId(widget.dramaId);
    final editing = widget.reviewId != null;
    return Scaffold(
        appBar: NestBackBar(
            title:
                tx(context, editing ? 'Редактировать отзыв' : 'Новый отзыв')),
        body: ListView(padding: pagePadding, children: [
          const SizedBox(height: 15),
          NestPageTitle(
              title: tx(context,
                  editing ? 'Измени впечатление ✎' : 'Расскажи, как тебе ✎'),
              subtitle:
                  '${drama.localizedTitle(app.language)} · ${tx(context, 'твоё мнение важно.')}'),
          const SizedBox(height: 23),
          Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                  color: context.nestSurface,
                  borderRadius: BorderRadius.circular(18)),
              child: Row(children: [
                DramaPoster(drama: drama, width: 70, height: 92, compact: true),
                const SizedBox(width: 14),
                Expanded(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                      Text(drama.localizedTitle(app.language),
                          style: Theme.of(context).textTheme.titleMedium),
                      const SizedBox(height: 5),
                      Text('${tx(context, drama.country)} · ${drama.year}',
                          style: Theme.of(context).textTheme.bodySmall)
                    ])),
              ])),
          const SizedBox(height: 30),
          Text(tx(context, 'Как тебе история?'),
              style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 9),
          Row(
              children: List.generate(
                  5,
                  (index) => IconButton(
                      tooltip: ratingTooltip(context, index + 1),
                      padding: const EdgeInsets.symmetric(horizontal: 2),
                      constraints: const BoxConstraints(minWidth: 45),
                      onPressed: () => setState(() => stars = index + 1),
                      icon: Icon(
                          index < stars
                              ? Icons.star_rounded
                              : Icons.star_border_rounded,
                          size: 38,
                          color: const Color(0xFFE9B05D))))),
          const SizedBox(height: 4),
          Text(tx(context, _starLabel(stars)),
              style: const TextStyle(
                  color: NestColors.blue,
                  fontWeight: FontWeight.w800,
                  fontSize: 12)),
          const SizedBox(height: 23),
          Form(
              key: form,
              child: NestField(
                  label: tx(context, 'Твой отзыв'),
                  hint: tx(context, 'Что удивило? Какая сцена запомнилась?'),
                  controller: content,
                  maxLines: 5,
                  validator: (v) {
                    final basic = NestValidators.requiredText(v, name: 'Отзыв');
                    if (basic != null) return tx(context, basic);
                    if (v!.trim().length < 10)
                      return tx(context, 'Напиши хотя бы 10 символов');
                    if (v.trim().length > 1000)
                      return tx(context, 'Максимум 1000 символов');
                    return null;
                  })),
          const SizedBox(height: 21),
          Container(
              decoration: BoxDecoration(
                  color: context.nestSurface,
                  borderRadius: BorderRadius.circular(16)),
              child: SwitchListTile.adaptive(
                  value: spoiler,
                  activeThumbColor: NestColors.blue,
                  onChanged: (v) => setState(() => spoiler = v),
                  title: Text(tx(context, '🔒 Содержит спойлеры'),
                      style: Theme.of(context).textTheme.titleMedium),
                  subtitle: Text(tx(context, 'Скроем текст от других зрителей'),
                      style: Theme.of(context).textTheme.bodySmall))),
          const SizedBox(height: 28),
          NestButton(
              label: tx(
                  context,
                  busy
                      ? 'Сохраняем…'
                      : (editing
                          ? 'Сохранить изменения →'
                          : 'Опубликовать отзыв →')),
              onPressed: busy ? null : submit),
          const SizedBox(height: 35),
        ]));
  }

  String _starLabel(int stars) => switch (stars) {
        1 => 'Не моё',
        2 => 'Есть над чем подумать',
        3 => 'Неплохо!',
        4 => 'Очень понравилось',
        _ => 'В самое сердце!',
      };
}
