import 'package:flutter/material.dart';
import 'package:story_craft/app/router/routs.dart';
import 'package:story_craft/features/auth/presentation/pages/login_page.dart';
import 'package:story_craft/features/home/presentation/pages/home_page.dart';
import 'package:story_craft/presentation/routing/route_error_page.dart';

abstract final class AppRouter {
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.loginPath:
        return MaterialPageRoute<void>(
          builder: (_) => const LoginPage(),
          settings: settings,
        );
      case AppRoutes.homePath:
        return MaterialPageRoute<void>(
          builder: (_) => const HomePage(),
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
