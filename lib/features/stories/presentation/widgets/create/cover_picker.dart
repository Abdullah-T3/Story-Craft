import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:story_craft/core/localization/locale_keys.g.dart';
import 'package:story_craft/core/theme/app_colors.dart';

class CoverPicker extends StatelessWidget {
  const CoverPicker({
    super.key,
    required this.imageUrl,
    required this.isUploading,
    required this.fallbackGradient,
    required this.onPick,
    required this.onRemove,
  });

  final String? imageUrl;
  final bool isUploading;
  final Gradient fallbackGradient;
  final VoidCallback onPick;
  final VoidCallback onRemove;

  bool get _hasImage => imageUrl != null && imageUrl!.isNotEmpty;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isUploading ? null : onPick,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20.r),
        child: Stack(
          children: [
            // Background — picked image OR mood gradient placeholder.
            SizedBox(
              height: 200.h,
              width: double.infinity,
              child: _hasImage
                  ? Image.network(imageUrl!, fit: BoxFit.cover)
                  : DecoratedBox(
                      decoration: BoxDecoration(gradient: fallbackGradient),
                    ),
            ),
            // Hint overlay when no image is selected.
            if (!_hasImage && !isUploading)
              Positioned.fill(
                child: Container(
                  alignment: Alignment.center,
                  color: Colors.black.withOpacity(0.05),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.add_photo_alternate_outlined,
                        size: 44.sp,
                        color: Colors.white,
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        LocaleKeys.create_coverHint.tr(),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            // Edit / remove buttons when image present.
            if (_hasImage && !isUploading)
              Positioned(
                top: 8.h,
                left: 8.w,
                child: Row(
                  children: [
                    _ActionPill(
                      icon: Icons.delete_outline_rounded,
                      onTap: onRemove,
                    ),
                    SizedBox(width: 6.w),
                    _ActionPill(
                      icon: Icons.edit_rounded,
                      onTap: onPick,
                      tooltip: LocaleKeys.create_changeCover.tr(),
                    ),
                  ],
                ),
              ),
            // Upload spinner overlay.
            if (isUploading)
              Positioned.fill(
                child: Container(
                  color: Colors.black.withOpacity(0.4),
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const CircularProgressIndicator(color: Colors.white),
                      SizedBox(height: 12.h),
                      Text(
                        LocaleKeys.create_uploading.tr(),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _ActionPill extends StatelessWidget {
  const _ActionPill({required this.icon, required this.onTap, this.tooltip});

  final IconData icon;
  final VoidCallback onTap;
  final String? tooltip;

  @override
  Widget build(BuildContext context) {
    final btn = Material(
      color: Colors.white,
      shape: const CircleBorder(),
      elevation: 2,
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.all(6.r),
          child: Icon(icon, size: 18.sp, color: AppColors.textPrimary),
        ),
      ),
    );
    if (tooltip != null) return Tooltip(message: tooltip!, child: btn);
    return btn;
  }
}
