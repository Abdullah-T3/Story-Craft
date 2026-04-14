import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:story_craft/core/theme/app_colors.dart';
import 'package:story_craft/core/constants/assets.dart';
import 'package:story_craft/features/onboarding/presentation/widgets/dashed_circle_painter.dart';

class MascotSection extends StatelessWidget {
  const MascotSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [

        CustomPaint(
          painter: DashedCirclePainter(),
          child: SizedBox(width: 192.w, height: 192.w),
        ),

        Container(
          width: 185.w,
          height: 185.w,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: AppColors.primaryMuted.withOpacity(0.4),
                blurRadius: 16,
                offset: const Offset(0, 8),
              ),
            ],
          ),
        ),

        ClipOval(
          child: Container(
            width: 175.w,
            height: 175.w,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.onPrimaryContainer,
            ),
            child: Padding(
              padding: EdgeInsets.all(20.w),
              child: Image.asset(Assets.mascot, fit: BoxFit.contain),
            ),
          ),
        ),
      ],
    );
  }
}
