import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:story_craft/app/router/routs.dart';
import 'package:story_craft/core/widgets/app_error_view.dart';

class RouteErrorPage extends StatelessWidget {
  const RouteErrorPage({super.key, required this.state});

  final GoRouterState state;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('routeErrorTitle'.tr())),
      body: Center(
        child: AppErrorView(
          message: '${'routeErrorMessage'.tr()}\n${state.uri}',
          onRetry: () => context.go(Routes.homePath),
        ),
      ),
    );
  }
}
