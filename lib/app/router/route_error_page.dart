import 'package:flutter/material.dart';
import 'package:story_craft/app/router/routs.dart';
import 'package:story_craft/core/services/router/extantions.dart';
import 'package:story_craft/core/widgets/app_error_view.dart';

class RouteErrorPage extends StatelessWidget {
  const RouteErrorPage({super.key, this.routeName});

  final String? routeName;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Route error')),
      body: Center(
        child: AppErrorView(
          message: 'Could not open this route:\n${routeName ?? 'unknown'}',
          onRetry: () => context.pushNamedAndRemoveUntil(
            AppRoutes.mainLayoutPath,
            predicate: (_) => false,
          ),
        ),
      ),
    );
  }
}
