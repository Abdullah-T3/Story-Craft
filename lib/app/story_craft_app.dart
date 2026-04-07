import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:story_craft/core/di/service_locator.dart';
import 'package:story_craft/core/localization/locale_cubit.dart';
import 'package:story_craft/core/responsive/responsive.dart';
import 'package:story_craft/core/theme/app_theme.dart';
import 'package:story_craft/core/theme/theme_cubit.dart';

class StoryCraftApp extends StatelessWidget {
  const StoryCraftApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ThemeCubit>.value(value: getIt<ThemeCubit>()),
        BlocProvider<LocaleCubit>.value(value: getIt<LocaleCubit>()),
      ],
      child: AppScreenUtilScope(child: const _StoryCraftMaterialApp()),
    );
  }
}

class _StoryCraftMaterialApp extends StatelessWidget {
  const _StoryCraftMaterialApp();

  @override
  Widget build(BuildContext context) {
    final themeMode = context.watch<ThemeCubit>().state;
    final locale = context.watch<LocaleCubit>().state;

    return MaterialApp.router(
      onGenerateTitle: (context) => 'appTitle'.tr(),
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: themeMode,
      locale: locale ?? context.locale,
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      routerConfig: getIt<GoRouter>(),
      debugShowCheckedModeBanner: false,
    );
  }
}
