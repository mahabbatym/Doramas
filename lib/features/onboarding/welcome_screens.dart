import 'package:flutter/material.dart';
import 'package:dorama_nest/core/locale_text.dart';
import 'package:dorama_nest/core/theme/app_theme.dart';
import 'package:dorama_nest/core/widgets/nest_widgets.dart';
import 'package:dorama_nest/state/app_controller.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});
  @override
  Widget build(BuildContext context) {
    final app = AppScope.of(context);
    return Scaffold(body: DecoratedBox(
      decoration: BoxDecoration(gradient: LinearGradient(begin: Alignment.topLeft,
        end: Alignment.bottomRight, colors: context.isDark
          ? [NestColors.darkCanvas, NestColors.darkCard]
          : [const Color(0xFFFFF7EE), NestColors.canvas])),
      child: SafeArea(child: LayoutBuilder(builder: (context, constraints) =>
        SingleChildScrollView(child: ConstrainedBox(constraints: BoxConstraints(minHeight: constraints.maxHeight),
          child: Padding(padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 36),
            child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              ClipOval(child: Image.asset('assets/art/seoul_evening.jpg', width: 272, height: 272,
                fit: BoxFit.cover, cacheWidth: 816, excludeFromSemantics: true)),
              const SizedBox(height: 26),
              Text.rich(TextSpan(children: [
                TextSpan(text: 'Dorama', style: TextStyle(color: context.nestInk)),
                const TextSpan(text: 'Nest', style: TextStyle(color: NestColors.blue)),
              ]), style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 35)),
              const SizedBox(height: 10),
              Text(tx(context, 'Твои истории. Твои эмоции.\nТвой маленький мир дорам.'),
                textAlign: TextAlign.center, style: Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: 13)),
              const SizedBox(height: 55),
              NestButton(label: tx(context, 'Открыть свой мир →'), onPressed: () =>
                Navigator.pushReplacementNamed(context, app.hasSession || app.onboardingComplete ? '/home' : '/onboarding')),
              const SizedBox(height: 21),
              Text(tx(context, 'ХИКАЯ ЖАҚСЫ КӨРЕТІНДЕРГЕ'), textAlign: TextAlign.center,
                style: TextStyle(fontSize: 9, letterSpacing: 2, color: context.nestMuted, fontWeight: FontWeight.w900)),
            ])),
        )),
      )),
    ));
  }
}

class WelcomePage extends StatelessWidget {
  final int index;
  const WelcomePage({super.key, required this.index});
  Future<void> _finish(BuildContext context) async {
    final app = AppScope.of(context);
    await app.finishOnboarding();
    if (context.mounted) Navigator.pushReplacementNamed(context, app.hasSession ? '/home' : '/login');
  }
  @override
  Widget build(BuildContext context) {
    final second = index == 1;
    return Scaffold(body: SafeArea(child: LayoutBuilder(builder: (context, constraints) =>
      SingleChildScrollView(child: ConstrainedBox(constraints: BoxConstraints(minHeight: constraints.maxHeight),
        child: Padding(padding: pagePadding, child: Column(children: [
          Row(children: [
            if (second) IconButton(onPressed: () => Navigator.pushReplacementNamed(context, '/onboarding', arguments: 0),
              icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18)),
            const Spacer(),
            TextButton(onPressed: () => _finish(context), child: Text(tx(context, 'Пропустить ›'))),
          ]),
          const SizedBox(height: 22),
          ClipRRect(borderRadius: BorderRadius.circular(36), child: Image.asset(
            second ? 'assets/art/community_evening.jpg' : 'assets/art/seoul_evening.jpg',
            width: double.infinity, height: (constraints.maxHeight * .4).clamp(200, 320),
            fit: BoxFit.cover, cacheWidth: 960, excludeFromSemantics: true)),
          const SizedBox(height: 28),
          Text(tx(context, second ? 'Каждая дорама —\nповод обсудить' : 'Истории, в которых\nхочется остаться'),
            textAlign: TextAlign.center, style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontSize: 28, height: 1.3)),
          const SizedBox(height: 15),
          Text(tx(context, second ? 'Делись впечатлениями, оценивай и находи единомышленников.' : 'Открывай корейские и китайские дорамы в одном уютном месте.'),
            textAlign: TextAlign.center, style: Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: 13)),
          const SizedBox(height: 20),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: List.generate(2, (i) =>
            AnimatedContainer(duration: const Duration(milliseconds: 200), margin: const EdgeInsets.symmetric(horizontal: 3),
              width: i == index ? 24 : 8, height: 6, decoration: BoxDecoration(
                color: i == index ? NestColors.blue : const Color(0xFFCBDDEB), borderRadius: BorderRadius.circular(20))))),
          const SizedBox(height: 30),
          NestButton(label: tx(context, second ? 'Начать ✦' : 'Продолжить →'), onPressed: () {
            if (second) { _finish(context); }
            else { Navigator.pushReplacementNamed(context, '/onboarding', arguments: 1); }
          }),
          const SizedBox(height: 30),
        ])),
      )),
    )));
  }
}
