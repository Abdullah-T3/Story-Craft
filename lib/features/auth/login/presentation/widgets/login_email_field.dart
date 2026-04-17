import 'package:flutter/material.dart';
import 'package:story_craft/core/widgets/app_text_field.dart';
import 'package:story_craft/features/auth/shared/validators/auth_validators.dart';

class LoginEmailField extends StatelessWidget {
  const LoginEmailField({required this.controller, super.key});

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return AppTextField(
      controller: controller,
      label: 'البريد الإلكتروني',
      hint: 'أدخل بريدك هنا',
      trailingIcon: const Icon(Icons.mail_outline_rounded),
      keyboardType: TextInputType.emailAddress,
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.right,
      textInputAction: TextInputAction.next,
      validator: AuthValidators.email,
    );
  }
}
