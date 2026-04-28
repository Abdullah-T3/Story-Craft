import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:story_craft/core/theme/app_colors.dart';
import 'package:story_craft/features/stories/domain/entities/story_page.dart';

class ReaderPageView extends StatelessWidget {
  const ReaderPageView({super.key, required this.page});

  final StoryPage page;

  @override
  Widget build(BuildContext context) {
    final hasImage = page.imageUrl != null && page.imageUrl!.isNotEmpty;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
      child: Column(
        children: [
          Expanded(
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(28.r),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.06),
                    blurRadius: 14,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(28.r),
                child: SizedBox.expand(
                  child: hasImage
                      ? Image.network(
                          page.imageUrl!,
                          fit: BoxFit.cover,
                          loadingBuilder: (context, child, progress) {
                            if (progress == null) return child;
                            return const Center(
                              child: CircularProgressIndicator(
                                color: AppColors.primaryDark,
                              ),
                            );
                          },
                          errorBuilder: (context, error, stack) => Center(
                            child: Icon(
                              Icons.broken_image_outlined,
                              size: 64.sp,
                              color: AppColors.textTertiary,
                            ),
                          ),
                        )
                      : Center(
                          child: Text(
                            page.emoji ?? '📖',
                            style: TextStyle(fontSize: 96.sp),
                          ),
                        ),
                ),
              ),
            ),
          ),
          SizedBox(height: 20.h),
          Text(
            page.text,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 18.sp,
              height: 1.7,
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
