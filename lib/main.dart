import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:story_craft/app/story_craft_app.dart';
import 'package:story_craft/bootstrap.dart';
import 'package:story_craft/core/observers/app_bloc_observer.dart';

Future<void> main() async {
  await EasyLocalization.ensureInitialized();
  await bootstrap();
  Bloc.observer = AppBlocObserver();
  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('en'), Locale('ar')],
      path: 'assets/translations',
      fallbackLocale: const Locale('en'),
      child: const StoryCraftApp(),
    ),
  );
}
