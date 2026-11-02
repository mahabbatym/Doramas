import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:dorama_nest/data/services/drama_repository.dart';
import 'package:dorama_nest/main.dart';
import 'package:dorama_nest/state/app_controller.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('all locales switch live and the selected locale persists',
      (tester) async {
    tester.view.physicalSize = const ui.Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    SharedPreferences.setMockInitialValues({});
    sqfliteFfiInit();
    final directory = await tester
            .runAsync(() => Directory.systemTemp.createTemp('dorama-l10n-')) ??
        (throw StateError('Unable to create localization test directory'));
    final databasePath = '${directory.path}/test.db';
    AppController createController() => AppController(
            repository: DramaRepository(
          factory: databaseFactoryFfi,
          databasePath: databasePath,
        ));

    final app = createController();
    await tester.runAsync(app.init);
    expect(app.language, 'kk');
    await tester.pumpWidget(DoramaNestApp(controller: app));
    await tester.pump();

    const buttons = {
      'kk': 'Әлеміңді аш →',
      'ru': 'Открыть свой мир →',
      'en': 'Open your world →',
      'ko': '나만의 세상 열기 →',
    };
    for (final entry in buttons.entries) {
      await tester.runAsync(() => app.setLanguage(entry.key));
      await tester.pump();
      expect(find.text(entry.value), findsOneWidget,
          reason: 'Expected the ${entry.key} translation after switching');
    }

    await tester.pumpWidget(const SizedBox.shrink());
    await tester.runAsync(app.close);
    final restarted = createController();
    await tester.runAsync(restarted.init);
    expect(restarted.language, 'ko');
    await tester.runAsync(restarted.close);
    await tester.runAsync(() => directory.delete(recursive: true));
  });
}
