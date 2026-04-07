import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class AppErrorView extends StatelessWidget {
  const AppErrorView({super.key, this.message, this.onRetry});

  final String? message;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 48,
            color: Theme.of(context).colorScheme.error,
          ),
          const SizedBox(height: 16),
          Text(message ?? 'genericError'.tr(), textAlign: TextAlign.center),
          if (onRetry != null) ...[
            const SizedBox(height: 24),
            FilledButton(onPressed: onRetry, child: Text('retry'.tr())),
          ],
        ],
      ),
    );
  }
}
