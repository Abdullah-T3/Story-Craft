import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:story_craft/core/theme/app_colors.dart';

class LoginHeader extends StatelessWidget {
  const LoginHeader({required this.onBackPressed, super.key});

  final VoidCallback onBackPressed;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // ── Curved background ────────────────────────────────────────────────
        ClipPath(
          clipper: _SoftArcClipper(),
          child: Container(
            width: double.infinity,
            color: AppColors.headerBackground,
            // Extra bottom padding creates the "dip zone" the arc cuts through
            padding: EdgeInsets.only(top: 32.h, bottom: 52.h),
            child: Column(
              children: [
                Container(
                  width: 72.w,
                  height: 72.w,
                  decoration: const BoxDecoration(
                    color: AppColors.primaryMuted,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.auto_stories_rounded,
                    color: Colors.white,
                    size: 36.sp,
                  ),
                ),
                SizedBox(height: 16.h),
                Text(
                  'مرحباً مجدداً!',
                  style: TextStyle(
                    fontSize: 26.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                SizedBox(height: 6.h),
                Text(
                  'قصصك بانتظارك، هيا لنكمل المغامرة',
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ),

        // ── Back button ──────────────────────────────────────────────────────
        Positioned(
          top: 8.h,
          right: 16.w,
          child: IconButton(
            onPressed: onBackPressed,
            style: IconButton.styleFrom(
              backgroundColor: AppColors.primaryDark,
              foregroundColor: Colors.white,
            ),
            icon: Icon(Icons.arrow_forward, size: 22.sp),
          ),
        ),
      ],
    );
  }
}

/// Draws a wide, soft downward arc at the bottom edge.
///
/// Geometry (side view):
///
///   left edge ──╮                 ╭── right edge
///     y = H-D   │                 │   y = H-D
///               │                 │
///               ╰────── ─── ─────╯
///                 centre  y = H
///                 (deepest point)
///
/// Both side endpoints sit [D] pixels above the container bottom.
/// The control point is pushed [D] pixels *below* the container so that
/// the actual Bézier arc reaches exactly y = H at the centre.
/// (Quadratic Bézier at t=0.5 : y = ¼·(H-D) + ½·(H+D) + ¼·(H-D) = H ✓)
class _SoftArcClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    // D controls how deep the centre dips below the side edges.
    // 10 % of screen width gives a wide, gentle wave on every screen size.
    final d = size.width * 0.10;

    return Path()
      ..lineTo(0, size.height - d) // bottom-left (higher)
      ..quadraticBezierTo(
        size.width / 2,
        size.height + d, // control pt (below widget — correct!)
        size.width,
        size.height - d, // bottom-right (same height as left)
      )
      ..lineTo(size.width, 0) // top-right
      ..close();
  }

  @override
  bool shouldReclip(_SoftArcClipper oldClipper) => false;
}
