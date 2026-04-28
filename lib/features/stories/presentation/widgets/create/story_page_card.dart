import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:story_craft/core/localization/locale_keys.g.dart';
import 'package:story_craft/core/theme/app_colors.dart';

class StoryPageCard extends StatelessWidget {
  const StoryPageCard({
    super.key,
    required this.text,
    required this.imageUrl,
    required this.coverColor,
    required this.coverEmoji,
    required this.isUploading,
    required this.onPickImage,
    required this.onRemoveImage,
    required this.onChanged,
    required this.onRemovePage,
    required this.canRemovePage,
  });

  final String text;
  final String? imageUrl;
  final Color coverColor;
  final String coverEmoji;
  final bool isUploading;
  final VoidCallback onPickImage;
  final VoidCallback onRemoveImage;
  final ValueChanged<String> onChanged;
  final VoidCallback onRemovePage;
  final bool canRemovePage;

  bool get _hasImage => imageUrl != null && imageUrl!.isNotEmpty;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          GestureDetector(
            onTap: isUploading ? null : onPickImage,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(18.r),
              child: SizedBox(
                height: 180.h,
                width: double.infinity,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    if (_hasImage)
                      Image.network(imageUrl!, fit: BoxFit.cover)
                    else
                      DecoratedBox(
                        decoration: BoxDecoration(color: coverColor),
                        child: Center(
                          child: Text(
                            coverEmoji,
                            style: TextStyle(fontSize: 96.sp),
                          ),
                        ),
                      ),
                    if (!_hasImage && !isUploading)
                      Positioned.fill(
                        child: Container(
                          color: Colors.black.withOpacity(0.05),
                          alignment: Alignment.center,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.add_photo_alternate_outlined,
                                size: 40.sp,
                                color: Colors.white,
                              ),
                              SizedBox(height: 6.h),
                              Text(
                                LocaleKeys.create_addPageImage.tr(),
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 13.sp,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    if (_hasImage && !isUploading)
                      Positioned(
                        top: 6.h,
                        left: 6.w,
                        child: Row(
                          children: [
                            _RoundButton(
                              icon: Icons.delete_outline_rounded,
                              onTap: onRemoveImage,
                            ),
                            SizedBox(width: 6.w),
                            _RoundButton(
                              icon: Icons.edit_rounded,
                              onTap: onPickImage,
                            ),
                          ],
                        ),
                      ),
                    if (isUploading)
                      Positioned.fill(
                        child: Container(
                          color: Colors.black.withOpacity(0.4),
                          alignment: Alignment.center,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const CircularProgressIndicator(color: Colors.white),
                              SizedBox(height: 10.h),
                              Text(
                                LocaleKeys.create_uploading.tr(),
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12.sp,
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
            ),
          ),
          SizedBox(height: 14.h),
          TextFormField(
            initialValue: text,
            minLines: 4,
            maxLines: null,
            keyboardType: TextInputType.multiline,
            textAlign: TextAlign.right,
            onChanged: onChanged,
            style: TextStyle(
              fontSize: 16.sp,
              height: 1.7,
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w600,
            ),
            decoration: InputDecoration(
              hintText: LocaleKeys.create_pageHint.tr(),
              hintStyle:
                  TextStyle(color: AppColors.textHint, fontSize: 15.sp),
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              contentPadding: EdgeInsets.zero,
            ),
          ),
          if (canRemovePage)
            Align(
              alignment: Alignment.centerLeft,
              child: TextButton.icon(
                onPressed: onRemovePage,
                icon: const Icon(
                  Icons.delete_outline_rounded,
                  color: AppColors.secondary,
                ),
                label: Text(
                  LocaleKeys.create_removePage.tr(),
                  style: TextStyle(
                    color: AppColors.secondary,
                    fontSize: 12.sp,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _RoundButton extends StatelessWidget {
  const _RoundButton({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
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
  }
}
