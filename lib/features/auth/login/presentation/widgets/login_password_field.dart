import 'package:flutter/material.dart';
import 'package:story_craft/core/widgets/app_text_field.dart';
import 'package:story_craft/features/auth/shared/validators/auth_validators.dart';

class LoginPasswordField extends StatelessWidget {
  const LoginPasswordField({required this.controller, super.key});

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return AppTextField(
      controller: controller,
      label: 'كلمة المرور',
      hint: 'كلمة المرور السرية',
      trailingIcon: const Icon(Icons.lock_outline_rounded),
      isPassword: true,
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.right,
      textInputAction: TextInputAction.done,
      validator: AuthValidators.password,
    );
  }
}
