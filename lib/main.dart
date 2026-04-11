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

// 1- add package flutter_native_splash in pubspec.yaml part of dependencies
// 2- design splash android and ios screens
//    download splash images (icon) in assets folder say splash_ios_android_11.png
// 3- design splash android 12 screen
//    in figma create frame w:640 h:640 and r:320 and center the icon in this frame
//    create new frame w:960 h:960 and center the last frame in this frame
//    final export the frame as png and name it splash_ios_android_12.png
// 4- create file in root app flutter_native_splash.yaml
  //  flutter_native_splash:
  //    color: "#5F33E1"
  //    image: assets/icons/splash_ios_android_11.png
  //    android_12:
  //      image: assets/icons/splash_android_12.png
  //      color: "#5F33E1"
// 5- run => dart run flutter_native_splash:create --path=flutter_native_splash.yaml
// 6- commit => Create splash screen from android and ios
