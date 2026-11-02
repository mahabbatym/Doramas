import 'package:flutter/material.dart';
import 'package:dorama_nest/core/locale_text.dart';
import 'package:dorama_nest/core/theme/app_theme.dart';
import 'package:dorama_nest/core/widgets/nest_widgets.dart';
import 'package:dorama_nest/state/app_controller.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
          body: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: context.isDark
                    ? [NestColors.darkCanvas, NestColors.darkCard]
                    : [const Color(0xFFFFF7EE), NestColors.canvas])),
        child: SafeArea(
            child: LayoutBuilder(
                builder: (context, constraints) => Center(
                      child: SingleChildScrollView(
                          child: ConstrainedBox(
                              constraints: BoxConstraints(
                                  minHeight: constraints.maxHeight),
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 36),
                                child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const SizedBox(height: 55),
                                      Container(
                                          width: 272,
                                          height: 272,
                                          decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              gradient: LinearGradient(colors: [
                                                NestColors.sky
                                                    .withValues(alpha: .2),
                                                NestColors.peach
                                                    .withValues(alpha: .85)
                                              ])),
                                          child: Center(
                                              child: Stack(
                                                  clipBehavior: Clip.none,
                                                  children: [
                                                Container(
                                                    width: 108,
                                                    height: 108,
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(25),
                                                        gradient:
                                                            const LinearGradient(
                                                                colors: [
                                                              Color(0xFF5DAFDA),
                                                              Color(0xFF347FAE)
                                                            ])),
                                                    child: const Icon(
                                                        Icons
                                                            .favorite_border_rounded,
                                                        color: Colors.white,
                                                        size: 61)),
                                                const Positioned(
                                                    top: 65,
                                                    left: -30,
                                                    child: Text('✧',
                                                        style: TextStyle(
                                                            color:
                                                                NestColors.blue,
                                                            fontSize: 26))),
                                                const Positioned(
                                                    top: -15,
                                                    right: -21,
                                                    child: Text('✦',
                                                        style: TextStyle(
                                                            color: NestColors
                                                                .blush,
                                                            fontSize: 24))),
                                              ]))),
                                      const SizedBox(height: 23),
                                      RichText(
                                          text: TextSpan(children: [
                                        TextSpan(
                                            text: 'Dorama',
                                            style: TextStyle(
                                                color: context.nestInk,
                                                fontWeight: FontWeight.w900,
                                                fontSize: 35)),
                                        const TextSpan(
                                            text: 'Nest',
                                            style: TextStyle(
                                                color: NestColors.blue,
                                                fontWeight: FontWeight.w900,
                                                fontSize: 35))
                                      ])),
                                      const SizedBox(height: 10),
                                      Text(
                                          tx(context,
                                              'Твои истории. Твои эмоции.\nТвой маленький мир дорам.'),
                                          textAlign: TextAlign.center,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodySmall
                                              ?.copyWith(fontSize: 13)),
                                      const SizedBox(height: 105),
                                      NestButton(
                                          label:
                                              tx(context, 'Открыть свой мир →'),
                                          onPressed: () =>
                                              Navigator.pushReplacementNamed(
                                                  context,
                                                  AppScope.of(context)
                                                              .loggedIn ||
                                                          AppScope.of(context)
                                                              .hasAnonymousSession
                                                      ? '/home'
                                                      : '/onboarding')),
                                      const SizedBox(height: 21),
                                      Text(
                                          tx(context,
                                              'ХИКАЯ ЖАҚСЫ КӨРЕТІНДЕРГЕ'),
                                          style: TextStyle(
                                              fontSize: 9,
                                              letterSpacing: 2.5,
                                              color: context.nestMuted,
                                              fontWeight: FontWeight.w900)),
                                      const SizedBox(height: 65),
                                    ]),
                              ))),
                    ))),
      ));
}

class WelcomePage extends StatelessWidget {
  final int index;
  const WelcomePage({super.key, required this.index});

  @override
  Widget build(BuildContext context) {
    final second = index == 1;
    return Scaffold(
        body: SafeArea(
            child: Padding(
                padding: pagePadding,
                child: Column(children: [
                  Padding(
                      padding: const EdgeInsets.only(top: 12),
                      child: Row(children: [
                        if (second)
                          IconButton(
                              onPressed: () => Navigator.pushReplacementNamed(
                                  context, '/onboarding', arguments: 0),
                              icon: const Icon(Icons.arrow_back_ios_new_rounded,
                                  size: 18)),
                        const Spacer(),
                        TextButton(
                            onPressed: () => Navigator.pushReplacementNamed(
                                context, '/login'),
                            child: Text(tx(context, 'Пропустить ›'),
                                style: const TextStyle(
                                    color: NestColors.blue,
                                    fontWeight: FontWeight.w700))),
                      ])),
                  const Spacer(),
                  Container(
                      width: double.infinity,
                      height: 320,
                      decoration: BoxDecoration(
                          color: context.nestSoftBlue,
                          borderRadius: BorderRadius.circular(36)),
                      child: Stack(children: [
                        Align(
                            alignment: Alignment.center,
                            child: Container(
                                width: 235,
                                height: 235,
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    gradient: LinearGradient(
                                        colors: second
                                            ? [
                                                const Color(0xFFF5D3DC),
                                                const Color(0xFFD8E9FD)
                                              ]
                                            : [
                                                const Color(0xFFB9DCF3),
                                                const Color(0xFFFAE1DA)
                                              ])),
                                child: Icon(
                                    second
                                        ? Icons.mark_unread_chat_alt_rounded
                                        : Icons.movie_creation_outlined,
                                    size: 105,
                                    color: Colors.white))),
                        const Positioned(
                            top: 25,
                            right: 33,
                            child: Text('✦',
                                style: TextStyle(
                                    color: NestColors.blue, fontSize: 31))),
                        const Positioned(
                            bottom: 22,
                            left: 25,
                            child: Text('✧',
                                style: TextStyle(
                                    color: NestColors.blush, fontSize: 34))),
                      ])),
                  const SizedBox(height: 32),
                  Text(
                      tx(
                          context,
                          second
                              ? 'Каждая дорама —\nповод обсудить'
                              : 'Истории, в которых\nхочется остаться'),
                      textAlign: TextAlign.center,
                      style: Theme.of(context)
                          .textTheme
                          .headlineSmall
                          ?.copyWith(fontSize: 28, height: 1.3)),
                  const SizedBox(height: 15),
                  Text(
                      tx(
                          context,
                          second
                              ? 'Делись впечатлениями, оценивай и находи единомышленников.'
                              : 'Открывай корейские и китайские дорамы в одном уютном месте.'),
                      textAlign: TextAlign.center,
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall
                          ?.copyWith(fontSize: 13)),
                  const SizedBox(height: 18),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                          2,
                          (i) => AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              margin: const EdgeInsets.symmetric(horizontal: 3),
                              width: i == index ? 24 : 8,
                              height: 6,
                              decoration: BoxDecoration(
                                  color: i == index
                                      ? NestColors.blue
                                      : const Color(0xFFCBDDEB),
                                  borderRadius: BorderRadius.circular(20))))),
                  const Spacer(),
                  NestButton(
                      label: tx(context, second ? 'Начать ✦' : 'Продолжить →'),
                      onPressed: () => Navigator.pushReplacementNamed(
                          context,
                          second
                              ? (AppScope.of(context).hasAnonymousSession
                                  ? '/home'
                                  : '/login')
                              : '/onboarding',
                          arguments: 1)),
                  const SizedBox(height: 37),
                ]))));
  }
}
