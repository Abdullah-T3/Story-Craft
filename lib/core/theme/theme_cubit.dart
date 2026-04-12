import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:story_craft/core/services/local_storage_service/shared_prefs/shared_pref_helper.dart';

class ThemeCubit extends Cubit<ThemeMode> {
  ThemeCubit(this._prefs) : super(ThemeMode.system) {
    _loadSavedTheme();
  }

  final SharedPrefsHelper _prefs;

  static const _kThemeModeKey = 'theme_mode';

  void _loadSavedTheme() {
    final saved = _prefs.getData<int>(key: _kThemeModeKey);
    if (saved != null && saved < ThemeMode.values.length) {
      emit(ThemeMode.values[saved]);
    }
  }

  void setThemeMode(ThemeMode mode) {
    if (state == mode) return;
    _prefs.storeData<int>(key: _kThemeModeKey, value: mode.index);
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
