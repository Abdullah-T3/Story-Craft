import 'package:flutter/material.dart';
import 'package:story_craft/core/theme/app_colors.dart';
import 'package:story_craft/features/profile/domain/entities/badge.dart';
import 'package:story_craft/features/profile/domain/entities/reader_stats.dart';

abstract final class BadgeRules {
  BadgeRules._();

  static List<AchievementBadge> evaluate(ReaderStats stats) {
    return [
      _badge(
        kind: BadgeKind.consistent,
        icon: Icons.local_fire_department_rounded,
        color: AppColors.secondary,
        unlocked: stats.streakDays >= 7,
        metricValue: stats.streakDays,
      ),
      _badge(
        kind: BadgeKind.creativeWriter,
        icon: Icons.edit_rounded,
        color: AppColors.tertiary,
        unlocked: stats.storiesWritten >= 5,
        metricValue: stats.storiesWritten,
      ),
      _badge(
        kind: BadgeKind.voraciousReader,
        icon: Icons.menu_book_rounded,
        color: AppColors.primary,
        unlocked: stats.storiesRead >= 10,
        metricValue: stats.storiesRead,
      ),
      _badge(
        kind: BadgeKind.littleWorld,
        icon: Icons.school_rounded,
        color: AppColors.primaryDark,
        unlocked: stats.storiesRead >= 50,
        metricValue: 50,
      ),
      _badge(
        kind: BadgeKind.monthHero,
        icon: Icons.emoji_events_rounded,
        color: AppColors.tertiary,
        unlocked: stats.streakDays >= 30,
        metricValue: 1,
      ),
      _badge(
        kind: BadgeKind.storyStar,
        icon: Icons.star_rounded,
        color: AppColors.secondary,
        unlocked: stats.storiesRead >= 25,
        metricValue: 25,
      ),
    ];
  }

  static AchievementBadge _badge({
    required BadgeKind kind,
    required IconData icon,
    required Color color,
    required bool unlocked,
    required int metricValue,
  }) {
    return AchievementBadge(
      kind: kind,
      icon: icon,
      color: unlocked ? color : AppColors.textTertiary,
      unlocked: unlocked,
      metricValue: metricValue,
    );
  }
}
