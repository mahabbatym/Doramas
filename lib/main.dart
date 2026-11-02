import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:dorama_nest/core/theme/app_theme.dart';
import 'package:dorama_nest/data/api/api_client.dart';
import 'package:dorama_nest/data/api/api_config.dart';
import 'package:dorama_nest/data/api/api_exception.dart';
import 'package:dorama_nest/data/services/supabase_drama_repository.dart';
import 'package:dorama_nest/state/app_controller.dart';
import 'package:dorama_nest/features/onboarding/welcome_screens.dart';
import 'package:dorama_nest/features/auth/auth_screens.dart';
import 'package:dorama_nest/features/home/main_shell.dart';
import 'package:dorama_nest/features/drama/drama_detail_page.dart';
import 'package:dorama_nest/features/reviews/review_pages.dart';
import 'package:dorama_nest/features/settings/settings_page.dart';
import 'package:dorama_nest/features/drama/drama_form_page.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:dorama_nest/core/l10n/generated/app_localizations.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  final config = ApiConfig.fromEnvironment();
  RemoteDramaRepository? remoteRepository;
  String? remoteUserId;
  Future<String?> Function()? authenticateAnonymously;
  ApiFailureKind? startupFailure;
  if (config.isConfigured) {
    try {
      await Supabase.initialize(
        url: config.url,
        publishableKey: config.anonKey,
      );
      final auth = Supabase.instance.client.auth;
      authenticateAnonymously = () async {
        if (auth.currentSession == null) {
          final response = await auth
              .signInAnonymously()
              .timeout(const Duration(seconds: 10));
          return response.user?.id;
        }
        return auth.currentUser?.id;
      };
      try {
        remoteUserId = await authenticateAnonymously();
      } on Object {
        startupFailure = ApiFailureKind.offline;
      }
      final preferences = await SharedPreferences.getInstance();
      remoteRepository = SupabaseDramaRepository(
        preferences: preferences,
        api: ApiClient(
          config: config,
          accessToken: () =>
              Supabase.instance.client.auth.currentSession?.accessToken,
        ),
      );
    } on Object {
      startupFailure = ApiFailureKind.unknown;
    }
  } else {
    startupFailure = ApiFailureKind.configuration;
  }
  final app = AppController(
    remoteRepository: remoteRepository,
    remoteUserId: remoteUserId,
    authenticateAnonymously: authenticateAnonymously,
    startupFailure: startupFailure,
    cloudConfigured: config.isConfigured,
  );
  await app.init();
  runApp(DoramaNestApp(controller: app));
}

class DoramaNestApp extends StatelessWidget {
  final AppController controller;
  const DoramaNestApp({super.key, required this.controller});

  @override
  Widget build(BuildContext context) => AppScope(
        controller: controller,
        child: AnimatedBuilder(
            animation: controller,
            builder: (context, _) {
              SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
                statusBarColor: Colors.transparent,
                statusBarIconBrightness:
                    controller.darkMode ? Brightness.light : Brightness.dark,
                systemNavigationBarColor: controller.darkMode
                    ? NestColors.darkCanvas
                    : NestColors.canvas,
                systemNavigationBarIconBrightness:
                    controller.darkMode ? Brightness.light : Brightness.dark,
              ));
              return MaterialApp(
                title: 'DoramaNest',
                locale: Locale(controller.language),
                supportedLocales: AppLocalizations.supportedLocales,
                localizationsDelegates: const [
                  AppLocalizations.delegate,
                  GlobalMaterialLocalizations.delegate,
                  GlobalCupertinoLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                ],
                debugShowCheckedModeBanner: false,
                theme: NestTheme.light(),
                darkTheme: NestTheme.dark(),
                themeMode:
                    controller.darkMode ? ThemeMode.dark : ThemeMode.light,
                initialRoute: '/',
                onGenerateRoute: (settings) {
                  late final Widget page;
                  final arg = settings.arguments;
                  switch (settings.name) {
                    case '/':
                      page = const SplashPage();
                      break;
                    case '/onboarding':
                      page = WelcomePage(index: arg is int ? arg : 0);
                      break;
                    case '/login':
                      page = const LoginPage();
                      break;
                    case '/register':
                      page = const RegisterPage();
                      break;
                    case '/home':
                      page = MainShell(initialIndex: arg is int ? arg : 0);
                      break;
                    case '/detail':
                      page = DramaDetailPage(
                          dramaId: arg is String ? arg : 'hidden-love');
                      break;
                    case '/dramaForm':
                      page = DramaFormPage(dramaId: arg is String ? arg : null);
                      break;
                    case '/reviews':
                      page = ReviewsPage(
                          dramaId: arg is String ? arg : 'hidden-love');
                      break;
                    case '/reviewForm':
                      final map =
                          arg is Map<String, String> ? arg : <String, String>{};
                      page = ReviewFormPage(
                          dramaId: map['dramaId'] ?? 'hidden-love',
                          reviewId: map['reviewId']);
                      break;
                    case '/settings':
                      page = const SettingsPage();
                      break;
                    default:
                      page = const SplashPage();
                      break;
                  }
                  return PageRouteBuilder<void>(
                    settings: settings,
                    pageBuilder: (context, animation, secondaryAnimation) =>
                        page,
                    transitionDuration: const Duration(milliseconds: 380),
                    transitionsBuilder:
                        (context, animation, secondaryAnimation, child) =>
                            FadeTransition(
                      opacity: CurvedAnimation(
                          parent: animation, curve: Curves.easeInOutCubic),
                      child: ScaleTransition(
                        scale: Tween<double>(begin: .985, end: 1).animate(
                            CurvedAnimation(
                                parent: animation, curve: Curves.easeOutCubic)),
                        child: child,
                      ),
                    ),
                  );
                },
              );
            }),
      );
}
