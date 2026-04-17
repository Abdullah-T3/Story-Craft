import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:story_craft/core/theme/app_colors.dart';
import 'package:story_craft/features/auth/login/presentation/cubit/auth_cubit.dart';
import 'package:story_craft/features/auth/login/presentation/cubit/auth_state.dart';

class LoginGoogleButton extends StatelessWidget {
  const LoginGoogleButton({required this.onPressed, super.key});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        final isLoading = state is AuthLoading;
        return SizedBox(
          height: 52.h,
          child: OutlinedButton.icon(
            onPressed: isLoading ? null : onPressed,
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.textPrimary,
              side: const BorderSide(color: AppColors.borderLighter),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.r),
              ),
              backgroundColor: Colors.white,
              textStyle: TextStyle(
                fontSize: 15.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
            icon: Image.network(
              'https://www.gstatic.com/firebasejs/ui/2.0.0/images/auth/google.svg',
              width: 22.w,
              height: 22.w,
              errorBuilder: (context, error, stackTrace) => Icon(
                Icons.g_mobiledata_rounded,
                size: 28.sp,
                color: const Color(0xFF4285F4), // Google brand blue
              ),
            ),
            label: const Text('المتابعة باستخدام جوجل'),
          ),
        );
      },
    );
  }
}
