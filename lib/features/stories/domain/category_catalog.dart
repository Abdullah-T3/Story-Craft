import 'package:flutter/material.dart';
import 'package:story_craft/core/localization/locale_keys.g.dart';
import 'package:story_craft/core/theme/app_colors.dart';
import 'package:story_craft/features/stories/domain/entities/story_category.dart';

abstract final class CategoryCatalog {
  CategoryCatalog._();

  static const String allId = 'all';

  static const List<StoryCategory> all = [
    StoryCategory(
      id: allId,
      labelKey: LocaleKeys.categories_all,
      icon: Icons.apps_rounded,
      color: AppColors.primaryDark,
    ),
    StoryCategory(
      id: 'adventures',
      labelKey: LocaleKeys.categories_adventures,
      icon: Icons.terrain_rounded,
      color: AppColors.primary,
    ),
    StoryCategory(
      id: 'fantasy',
      labelKey: LocaleKeys.categories_fantasy,
      icon: Icons.auto_awesome_rounded,
      color: AppColors.tertiary,
    ),
    StoryCategory(
      id: 'animals',
      labelKey: LocaleKeys.categories_animals,
      icon: Icons.pets_rounded,
      color: AppColors.secondary,
    ),
    StoryCategory(
      id: 'educational',
      labelKey: LocaleKeys.categories_educational,
      icon: Icons.school_rounded,
      color: AppColors.primaryMuted,
    ),
    StoryCategory(
      id: 'newReleases',
      labelKey: LocaleKeys.categories_newReleases,
      icon: Icons.fiber_new_rounded,
      color: AppColors.secondaryMuted,
    ),
  ];

  static StoryCategory byId(String id) =>
      all.firstWhere((c) => c.id == id, orElse: () => all.first);
}
