import 'package:flutter/material.dart';
import 'package:story_craft/core/theme/app_colors.dart';

class SignUpStepIndicator extends StatelessWidget {
  const SignUpStepIndicator({
    super.key,
    required this.currentStep,
    this.length = 2,
  });

  final int currentStep;
  final int length;

  @override
  Widget build(BuildContext context) {
    return Row(
      textDirection: TextDirection.rtl,
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        length,
        (index) => AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.symmetric(horizontal: 5),
          height: 8,
          width: 180,
          decoration: BoxDecoration(
            color: currentStep == index
                ? AppColors.onPrimaryContainer
                : AppColors.borderLighter,
            borderRadius: BorderRadius.circular(25),
          ),
        ),
      ),
    );
  }
}