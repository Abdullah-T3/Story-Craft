import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:story_craft/app/router/routs.dart';
import 'package:story_craft/core/localization/locale_keys.g.dart';
import 'package:story_craft/core/services/router/extantions.dart';
import 'package:story_craft/core/theme/app_colors.dart';
import 'package:story_craft/core/widgets/main_scaffold.dart';
import 'package:story_craft/features/profile/presentation/pages/account_page.dart';
import 'package:story_craft/features/profile/presentation/pages/achievements_page.dart';
import 'package:story_craft/features/profile/presentation/pages/saved_stories_page.dart';
import 'package:story_craft/features/stories/presentation/pages/library_page.dart';

class MainLayout extends StatefulWidget {
  const MainLayout({super.key, this.initialIndex = 0});

  final int initialIndex;

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  late int _currentIndex = widget.initialIndex;

  static const List<Widget> _screens = [
    LibraryPage(),
    SavedStoriesPage(),
    SizedBox.shrink(), // Create tab pushes a route instead of switching tab.
    AchievementsPage(),
    AccountPage(),
  ];

  void _onTap(int index) {
    if (index == 2) {
      context.pushNamed(AppRoutes.storySetupPath);
      return;
    }
    setState(() => _currentIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return MainScaffold(
      child: Scaffold(
        body: AnimatedSwitcher(
          duration: const Duration(milliseconds: 280),
          switchInCurve: Curves.easeOutCubic,
          switchOutCurve: Curves.easeInCubic,
          transitionBuilder: (child, animation) {
            final offset = Tween<Offset>(
              begin: const Offset(0.04, 0),
              end: Offset.zero,
            ).animate(animation);
            return FadeTransition(
              opacity: animation,
              child: SlideTransition(position: offset, child: child),
            );
          },
          child: KeyedSubtree(
            key: ValueKey<int>(_currentIndex),
            child: _screens[_currentIndex],
          ),
        ),
        bottomNavigationBar: _BottomNavBar(
          currentIndex: _currentIndex,
          onTap: _onTap,
        ),
      ),
    );
  }
}

class _BottomNavBar extends StatelessWidget {
  const _BottomNavBar({required this.currentIndex, required this.onTap});

  final int currentIndex;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    // Visual order in RTL bar (right → left): Library, Favorites, Achievements, Account
    return Container(
      margin: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(35.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.20),
            blurRadius: 15,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: SizedBox(
        height: 75.h,
        child: Row(
          children: [
            _NavItem(
              icon: Icons.person_outline,
              label: LocaleKeys.nav_account.tr(),
              index: 4,
              currentIndex: currentIndex,
              onTap: onTap,
            ),
            _NavItem(
              icon: Icons.emoji_events_outlined,
              label: LocaleKeys.nav_achievements.tr(),
              index: 3,
              currentIndex: currentIndex,
              onTap: onTap,
            ),
            _NavItem(
              icon: Icons.auto_awesome_rounded,
              label: LocaleKeys.nav_create.tr(),
              index: 2,
              currentIndex: currentIndex,
              onTap: onTap,
            ),
            _NavItem(
              icon: Icons.bookmark_border_rounded,
              label: LocaleKeys.nav_favorites.tr(),
              index: 1,
              currentIndex: currentIndex,
              onTap: onTap,
            ),
            _NavItem(
              icon: Icons.menu_book_rounded,
              label: LocaleKeys.nav_library.tr(),
              index: 0,
              currentIndex: currentIndex,
              onTap: onTap,
            ),
          ],
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.icon,
    required this.label,
    required this.index,
    required this.currentIndex,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final int index;
  final int currentIndex;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    final isSelected = currentIndex == index;
    const duration = Duration(milliseconds: 280);
    const curve = Curves.easeOutBack;

    return Expanded(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => onTap(index),
        child: SizedBox(
          height: 100.h,
          child: Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.center,
            children: [
              AnimatedPositioned(
                duration: duration,
                curve: curve,
                top: isSelected ? -25.h : 10.h,
                child: AnimatedScale(
                  duration: duration,
                  curve: curve,
                  scale: isSelected ? 1.0 : 0.85,
                  child: AnimatedContainer(
                    duration: duration,
                    curve: Curves.easeOut,
                    width: isSelected ? 60.r : 32.r,
                    height: isSelected ? 60.r : 32.r,
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColors.primaryDark
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(25.r),
                      border: Border.all(
                        color: isSelected ? Colors.white : Colors.transparent,
                        width: 3,
                      ),
                      boxShadow: isSelected
                          ? [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.35),
                                blurRadius: 10,
                                offset: const Offset(0, 5),
                              ),
                            ]
                          : const [],
                    ),
                    child: Icon(
                      icon,
                      color: isSelected
                          ? Colors.white
                          : AppColors.textSecondary,
                      size: isSelected ? 27.sp : 24.sp,
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 10.h,
                child: AnimatedDefaultTextStyle(
                  duration: duration,
                  curve: Curves.easeOut,
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w400,
                    color: isSelected
                        ? AppColors.textPrimary
                        : AppColors.textSecondary,
                  ),
                  child: Text(label),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
