import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:story_craft/app/router/routs.dart';
import 'package:story_craft/core/theme/app_colors.dart';
import 'package:story_craft/core/widgets/app_text_field.dart';
import 'package:story_craft/core/widgets/buttons.dart';
import 'package:story_craft/features/auth/sign_up/presentation/cubit/sign_up_cubit.dart';
import 'package:story_craft/features/auth/sign_up/presentation/widgets/password_strength_bar.dart';

class SignUpStepOne extends StatelessWidget {
  const SignUpStepOne({
    super.key,
    required this.nameController,
    required this.emailController,
    required this.passwordController,
  });

  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController passwordController;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'إنشاء حساب جديد',
            style: TextStyle(
              fontSize: 26.sp,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: 6.h),
          Text(
            'خطوة 1 من 2 - معلوماتك',
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w400,
              color: AppColors.textSecondary,
            ),
          ),

          SizedBox(height: 30.h),

          AppTextField(
            controller: nameController,
            label: 'الاسم',
            hint: 'ما هو اسمك؟',
            trailingIcon: const Icon(Icons.person_outline),
            backgroundColor: AppColors.secondaryContainer.withValues(
              alpha: 0.2,
            ),
            textInputAction: TextInputAction.next,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'ادخل الاسم';
              }
              return null;
            },
          ),
          SizedBox(height: 16.h),
          AppTextField(
            controller: emailController,
            label: 'البريد الإلكتروني',
            hint: 'example@mail.com',
            trailingIcon: const Icon(Icons.email_outlined),
            keyboardType: TextInputType.emailAddress,
            backgroundColor: AppColors.secondaryContainer.withValues(
              alpha: 0.2,
            ),
            textInputAction: TextInputAction.next,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'يرجى إدخال البريد الإلكتروني';
              }
              if (!RegExp(
                r'^[\w\-.]+@([\w-]+\.)+[\w-]{2,4}$',
              ).hasMatch(value.trim())) {
                return 'البريد الإلكتروني غير صالح';
              }
              return null;
            },
          ),
          SizedBox(height: 16.h),
          AppTextField(
            controller: passwordController,
            label: 'كلمة المرور',
            hint: '••••••••',
            trailingIcon: const Icon(Icons.lock_outline),
            isPassword: true,
            textInputAction: TextInputAction.done,
            backgroundColor: AppColors.secondaryContainer.withValues(
              alpha: 0.2,
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'يرجى إدخال كلمة المرور';
              }
              if (value.length < 6) {
                return 'كلمة المرور يجب أن تكون 6 أحرف على الأقل';
              }
              return null;
            },
          ),
          SizedBox(height: 12.h),
          ValueListenableBuilder(
            valueListenable: passwordController,
            builder: (context, value, child) {
              return PasswordStrengthBar(password: value.text);
            },
          ),
          SizedBox(height: 70.h),
          Buttons(
            label: 'التالي',
            onPressed: () {
              if (Form.of(context).validate()) {
                context.read<SignUpCubit>().goToNextStep();
              }
            },
            style: AppButtonStyle.filled,
            suffixIcon: const Icon(Icons.arrow_forward, color: Colors.white),
            backgroundColor: AppColors.primaryDark,
          ),

          SizedBox(height: 22.h),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'لديك حساب بالفعل؟ ',
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 16.sp,
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, AppRoutes.loginPath);
                },
                child: Text(
                  'تسجيل الدخول',
                  style: TextStyle(
                    color: AppColors.primaryDark,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
