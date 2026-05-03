import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:story_craft/core/responsive/app_screen_util_scope.dart';
import 'package:story_craft/core/services/local_storage_service/shared_prefs/shared_pref_helper.dart';
import 'package:story_craft/core/theme/theme_cubit.dart';
import 'package:story_craft/core/widgets/buttons.dart';

Widget _wrap(Widget child) {
  return AppScreenUtilScope(
    child: MaterialApp(home: Scaffold(body: child)),
  );
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Buttons widget', () {
    testWidgets('renders the label', (tester) async {
      await tester.pumpWidget(
        _wrap(Buttons(label: 'Continue', onPressed: () {})),
      );
      await tester.pumpAndSettle();

      expect(find.text('Continue'), findsOneWidget);
    });

    testWidgets('invokes onPressed when tapped', (tester) async {
      var taps = 0;
      await tester.pumpWidget(
        _wrap(Buttons(label: 'Tap me', onPressed: () => taps++)),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Tap me'));
      await tester.pump();

      expect(taps, 1);
    });

    testWidgets('shows loader and ignores taps while loading', (tester) async {
      var taps = 0;
      await tester.pumpWidget(
        _wrap(
          Buttons(
            label: 'Submit',
            isLoading: true,
            onPressed: () => taps++,
          ),
        ),
      );
      await tester.pump();

      expect(find.text('Submit'), findsNothing);
      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      await tester.tap(find.byType(Buttons));
      await tester.pump();
      expect(taps, 0);
    });

    testWidgets('renders prefix and suffix icons', (tester) async {
      await tester.pumpWidget(
        _wrap(
          Buttons(
            label: 'Next',
            onPressed: () {},
            prefixIcon: const Icon(Icons.star, key: ValueKey('prefix')),
            suffixIcon: const Icon(
              Icons.arrow_forward,
              key: ValueKey('suffix'),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byKey(const ValueKey('prefix')), findsOneWidget);
      expect(find.byKey(const ValueKey('suffix')), findsOneWidget);
    });
  });

  group('ThemeCubit', () {
    setUp(() {
      SharedPreferences.setMockInitialValues({});
    });

    Future<ThemeCubit> buildCubit() async {
      final prefs = await SharedPreferences.getInstance();
      return ThemeCubit(SharedPrefsHelper(prefs));
    }

    test('starts in system mode by default', () async {
      final cubit = await buildCubit();
      expect(cubit.state, ThemeMode.system);
    });

    test('setThemeMode emits the new mode', () async {
      final cubit = await buildCubit();
      cubit.setThemeMode(ThemeMode.dark);
      expect(cubit.state, ThemeMode.dark);
    });

    test('setThemeMode is a no-op when already in that mode', () async {
      final cubit = await buildCubit();
      final emitted = <ThemeMode>[];
      final sub = cubit.stream.listen(emitted.add);

      cubit.setThemeMode(ThemeMode.dark);
      cubit.setThemeMode(ThemeMode.dark);

      await Future<void>.delayed(Duration.zero);
      await sub.cancel();
      expect(emitted, [ThemeMode.dark]);
    });

    test('toggleLightDark cycles light -> dark -> light', () async {
      final cubit = await buildCubit();
      cubit.setThemeMode(ThemeMode.light);

      cubit.toggleLightDark();
      expect(cubit.state, ThemeMode.dark);

      cubit.toggleLightDark();
      expect(cubit.state, ThemeMode.light);
    });

    test('toggleLightDark from system goes to dark', () async {
      final cubit = await buildCubit();
      expect(cubit.state, ThemeMode.system);

      cubit.toggleLightDark();
      expect(cubit.state, ThemeMode.dark);
    });

    test('persists selected mode and restores on next instance', () async {
      final first = await buildCubit();
      first.setThemeMode(ThemeMode.dark);

      final prefs = await SharedPreferences.getInstance();
      final restored = ThemeCubit(SharedPrefsHelper(prefs));
      expect(restored.state, ThemeMode.dark);
    });
  });
}
