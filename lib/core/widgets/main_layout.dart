import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:story_craft/core/theme/app_colors.dart';
import 'package:story_craft/core/widgets/main_scaffold.dart';
import 'package:story_craft/features/home/create/presentation/pages/story_pages_editor_screen.dart';
import 'package:story_craft/features/home/create/presentation/pages/story_setup_screen.dart';
import 'package:story_craft/features/home/home/presentation/home_page.dart';

class MainLayout extends StatefulWidget {
  const MainLayout({super.key});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    HomePage(),
    StorySetupPage(),
    StoryPagesEditorScreen(), 
    Center(child: Text("Profile")),
  ];

  void _onTap(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  Widget _buildNavItem(IconData icon, String label, int index) {
    final isSelected = _currentIndex == index;

    return Expanded(
      child: GestureDetector(
        onTap: () => _onTap(index),
        child: SizedBox(
          height: 90.h,
          child: Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.center,
            children: [
              if (isSelected)
                Positioned(
                  top: -25.h,
                  child: Container(
                    width: 55.w,
                    height: 55.h,
                    decoration: BoxDecoration(
                      color: AppColors.primaryDark,
                      borderRadius: BorderRadius.circular(25),
                      border: Border.all(color: Colors.white, width: 3),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.35),
                          blurRadius: 10.r,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Icon(
                      icon,
                      color: Colors.white,
                      size: 27.sp,
                    ),
                  ),
                ),

              Positioned(
                bottom: 10,
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: isSelected
                        ? FontWeight.w700
                        : FontWeight.w400,
                    color: isSelected
                        ? AppColors.textPrimary
                        : AppColors.textSecondary,
                  ),
                ),
              ),

              if (!isSelected)
                Positioned(
                  top: 10.h,
                  child: Icon(
                    icon,
                    color: AppColors.textSecondary,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MainScaffold(
      child: Scaffold(
      
        body: IndexedStack(
          index: _currentIndex,
          children: _screens,
        ),
      
        bottomNavigationBar: Container(
          margin: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(35),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.20),
                blurRadius: 15.r,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: SizedBox(
            height: 75.h,
            child: Row(
              children: [
                _buildNavItem(Icons.person_outline, "حسابي", 2),
                _buildNavItem(Icons.auto_awesome_outlined, "إنشاء", 1),
                _buildNavItem(Icons.home_outlined, "الرئيسية", 0),
              ],
            ),
          ),
        ),
      ),
    );
  }
}