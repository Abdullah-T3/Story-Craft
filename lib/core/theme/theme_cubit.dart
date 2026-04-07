import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ThemeCubit extends Cubit<ThemeMode> {
  ThemeCubit() : super(ThemeMode.system);

  void setThemeMode(ThemeMode mode) {
    if (state == mode) return;
    emit(mode);
  }

  /// Toggles between light and dark. If currently system, switches to dark.
  void toggleLightDark() {
    final next = switch (state) {
      ThemeMode.light => ThemeMode.dark,
      ThemeMode.dark => ThemeMode.light,
      ThemeMode.system => ThemeMode.dark,
    };
    setThemeMode(next);
  }
}
