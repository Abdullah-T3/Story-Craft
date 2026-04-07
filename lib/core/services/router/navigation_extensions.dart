import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:story_craft/app/router/routs.dart';

extension NavigationX on BuildContext {
  void goHome() => go(Routes.homePath);
}

extension StringExtension on String? {
  bool isNullOrEmpty() => this == null || this == '';
}

extension ListExtension<T> on List<T>? {
  bool isNullOrEmpty() => this == null || this!.isEmpty;
}
