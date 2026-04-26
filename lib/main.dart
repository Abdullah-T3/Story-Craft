import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:story_craft/app/story_craft_app.dart';
import 'package:story_craft/bootstrap.dart';
import 'package:story_craft/core/observers/app_bloc_observer.dart';

Future<void> main() async {
  await bootstrap();
  Bloc.observer = AppBlocObserver();
  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('ar'), Locale('en')],
      path: 'assets/translations',
      fallbackLocale: const Locale('ar'),
      startLocale: const Locale('ar'),
      child: const StoryCraftApp(),
    ),
  );
}
