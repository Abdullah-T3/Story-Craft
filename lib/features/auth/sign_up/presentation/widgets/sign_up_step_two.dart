import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:story_craft/core/theme/app_colors.dart';
import 'package:story_craft/features/auth/sign_up/domain/entities/sign_up_data.dart';
import 'package:story_craft/features/auth/sign_up/presentation/widgets/age_chip.dart';

class SignUpStepTwo extends StatelessWidget {
  const SignUpStepTwo({
    super.key,
    required this.signUpData,
    required this.fieldErrors,
    required this.agreed,
    required this.onChildNameChanged,
    required this.onAgeCategorySelected,
    required this.onAgreementToggled,
  });

  final SignUpData signUpData;
  final Map<String, String> fieldErrors;
  final bool agreed;
  final ValueChanged<String> onChildNameChanged;
  final ValueChanged<String> onAgeCategorySelected;
  final VoidCallback onAgreementToggled;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Center(
          child: Column(
            children: [
              Container(
                width: 84.w,
                height: 84.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.primaryContainer,
                ),
                child: Icon(
                  Icons.person_outline,
                  size: 40.w,
                  color: AppColors.primaryDark,
                ),
              ),
              SizedBox(height: 12.h),
              Text(
                'أخبرنا عن طفلك',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                'اختر اسم الطفل والفئة العمرية المناسبة',
                style: TextStyle(
                  fontSize: 12.sp,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 24.h),
        _SignUpField(
          label: 'اسم طفلك',
          hintText: 'ادخل اسم الطفل الصغير',
          value: signUpData.childName,
          onChanged: onChildNameChanged,
          errorText: fieldErrors['childName'],
          icon: Icons.child_care_outlined,
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
          children: [
            AgeChip(
              label: '4-6 سنوات',
              selected: signUpData.ageCategory == '4-6',
              onTap: () => onAgeCategorySelected('4-6'),
            ),
            AgeChip(
              label: '7-9 سنوات',
              selected: signUpData.ageCategory == '7-9',
              onTap: () => onAgeCategorySelected('7-9'),
            ),
            AgeChip(
              label: '10-12 سنوات',
              selected: signUpData.ageCategory == '10-12',
              onTap: () => onAgeCategorySelected('10-12'),
            ),
          ],
        ),
        if (fieldErrors['ageCategory'] != null) ...[
          SizedBox(height: 12.h),
          Text(
            fieldErrors['ageCategory']!,
            style: TextStyle(
              fontSize: 12.sp,
              color: Theme.of(context).colorScheme.error,
            ),
          ),
        ],
        SizedBox(height: 24.h),
        GestureDetector(
          onTap: onAgreementToggled,
          child: Row(
            children: [
              Container(
                width: 24.w,
                height: 24.w,
                decoration: BoxDecoration(
                  color: agreed ? AppColors.primaryDark : AppColors.surfaceContainerHigh,
                  borderRadius: BorderRadius.circular(8.r),
                  border: Border.all(color: AppColors.borderLighter),
                ),
                child: agreed
                    ? Icon(Icons.check, size: 18.w, color: Colors.white)
                    : null,
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Text(
                  'أوافق على شروط الخدمة وسياسة الخصوصية لحساب طفلي',
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _SignUpField extends StatelessWidget {
  const _SignUpField({
    required this.label,
    required this.hintText,
    required this.value,
    required this.onChanged,
    this.errorText,
    this.icon,
  });

  final String label;
  final String hintText;
  final String value;
  final ValueChanged<String> onChanged;
  final String? errorText;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        SizedBox(height: 8.h),
        TextField(
          onChanged: onChanged,
          decoration: InputDecoration(
            hintText: hintText,
            prefixIcon: icon != null ? Icon(icon) : null,
            errorText: errorText,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18.r),
              borderSide: BorderSide(color: AppColors.borderLighter),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18.r),
              borderSide: BorderSide(color: AppColors.borderLighter),
            ),
          ),
        ),
      ],
    );
  }
}
