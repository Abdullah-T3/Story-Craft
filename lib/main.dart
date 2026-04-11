import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:story_craft/app/story_craft_app.dart';
import 'package:story_craft/bootstrap.dart';
import 'package:story_craft/core/observers/app_bloc_observer.dart';

Future<void> main() async {
  await bootstrap();
  Bloc.observer = AppBlocObserver();
  runApp(const StoryCraftApp());
}
