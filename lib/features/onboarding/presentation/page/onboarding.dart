import 'package:flutter/material.dart';
import 'package:story_craft/app/router/routs.dart';
import 'package:story_craft/core/services/router/extantions.dart';
import 'package:story_craft/core/theme/app_colors.dart';
import 'package:story_craft/core/widgets/main_scaffold.dart';
import 'package:story_craft/core/widgets/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:story_craft/features/onboarding/presentation/widgets/mascot_section.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MainScaffold(
      child: Stack(
        fit: StackFit.expand,
        children: [
          SafeArea(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 32.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: 72.h),
                    SizedBox(
                      child: Stack(
                        alignment: Alignment.center,
                        clipBehavior: Clip.none,
                        children: [
                          const MascotSection(),
                          Positioned(
                            top: 40.h,
                            left: -82.w,
                            child: SvgPicture.asset(
                              'assets/icons/Cloud2.svg',
                              width: 100.w,
                              height: 60.h,
                              fit: BoxFit.contain,
                            ),
                          ),
                          Positioned(
                            top: -60.h,
                            right: -50.w,
                            child: SvgPicture.asset(
                              'assets/icons/Cloud1.svg',
                              width: 100.w,
                              height: 60.h,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 32.h),

                    Text(
                      'قصصي',
                      style: TextStyle(
                        fontSize: 36.sp,
                        fontWeight: FontWeight.bold,
                        color: AppColors.onPrimaryContainer,
                      ),
                      textAlign: TextAlign.center,
                    ),

                    SizedBox(height: 12.h),

                    Text(
                      'اكتب قصصك وشارك خيالك',
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 16.sp,
                        height: 1.4,
                      ),
                      textAlign: TextAlign.center,
                    ),

                    SizedBox(height: 52.h),

                    SizedBox(
                      width: 280.w,
                      child: Buttons(
                        label: 'سجّل دخول',
                        style: AppButtonStyle.filled,
                        backgroundColor: AppColors.primaryDark,
                        suffixIcon: SvgPicture.asset(
                          'assets/icons/SignIn.svg',
                          width: 16.w,
                          height: 16.h,
                        ),
                        onPressed: () => context.pushNamed(AppRoutes.loginPath),
                      ),
                    ),

                    SizedBox(height: 16.h),

                    SizedBox(
                      width: 280.w,
                      child: Buttons(
                        label: 'أنشئ حساب جديد',
                        style: AppButtonStyle.outlined,
                        suffixIcon: SvgPicture.asset(
                          'assets/icons/SignUp.svg',
                          width: 16.w,
                          height: 16.h,
                        ),
                        onPressed: () =>
                            context.pushNamed(AppRoutes.signUpPath),
                      ),
                    ),

                    SizedBox(height: 50.h),

                    GestureDetector(
                      onTap: () {},
                      child: Text(
                        'استمرار بدون تسجيل',
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 16.sp,
                        ),
                      ),
                    ),

                    SizedBox(height: 118.h),
                  ],
                ),
              ),
            ),
          ),

          Positioned(
            bottom: -75.h,
            left: 0,
            right: 0,
            child: Image.asset(
              'assets/images/Bottom_Aesthetic_Curve.png',
              fit: BoxFit.fitWidth,
              height: 280.h,
            ),
          ),
        ],
      ),
    );
  }
}
