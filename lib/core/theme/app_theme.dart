import 'package:flutter/material.dart';

class NestColors {
  static const canvas = Color(0xFFF8FBFF);
  static const ink = Color(0xFF25344B);
  static const muted = Color(0xFF8191A1);
  static const blue = Color(0xFF478FBD);
  static const blueLight = Color(0xFFE8F3FD);
  static const sky = Color(0xFFD9EFFD);
  static const peach = Color(0xFFFFEDE6);
  static const blush = Color(0xFFF7AA98);
  static const line = Color(0xFFE6EDF3);
  static const darkCanvas = Color(0xFF131C2A);
  static const darkCard = Color(0xFF1E2C3F);
}

class NestTheme {
  static ThemeData light() => _build(Brightness.light);
  static ThemeData dark() => _build(Brightness.dark);

  static ThemeData _build(Brightness brightness) {
    final dark = brightness == Brightness.dark;
    final ink = dark ? const Color(0xFFF2F7FF) : NestColors.ink;
    final bg = dark ? NestColors.darkCanvas : NestColors.canvas;
    final surface = dark ? NestColors.darkCard : Colors.white;
    final scheme = ColorScheme.fromSeed(
      seedColor: NestColors.blue,
      brightness: brightness,
      surface: surface,
    );
    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: scheme,
      scaffoldBackgroundColor: bg,
      fontFamily: 'Arial',
      appBarTheme: AppBarTheme(
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: bg,
        foregroundColor: ink,
        centerTitle: true,
        titleTextStyle:
            TextStyle(color: ink, fontSize: 16, fontWeight: FontWeight.w800),
      ),
      textTheme: TextTheme(
        headlineMedium: TextStyle(
            color: ink,
            fontWeight: FontWeight.w800,
            fontSize: 30,
            letterSpacing: -0.8),
        headlineSmall: TextStyle(
            color: ink,
            fontWeight: FontWeight.w800,
            fontSize: 24,
            letterSpacing: -0.5),
        titleLarge:
            TextStyle(color: ink, fontWeight: FontWeight.w800, fontSize: 19),
        titleMedium:
            TextStyle(color: ink, fontWeight: FontWeight.w800, fontSize: 15),
        bodyMedium: TextStyle(color: ink, height: 1.5, fontSize: 13),
        bodySmall: TextStyle(
            color: dark ? const Color(0xFFAABBCE) : NestColors.muted,
            fontSize: 12,
            height: 1.5),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surface,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 18, vertical: 17),
        hintStyle: TextStyle(
            color: dark ? const Color(0xFFAABBCE) : NestColors.muted,
            fontSize: 13),
        errorStyle: const TextStyle(fontSize: 11),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(
                color: dark ? const Color(0xFF34455A) : NestColors.line)),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: NestColors.blue, width: 1.5)),
        errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: Color(0xFFDC6672))),
        focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: Color(0xFFDC6672), width: 1.5)),
      ),
      dividerColor: dark ? const Color(0xFF34455A) : NestColors.line,
      cardColor: surface,
      snackBarTheme: SnackBarThemeData(
          behavior: SnackBarBehavior.floating,
          backgroundColor: dark ? const Color(0xFF334966) : NestColors.ink,
          contentTextStyle: const TextStyle(color: Colors.white)),
    );
  }
}

extension NestThemeAccess on BuildContext {
  bool get isDark => Theme.of(this).brightness == Brightness.dark;
  Color get nestInk => isDark ? const Color(0xFFF2F7FF) : NestColors.ink;
  Color get nestMuted => isDark ? const Color(0xFFAABBCE) : NestColors.muted;
  Color get nestSurface => isDark ? NestColors.darkCard : Colors.white;
  Color get nestSoftBlue =>
      isDark ? const Color(0xFF263E55) : NestColors.blueLight;
}
