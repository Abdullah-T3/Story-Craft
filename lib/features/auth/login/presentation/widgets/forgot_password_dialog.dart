import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:story_craft/core/theme/app_colors.dart';
import 'package:story_craft/features/auth/login/presentation/cubit/auth_cubit.dart';

/// Call [ForgotPasswordDialog.show] to present the reset-password dialog.
class ForgotPasswordDialog extends StatefulWidget {
  const ForgotPasswordDialog({super.key});

  static Future<void> show(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (_) => BlocProvider.value(
        value: context.read<AuthCubit>(),
        child: const ForgotPasswordDialog(),
      ),
    );
  }

  @override
  State<ForgotPasswordDialog> createState() => _ForgotPasswordDialogState();
}

class _ForgotPasswordDialogState extends State<ForgotPasswordDialog> {
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: AlertDialog(
        title: const Text('إعادة تعيين كلمة المرور'),
        content: TextField(
          controller: _emailController,
          keyboardType: TextInputType.emailAddress,
          textDirection: TextDirection.ltr,
          textAlign: TextAlign.right,
          decoration: const InputDecoration(hintText: 'أدخل بريدك الإلكتروني'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('إلغاء'),
          ),
          FilledButton(
            onPressed: _submit,
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.primaryDark,
            ),
            child: const Text('إرسال'),
          ),
        ],
      ),
    );
  }

  void _submit() {
    final email = _emailController.text.trim();
    if (email.isEmpty) return;
    context.read<AuthCubit>().resetPassword(email: email);
    Navigator.of(context).pop();
  }
}
