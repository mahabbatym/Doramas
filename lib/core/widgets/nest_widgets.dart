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
  const DramaPoster({super.key, required this.drama, this.width, this.height, this.compact = false});
  @override
  Widget build(BuildContext context) {
    final title = drama.localizedTitle(AppScope.of(context).language);
    return Semantics(label: title, image: true, child: ClipRRect(
      borderRadius: BorderRadius.circular(compact ? 12 : 22),
      child: SizedBox(width: width, height: height, child: LayoutBuilder(builder: (context, constraints) {
        final wide = constraints.maxWidth > constraints.maxHeight;
        final url = wide ? drama.backdropUrl ?? drama.posterUrl : drama.posterUrl;
        final uri = Uri.tryParse(url ?? '');
        final fallback = _PosterFallback(drama: drama, title: title, compact: compact);
        if (uri == null || uri.scheme != 'https' || uri.host.isEmpty) return fallback;
        return CachedNetworkImage(
          imageUrl: url!, fit: (uri.host == 'i.ytimg.com' || uri.host == 'img.youtube.com') && !wide ? BoxFit.contain : BoxFit.cover,
          memCacheWidth: ((constraints.maxWidth.isFinite ? constraints.maxWidth : 200) * MediaQuery.devicePixelRatioOf(context)).round().clamp(100, 1200),
          maxWidthDiskCache: 1200,
          fadeInDuration: const Duration(milliseconds: 180),
          placeholder: (_, __) => fallback,
          errorWidget: (_, __, ___) => fallback,
          imageBuilder: (context, provider) => DecoratedBox(
            decoration: BoxDecoration(gradient: LinearGradient(colors: [drama.start, drama.end])),
            child: Image(image: provider, fit: (uri.host == 'i.ytimg.com' || uri.host == 'img.youtube.com') && !wide ? BoxFit.contain : BoxFit.cover,
              width: double.infinity, height: double.infinity, excludeFromSemantics: true)),
        );
      })),
    ));
  }
}

class _PosterFallback extends StatelessWidget {
  const _PosterFallback({required this.drama, required this.title, required this.compact});
  final Drama drama;
  final String title;
  final bool compact;
  @override
  Widget build(BuildContext context) => DecoratedBox(
    decoration: BoxDecoration(gradient: LinearGradient(begin: Alignment.topLeft,
      end: Alignment.bottomRight, colors: [drama.start, drama.end])),
    child: Padding(padding: EdgeInsets.all(compact ? 8 : 18), child: Column(
      mainAxisAlignment: MainAxisAlignment.center, children: [
        Text('D O R A M A  N E S T', maxLines: 1, overflow: TextOverflow.clip,
          style: TextStyle(color: Colors.white70, fontSize: compact ? 5 : 9)),
        SizedBox(height: compact ? 8 : 18),
        Text(title, textAlign: TextAlign.center, maxLines: 3, overflow: TextOverflow.ellipsis,
          style: TextStyle(color: Colors.white, fontSize: compact ? 11 : 20,
            height: 1.2, fontWeight: FontWeight.w800)),
        SizedBox(height: compact ? 8 : 18),
        Text('${drama.year}', style: TextStyle(color: Colors.white70, fontSize: compact ? 8 : 12)),
      ])),
  );
}

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
                        '${genreLabel(context, drama.genreKeys.first)} · ${drama.episodes} ${tx(context, 'Серий')}',
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
