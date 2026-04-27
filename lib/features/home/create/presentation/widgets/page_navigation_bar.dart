import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:story_craft/core/theme/app_colors.dart';

class PageNavigationBar extends StatelessWidget {
  const PageNavigationBar({
    super.key,
    required this.currentPage,
    required this.pageCount,
    required this.onPrevious,
    required this.onNext,
  });

  final int currentPage;
  final int pageCount;
  final VoidCallback onPrevious;
  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    final bool isFirstPage = currentPage <= 1;
    final bool isLastPage = currentPage >= pageCount;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back_ios_new , color: AppColors.onPrimaryContainer, size: 30,),
              onPressed: isFirstPage ? null : onPrevious,
            ),

            Text(
              'الصفحة $currentPage من $pageCount',
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
      
            Row(
              children: List.generate(pageCount, (index) {
                final isActive = index == currentPage - 1;
      
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.symmetric(horizontal: 3),
                  width: isActive ? 14 : 6,
                  height: 6,
                  decoration: BoxDecoration(
                    color: isActive ? Colors.black : Colors.grey,
                    borderRadius: BorderRadius.circular(10),
                  ),
                );
              }),
            ),
      
            IconButton(
              icon: const Icon(Icons.arrow_forward_ios , color: AppColors.onPrimaryContainer, size: 30,),
              onPressed: isLastPage ? null : onNext,
            ),
          ],
        ),
      ),
    );
  }
}