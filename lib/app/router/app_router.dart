import 'package:flutter/material.dart';
import 'package:story_craft/app/router/routs.dart';
import 'package:story_craft/features/auth/sign_up/presentation/pages/sign_up_page.dart';
import 'package:story_craft/features/onboarding/presentation/page/onboarding.dart';
import 'package:story_craft/features/auth/presentation/pages/login_page.dart';
import 'package:story_craft/presentation/routing/route_error_page.dart';

abstract final class AppRouter {
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.onboardingPath:
        return MaterialPageRoute<void>(
          builder: (_) => const OnboardingScreen(),
          settings: settings,
        );
      case AppRoutes.loginPath:
        return MaterialPageRoute<void>(
          builder: (_) => const LoginPage(),
          settings: settings,
        );
      case AppRoutes.signUpPath:
        return MaterialPageRoute<void>(
          builder: (_) => const SignUpPage(),
          settings: settings,
        );
      default:
        return MaterialPageRoute<void>(
          builder: (_) => RouteErrorPage(routeName: settings.name),
          settings: settings,
        );
    }
  }
}
