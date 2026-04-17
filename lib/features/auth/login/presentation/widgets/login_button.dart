import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:story_craft/core/theme/app_colors.dart';
import 'package:story_craft/core/widgets/app_inline_loader.dart';
import 'package:story_craft/features/auth/login/presentation/cubit/auth_cubit.dart';
import 'package:story_craft/features/auth/login/presentation/cubit/auth_state.dart';

class LoginButton extends StatelessWidget {
  const LoginButton({required this.onPressed, super.key});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        final isLoading = state is AuthLoading;
        return SizedBox(
          height: 52.h,
          child: FilledButton(
            onPressed: isLoading ? null : onPressed,
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.primaryDark,
              foregroundColor: Colors.white,
              disabledBackgroundColor: AppColors.primaryDark.withValues(
                alpha: 0.6,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.r),
              ),
              textStyle: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            child: isLoading
                ? const AppInlineLoader(size: 24)
                : const Text('دخول'),
          ),
        );
      },
    );
  }
}
