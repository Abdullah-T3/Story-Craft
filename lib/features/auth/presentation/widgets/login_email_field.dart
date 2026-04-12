import 'package:flutter/material.dart';
import 'package:story_craft/core/widgets/app_text_field.dart';

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
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'يرجى إدخال البريد الإلكتروني';
        }
        if (!RegExp(r'^[\w\-.]+@([\w-]+\.)+[\w-]{2,4}$')
            .hasMatch(value.trim())) {
          return 'البريد الإلكتروني غير صالح';
        }
        return null;
      },
    );
  }
}
