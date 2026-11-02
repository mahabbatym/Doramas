import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:dorama_nest/main.dart';
import 'package:dorama_nest/state/app_controller.dart';
import 'package:dorama_nest/data/services/drama_repository.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Splash renders and opens onboarding', (tester) async {
    tester.view.physicalSize = const ui.Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    SharedPreferences.setMockInitialValues({});
    sqfliteFfiInit();
    final directory = await tester
            .runAsync(() => Directory.systemTemp.createTemp('dorama-smoke-')) ??
        (throw StateError('Unable to create test database directory'));
    final app = AppController(
        repository: DramaRepository(
      factory: databaseFactoryFfi,
      databasePath: '${directory.path}/test.db',
    ));
    await tester.runAsync(app.init);
    await tester.pumpWidget(DoramaNestApp(controller: app));
    await tester.pump(const Duration(milliseconds: 350));
    expect(find.text('Әлеміңді аш →'), findsOneWidget);
    await tester.ensureVisible(find.text('Әлеміңді аш →'));
    await tester.tap(find.text('Әлеміңді аш →'));
    await tester.pumpAndSettle(const Duration(milliseconds: 50),
        EnginePhase.sendSemanticsUpdate, const Duration(seconds: 3));
    expect(find.text('Жалғастыру →'), findsOneWidget);
    expect(find.text('Қалғың келетін\nхикаялар'), findsOneWidget);
    await tester.runAsync(() async {
      await app.close();
      await directory.delete(recursive: true);
    });
  });
}
