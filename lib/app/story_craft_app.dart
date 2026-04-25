import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:story_craft/app/router/app_router.dart';
import 'package:story_craft/app/router/routs.dart';
import 'package:story_craft/core/di/service_locator.dart';
import 'package:story_craft/core/responsive/responsive.dart';
import 'package:story_craft/core/theme/app_theme.dart';
import 'package:story_craft/core/theme/theme_cubit.dart';
import 'package:story_craft/features/auth/domain/repositories/auth_repository.dart';

class StoryCraftApp extends StatelessWidget {
  const StoryCraftApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [BlocProvider<ThemeCubit>.value(value: getIt<ThemeCubit>())],
      child: AppScreenUtilScope(child: const _StoryCraftMaterialApp()),
    );
  }
}

class _StoryCraftMaterialApp extends StatelessWidget {
  const _StoryCraftMaterialApp();

  @override
  Widget build(BuildContext context) {
    final themeMode = context.watch<ThemeCubit>().state;
    final isSignedIn = getIt<AuthRepository>().currentUser != null;

    return MaterialApp(
      onGenerateTitle: (context) => 'Story Craft',
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: themeMode,
      initialRoute: isSignedIn ? AppRoutes.mainLayoutPath : AppRoutes.onboardingPath,
      onGenerateRoute: AppRouter.onGenerateRoute,
      debugShowCheckedModeBanner: false,
    );
  }
}
