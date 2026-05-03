import 'package:flutter/material.dart';
import 'package:story_craft/core/theme/app_colors.dart';
import 'package:story_craft/features/profile/domain/entities/badge.dart';
import 'package:story_craft/features/profile/domain/entities/reader_stats.dart';

abstract final class BadgeRules {
  BadgeRules._();

  // Thresholds — kept here so they're documented and can be tuned in one place.
  static const int consistentStreak = 7;
  static const int creativeWriterCount = 5;
  static const int voraciousReaderCount = 10;
  static const int storyStarCount = 25;
  static const int littleWorldCount = 50;
  static const int monthHeroStreak = 30;

  static List<AchievementBadge> evaluate(ReaderStats stats) {
    return [
      _badge(
        kind: BadgeKind.consistent,
        icon: Icons.local_fire_department_rounded,
        color: AppColors.secondary,
        unlocked: stats.streakDays >= consistentStreak,
        metricValue: stats.streakDays,
      ),
      _badge(
        kind: BadgeKind.creativeWriter,
        icon: Icons.edit_rounded,
        color: AppColors.tertiary,
        unlocked: stats.storiesWritten >= creativeWriterCount,
        metricValue: stats.storiesWritten,
      ),
      _badge(
        kind: BadgeKind.voraciousReader,
        icon: Icons.menu_book_rounded,
        color: AppColors.primary,
        unlocked: stats.storiesRead >= voraciousReaderCount,
        metricValue: stats.storiesRead,
      ),
      _badge(
        kind: BadgeKind.storyStar,
        icon: Icons.star_rounded,
        color: AppColors.secondary,
        unlocked: stats.storiesRead >= storyStarCount,
        metricValue: stats.storiesRead,
      ),
      _badge(
        kind: BadgeKind.littleWorld,
        icon: Icons.school_rounded,
        color: AppColors.primaryDark,
        unlocked: stats.storiesRead >= littleWorldCount,
        metricValue: stats.storiesRead,
      ),
      _badge(
        kind: BadgeKind.monthHero,
        icon: Icons.emoji_events_rounded,
        color: AppColors.tertiary,
        unlocked: stats.streakDays >= monthHeroStreak,
        metricValue: stats.streakDays,
      ),
    ];
  }

  static int countUnlocked(ReaderStats stats) =>
      evaluate(stats).where((b) => b.unlocked).length;

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
