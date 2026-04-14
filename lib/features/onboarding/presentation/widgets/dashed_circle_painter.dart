import 'package:flutter/material.dart';
import 'package:story_craft/core/theme/app_colors.dart';

class DashedCirclePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.primaryMuted.withOpacity(0.3)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final radius = size.width / 2;

    double start = 0;

    while (start < 360) {
      canvas.drawArc(
        Rect.fromCircle(center: Offset(radius, radius), radius: radius),
        start * 3.14 / 180,
        6 * 3.14 / 180, 
        false,
        paint,
      );
      start += 12; 
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}