import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:story_craft/app/router/routs.dart';
import 'package:story_craft/core/theme/app_colors.dart';
import 'package:story_craft/core/widgets/app_text_field.dart';
import 'package:story_craft/core/widgets/buttons.dart';
import 'package:story_craft/features/auth/shared/validators/auth_validators.dart';
import 'package:story_craft/features/auth/sign_up/presentation/cubit/sign_up_cubit.dart';
import 'package:story_craft/features/auth/sign_up/presentation/cubit/sign_up_state.dart';
import 'package:story_craft/features/auth/sign_up/presentation/widgets/age_chip.dart';
import 'package:story_craft/features/auth/sign_up/presentation/widgets/terms_agreement_widget.dart';

class SignUpStepTwo extends StatelessWidget {
  const SignUpStepTwo({
    super.key,
    required this.childNameController,
    required this.agreed,
    required this.onAgeCategorySelected,
    required this.onAgreementToggled,
    required this.selectedAge,
    required this.onSubmit,
    required this.profileImage,
    required this.onPickImage,
  });

  final TextEditingController childNameController;
  final bool agreed;
  final String selectedAge;
  final ValueChanged<String> onAgeCategorySelected;
  final VoidCallback onAgreementToggled;
  final VoidCallback onSubmit;
  final File? profileImage;
  final VoidCallback onPickImage;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: Column(
              children: [
                GestureDetector(
                  onTap: onPickImage,
                  child: Stack(
                    children: [
                      Container(
                        width: 84.w,
                        height: 84.w,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.primaryContainer,
                          image: profileImage != null
                              ? DecorationImage(
                                  image: FileImage(profileImage!),
                                  fit: BoxFit.cover,
                                )
                              : null,
                        ),
                        child: profileImage == null
                            ? Icon(
                                Icons.person_outline,
                                size: 40.w,
                                color: AppColors.primaryDark,
                              )
                            : null,
                      ),
                      Positioned(
                        right: 0,
                        bottom: 0,
                        child: Container(
                          width: 28.w,
                          height: 28.w,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.primaryDark,
                            border: Border.all(color: Colors.white, width: 2),
                          ),
                          child: Icon(
                            Icons.camera_alt_outlined,
                            size: 16.w,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 12.h),
                Text(
                  'أخبرنا عن طفلك',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  'لنخصص تجربة القراءة والمغامرة المثالية',
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w400
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 24.h),

          AppTextField(
            controller: childNameController,
            label: 'اسم طفلك',
            hint: 'ادخل اسم الطفل',
            trailingIcon: const Icon(Icons.child_care_outlined),
            backgroundColor: AppColors.secondaryContainer.withValues(
              alpha: 0.2,
            ),
            textInputAction: TextInputAction.next,
            validator: AuthValidators.childName,
          ),

          SizedBox(height: 24.h),

          Text(
            'الفئة العمرية',
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),

          SizedBox(height: 12.h),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            spacing: 3.w,
            children: [
              AgeChip(
                label: '4-6',
                selected: selectedAge == '4-6',
                onTap: () => onAgeCategorySelected('4-6'),
              ),
              AgeChip(
                label: '7-9',
                selected: selectedAge == '7-9',
                onTap: () => onAgeCategorySelected('7-9'),
              ),
              AgeChip(
                label: '10-12',
                selected: selectedAge == '10-12',
                onTap: () => onAgeCategorySelected('10-12'),
              ),
            ],
          ),

          SizedBox(height: 30.h),
          TermsCheckboxWidget(agreed: agreed, onToggle: onAgreementToggled,),
          SizedBox(height: 90.h),

          BlocBuilder<SignUpCubit, SignUpState>(
            buildWhen: (prev, curr) =>
                prev is SignUpLoading || curr is SignUpLoading,
            builder: (context, state) {
              return Buttons(
                label: 'إنشاء الحساب',
                onPressed: onSubmit,
                isLoading: state is SignUpLoading,
                style: AppButtonStyle.filled,
                suffixIcon: const Icon(Icons.arrow_forward, color: Colors.white),
                backgroundColor: AppColors.primaryDark,
              );
            },
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
