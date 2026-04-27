import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:story_craft/core/theme/app_colors.dart';
import 'package:story_craft/features/home/create/domain/story_page_draft.dart';

class StoryPageCard extends StatelessWidget {
  const StoryPageCard({
    super.key,
    required this.page,
    required this.index,
    required this.onTap,
  });

  final StoryPageDraft page;
  final int index;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 18),
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [
              Color(0xFF587368),
              Color(0xFF7C9C82),
              Color(0xFFAAC7A1),
              Color(0xFFC1D6B0),
            ],
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 20,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 10.h),

            if (page.hasImage)
              ClipRRect(
                borderRadius: BorderRadius.circular(18),
                child: Container(
                  height: 180.h,
                  color: AppColors.primary.withOpacity(0.15),
                  child: const Center(
                    child: Icon(Icons.image, size: 54, color: Colors.white70),
                  ),
                ),
              )
            else
              Container(
                height: 160.h,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(18),
                  color: Colors.grey.shade100,
                ),
                child: const Center(
                  child: Icon(
                    Icons.add_a_photo_outlined,
                    size: 36,
                    color: Colors.grey,
                  ),
                ),
              ),

            SizedBox(height: 16.h),

            TextField(
              controller: page.controller,
              minLines: 4,
              maxLines: null,
              keyboardType: TextInputType.multiline,
              style: const TextStyle(
                fontSize: 22,
                height: 1.5,
                color: Colors.black87,
              ),
              decoration: InputDecoration(
                hintText: 'اكتب نص الصفحة هنا...',
                hintStyle: TextStyle(color: Colors.grey.shade700),
                filled: true,
                fillColor: Colors.transparent,

                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                errorBorder: InputBorder.none,
                disabledBorder: InputBorder.none,
              ),
              enableInteractiveSelection: true,
              selectionControls: null,
            ),
          ],
        ),
      ),
    );
  }
}
