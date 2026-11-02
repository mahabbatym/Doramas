import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dorama_nest/core/locale_text.dart';
import 'package:dorama_nest/core/theme/app_theme.dart';
import 'package:dorama_nest/data/models/drama.dart';
import 'package:dorama_nest/state/app_controller.dart';

const pagePadding = EdgeInsets.symmetric(horizontal: 23);

class NestButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool secondary;
  final IconData? icon;
  final double height;
  const NestButton(
      {super.key,
      required this.label,
      required this.onPressed,
      this.secondary = false,
      this.icon,
      this.height = 52});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: height,
      child: FilledButton(
        onPressed: onPressed,
        style: FilledButton.styleFrom(
          backgroundColor: secondary ? context.nestSoftBlue : NestColors.blue,
          foregroundColor: secondary
              ? (context.isDark ? Colors.white : NestColors.blue)
              : Colors.white,
          disabledBackgroundColor: NestColors.blue.withValues(alpha: .4),
          elevation: 0,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          textStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.w800),
        ),
        child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null) ...[
                Icon(icon, size: 17),
                const SizedBox(width: 7)
              ],
              Flexible(
                  child: Text(label,
                      maxLines: 1, overflow: TextOverflow.ellipsis)),
            ]),
      ),
    );
  }
}

class NestBackBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final Widget? action;
  const NestBackBar({super.key, required this.title, this.action});
  @override
  Widget build(BuildContext context) => AppBar(
        leadingWidth: 72,
        leading: Padding(
          padding: const EdgeInsets.only(left: 23, top: 8, bottom: 8, right: 8),
          child: IconButton.filledTonal(
              onPressed: () => Navigator.of(context).maybePop(),
              icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 15),
              style: IconButton.styleFrom(
                  backgroundColor: context.nestSoftBlue,
                  foregroundColor: NestColors.blue,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)))),
        ),
        title: Text(title),
        actions: [
          if (action != null)
            Padding(padding: const EdgeInsets.only(right: 20), child: action!)
        ],
      );
  @override
  Size get preferredSize => const Size.fromHeight(62);
}

class NestField extends StatelessWidget {
  final String label;
  final String hint;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final bool obscure;
  final int maxLines;
  final Widget? suffix;
  const NestField(
      {super.key,
      required this.label,
      required this.hint,
      required this.controller,
      this.validator,
      this.keyboardType,
      this.obscure = false,
      this.maxLines = 1,
      this.suffix});

  @override
  Widget build(BuildContext context) =>
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(label,
            style: TextStyle(
                color: context.nestInk,
                fontWeight: FontWeight.w800,
                fontSize: 12)),
        const SizedBox(height: 9),
        TextFormField(
          controller: controller,
          validator: validator,
          keyboardType: keyboardType,
          obscureText: obscure,
          maxLines: obscure ? 1 : maxLines,
          style: TextStyle(fontSize: 14, color: context.nestInk),
          decoration: InputDecoration(hintText: hint, suffixIcon: suffix),
        ),
      ]);
}

class NestSectionHeading extends StatelessWidget {
  final String title;
  final String? more;
  final VoidCallback? onTap;
  const NestSectionHeading(
      {super.key, required this.title, this.more, this.onTap});
  @override
  Widget build(BuildContext context) => Row(children: [
        Expanded(
            child: Text(title, style: Theme.of(context).textTheme.titleLarge)),
        if (more != null)
          TextButton(
              onPressed: onTap,
              child: Text(more!,
                  style: const TextStyle(
                      color: NestColors.blue,
                      fontWeight: FontWeight.w700,
                      fontSize: 12))),
      ]);
}

class GenreChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  const GenreChip(
      {super.key,
      required this.label,
      required this.selected,
      required this.onTap});
  @override
  Widget build(BuildContext context) => InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(24),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 170),
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
          decoration: BoxDecoration(
              color: selected ? NestColors.blue : context.nestSoftBlue,
              borderRadius: BorderRadius.circular(24)),
          child: Text(label,
              style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  color: selected
                      ? Colors.white
                      : (context.isDark ? Colors.white : NestColors.blue))),
        ),
      );
}

class DramaPoster extends StatelessWidget {
  final Drama drama;
  final double? width;
  final double? height;
  final bool compact;
  const DramaPoster(
      {super.key,
      required this.drama,
      this.width,
      this.height,
      this.compact = false});

  @override
  Widget build(BuildContext context) {
    final locale = AppScope.of(context).language;
    return ClipRRect(
      borderRadius: BorderRadius.circular(compact ? 12 : 22),
      child: SizedBox(
        width: width,
        height: height,
        child: LayoutBuilder(builder: (context, constraints) {
          final w =
              constraints.maxWidth.isFinite ? constraints.maxWidth : 150.0;
          final h =
              constraints.maxHeight.isFinite ? constraints.maxHeight : 205.0;
          return Stack(clipBehavior: Clip.hardEdge, children: [
            Positioned.fill(
              child: drama.posterUrl == null || drama.posterUrl!.isEmpty
                  ? _posterFallback(drama)
                  : CachedNetworkImage(
                      imageUrl: drama.posterUrl!,
                      fit: BoxFit.cover,
                      fadeInDuration: const Duration(milliseconds: 220),
                      placeholder: (_, __) => _posterFallback(drama),
                      errorWidget: (_, __, ___) => _posterFallback(drama),
                    ),
            ),
            Positioned(
                left: w * .35,
                top: h * .06,
                child: Container(
                    width: w * 1.02,
                    height: w * 1.02,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withValues(alpha: .16)))),
            Positioned(
                left: -w * .48,
                top: h * .2,
                child: Container(
                    width: w * 1.2,
                    height: w * 1.2,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withValues(alpha: .14)))),
            Positioned(
                right: -w * .54,
                top: h * .24,
                child: Container(
                    width: w * 1.0,
                    height: w * 1.0,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withValues(alpha: .17)))),
            Positioned.fill(
                bottom: compact ? h * .12 : h * .19,
                child: Center(
                    child: Text(drama.symbol,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: compact ? w * .31 : w * .37,
                            fontWeight: FontWeight.w700)))),
            Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                height: h * .31,
                child: const DecoratedBox(
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                            colors: [Color(0xAA7B678F), Color(0xD9243A5B)])))),
            Positioned(
                left: compact ? 8 : 12,
                right: 5,
                bottom: compact ? 31 : 57,
                child: Text(drama.isKorean ? 'K · DRAMA' : 'C · DRAMA',
                    style: TextStyle(
                        fontSize: compact ? 7 : 10,
                        letterSpacing: .6,
                        color: Colors.white,
                        fontWeight: FontWeight.w800))),
            Positioned(
                left: compact ? 8 : 12,
                right: 5,
                bottom: compact ? 7 : 21,
                child: Text(drama.localizedTitle(locale),
                    maxLines: compact ? 2 : 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontSize: compact ? 10 : (w > 240 ? 23 : 17),
                        height: 1.1,
                        color: Colors.white,
                        fontWeight: FontWeight.w800))),
          ]);
        }),
      ),
    );
  }
}

Widget _posterFallback(Drama drama) => DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [drama.start, drama.end],
        ),
      ),
    );

class DramaListTile extends StatelessWidget {
  final Drama drama;
  final VoidCallback onTap;
  const DramaListTile({super.key, required this.drama, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final app = AppScope.of(context);
    final favorite = app.isFavorite(drama.id);
    return Material(
      color: context.nestSurface,
      borderRadius: BorderRadius.circular(19),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(19),
        child: Padding(
            padding: const EdgeInsets.all(10),
            child: Row(children: [
              DramaPoster(drama: drama, width: 76, height: 100, compact: true),
              const SizedBox(width: 13),
              Expanded(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                    Text(drama.localizedTitle(app.language),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontSize: 15,
                            color: context.nestInk,
                            fontWeight: FontWeight.w800)),
                    const SizedBox(height: 5),
                    Text('${tx(context, drama.country)} · ${drama.year}',
                        style: Theme.of(context).textTheme.bodySmall),
                    Text(
                        '${tx(context, drama.genre)} · ${drama.episodes} ${tx(context, 'Серий')}',
                        style: Theme.of(context).textTheme.bodySmall),
                    const SizedBox(height: 7),
                    Text('★ ${drama.score.toStringAsFixed(1)}',
                        style: const TextStyle(
                            fontSize: 11,
                            color: NestColors.blue,
                            fontWeight: FontWeight.w800)),
                  ])),
              IconButton(
                  tooltip: tx(context,
                      favorite ? 'Удалить из избранного' : 'В избранное'),
                  onPressed: () async {
                    try {
                      await app.toggleFavorite(drama.id);
                    } catch (error) {
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text(tx(
                                context, 'Не удалось сохранить избранное'))));
                      }
                    }
                  },
                  icon: Icon(
                      favorite
                          ? Icons.favorite_rounded
                          : Icons.favorite_border_rounded,
                      color:
                          favorite ? const Color(0xFFF39AA8) : NestColors.blue,
                      size: 23)),
            ])),
      ),
    );
  }
}

class NestEmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String message;
  final String? action;
  final VoidCallback? onAction;
  const NestEmptyState(
      {super.key,
      required this.icon,
      required this.title,
      required this.message,
      this.action,
      this.onAction});
  @override
  Widget build(BuildContext context) => Center(
      child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 42),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Container(
                width: 96,
                height: 96,
                decoration: BoxDecoration(
                    color: context.nestSoftBlue,
                    borderRadius: BorderRadius.circular(32)),
                child: Icon(icon, size: 44, color: NestColors.blue)),
            const SizedBox(height: 22),
            Text(title,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            Text(message,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodySmall),
            if (action != null) ...[
              const SizedBox(height: 22),
              SizedBox(
                  width: 230,
                  child: NestButton(label: action!, onPressed: onAction))
            ],
          ])));
}

class NestPageTitle extends StatelessWidget {
  final String title;
  final String? subtitle;
  const NestPageTitle({super.key, required this.title, this.subtitle});
  @override
  Widget build(BuildContext context) =>
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(title, style: Theme.of(context).textTheme.headlineSmall),
        if (subtitle != null) ...[
          const SizedBox(height: 9),
          Text(subtitle!, style: Theme.of(context).textTheme.bodySmall)
        ],
      ]);
}
