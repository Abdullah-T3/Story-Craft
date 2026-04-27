import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:story_craft/app/router/routs.dart';
import 'package:story_craft/core/services/router/extantions.dart';
import 'package:story_craft/core/theme/app_colors.dart';
import 'package:story_craft/core/widgets/app_text_field.dart';
import 'package:story_craft/core/widgets/buttons.dart';
import 'package:story_craft/features/home/create/presentation/widgets/gradient_circle.dart';
import 'package:story_craft/features/home/create/presentation/widgets/story_category_chips.dart';
import 'package:story_craft/features/home/create/presentation/widgets/soft_card.dart';
import 'package:story_craft/features/home/create/presentation/widgets/section_title.dart';

class StorySetupPage extends StatefulWidget {
  const StorySetupPage({super.key});

  @override
  State<StorySetupPage> createState() => _StorySetupPageState();
}

class _StorySetupPageState extends State<StorySetupPage> {
  final TextEditingController _titleController = TextEditingController();
  int _selectedCategory = 0;
  int _selectedColor = 0;
  bool _hasCover = false;

  final List<String> _categories = [
    'مغامرة',
    'رومانسية',
    'خيالية',
    'خيال علمي',
  ];

  final List<Gradient> _colorOptions = [
    const LinearGradient(colors: [Color(0xFF8BE4B6), Color(0xFF4F6B5F)]),
    const LinearGradient(colors: [Color(0xFF8CC4FF), Color(0xFFB39DFF)]),
    const LinearGradient(colors: [Color(0xFFFFB3B3), Color(0xFFFFD6A5)]),
    const LinearGradient(colors: [Color(0xFFE0F7FA), Color(0xFF00838F)]),
  ];

  @override
  Widget build(BuildContext context) {
    final selectedGradient = _colorOptions[_selectedColor];

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'تجهيز القصة الجديدة',
          style: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.w800,
            color: AppColors.onPrimaryContainer,
          ),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
          children: [
            const SectionTitle('الغلاف'),
            SizedBox(height: 14.h),
            GestureDetector(
              onTap: () => setState(() => _hasCover = !_hasCover),
              child: SoftCard(
                padding: EdgeInsets.all(0),
                margin: EdgeInsets.only(bottom: 22.h),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    height: 220.h,
                    decoration: BoxDecoration(gradient: selectedGradient),
                    child: _hasCover
                        ? Container(
                            alignment: Alignment.center,
                            child: Icon(
                              Icons.check_circle_outline,
                              size: 60.sp,
                              color: Colors.white,
                            ),
                          )
                        : Container(
                            alignment: Alignment.center,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.photo_camera_outlined,
                                  size: 42.sp,
                                  color: Colors.white,
                                ),
                                SizedBox(height: 10.h),
                                Text(
                                  'اضغط لاختيار الغلاف',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                  ),
                ),
              ),
            ),
            const SectionTitle('عنوان القصة'),
            SizedBox(height: 12.h),
            AppTextField(
              controller: _titleController,
              hint: 'أدخل عنوانًا جذابًا',
              backgroundColor: AppColors.neutralSurface,
              maxLines: 1,
            ),
            SizedBox(height: 24.h),
            const SectionTitle('الفئة'),
            SizedBox(height: 12.h),
            StoryCategoryChips(
              categories: _categories,
              selectedIndex: _selectedCategory,
              onSelected: (index) => setState(() => _selectedCategory = index),
            ),
            SizedBox(height: 24.h),
            const SectionTitle('لون المزاج'),
            SizedBox(height: 12.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(
                _colorOptions.length,
                (index) => GradientCircle(
                  gradient: _colorOptions[index],
                  selected: index == _selectedColor,
                  onTap: () => setState(() => _selectedColor = index),
                ),
              ),
            ),
            SizedBox(height: 24.h),
            const SectionTitle('معاينة'),
            SizedBox(height: 12.h),
            Container(
              height: 140.h,
              decoration: BoxDecoration(
                gradient: selectedGradient,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 24,
                    offset: const Offset(0, 12),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(18),
              child: ValueListenableBuilder<TextEditingValue>(
                valueListenable: _titleController,
                builder: (context, value, child) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        value.text.isEmpty ? 'معاينة قصتك' : value.text,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _categories[_selectedCategory],
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
            const SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 17.0),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.30),
                      blurRadius: 20,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Buttons(
                  label: 'المتابعة إلى الصفحات',
                  style: AppButtonStyle.filled,
                  backgroundColor: AppColors.primaryDark,
                  borderColor: AppColors.primaryDark,
                  textColor: Colors.white,
                  onPressed: () =>
                      context.pushNamed(AppRoutes.storyPagesEditorPath),
                ),
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
