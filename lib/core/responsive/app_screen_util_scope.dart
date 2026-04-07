import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:story_craft/core/responsive/app_design_size.dart';

/// Initializes [ScreenUtil] for the subtree that contains [MaterialApp].
///
/// Wraps [ScreenUtilInit] with project [AppDesignSize.canvas].
class AppScreenUtilScope extends StatelessWidget {
  const AppScreenUtilScope({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: AppDesignSize.canvas,
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) => child!,
      child: child,
    );
  }
}
