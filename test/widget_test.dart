import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:story_craft/app/story_craft_app.dart';
import 'package:story_craft/core/di/service_locator.dart';

void main() {
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    SharedPreferences.setMockInitialValues({});
  });

  tearDown(() async {
    await GetIt.instance.reset();
  });

  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    await configureDependencies();

    await tester.pumpWidget(const StoryCraftApp());
    await tester.pumpAndSettle();

    expect(find.text('Test post'), findsOneWidget);
    expect(find.text('0'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    expect(find.text('0'), findsNothing);
    expect(find.text('1'), findsOneWidget);
  });
}
