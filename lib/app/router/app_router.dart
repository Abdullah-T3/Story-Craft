import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';
import 'package:story_craft/app/router/routs.dart';
import 'package:story_craft/features/home/presentation/pages/home_page.dart';
import 'package:story_craft/presentation/routing/route_error_page.dart';

abstract final class AppRouter {
  static GoRouter create() {
    return GoRouter(
      initialLocation: Routes.homePath,
      debugLogDiagnostics: kDebugMode,
      routes: [
        GoRoute(
          path: Routes.homePath,
          name: Routes.homeName,
          builder: (context, state) => const HomePage(),
        ),
      ],
      errorBuilder: (context, state) => RouteErrorPage(state: state),
    );
  }
}
