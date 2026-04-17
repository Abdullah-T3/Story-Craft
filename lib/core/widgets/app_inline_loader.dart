import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppInlineLoader extends StatelessWidget {
  const AppInlineLoader({
    super.key,
    this.size = 20,
    this.color = Colors.white,
    this.strokeWidth = 2.5,
  });

  final double size;
  final Color color;
  final double strokeWidth;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size.w,
      height: size.w,
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(color),
        strokeWidth: strokeWidth,
      ),
    );
  }
}
