import 'package:flutter/material.dart';
import 'package:story_craft/core/theme/app_colors.dart';

class StoryCategoryChips extends StatelessWidget {
  const StoryCategoryChips({
    required this.categories,
    required this.selectedIndex,
    required this.onSelected,
    super.key,
  });

  final List<String> categories;
  final int selectedIndex;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: List.generate(
        categories.length,
        (index) {
          final selected = selectedIndex == index;

          return AnimatedScale(
            scale: selected ? 1.05 : 1,
            duration: const Duration(milliseconds: 180),
            curve: Curves.easeOut,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: selected
                        ? AppColors.primary.withOpacity(0.3)
                        : Colors.black.withOpacity(0.08),
                    blurRadius: selected ? 12 : 5,
                    offset: Offset(0, selected ? 4 : 2),
                  ),
                ],
              ),
              child: ChoiceChip(
                label: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(categories[index]),
                  ],
                ),
                selected: selected,
                onSelected: (_) => onSelected(index),
                selectedColor: AppColors.primary.withOpacity(0.2),
                backgroundColor: AppColors.neutralSurface,
                labelStyle: TextStyle(
                  color: selected
                      ? AppColors.primary
                      : AppColors.textPrimary,
                  fontWeight:
                      selected ? FontWeight.w700 : FontWeight.w500,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                  side: BorderSide(
                    color: selected
                        ? AppColors.primary
                        : Colors.transparent,
                    width: 1.2,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}