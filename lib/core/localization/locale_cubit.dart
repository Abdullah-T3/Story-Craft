import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// `null` means follow device / EasyLocalization default.
class LocaleCubit extends Cubit<Locale?> {
  LocaleCubit() : super(null);

  void setLocale(Locale? locale) {
    if (state == locale) return;
    emit(locale);
  }
}
