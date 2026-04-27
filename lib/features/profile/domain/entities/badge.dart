import 'package:flutter/material.dart';

enum BadgeKind {
  consistent,
  creativeWriter,
  voraciousReader,
  littleWorld,
  monthHero,
  storyStar,
}

class AchievementBadge {
  const AchievementBadge({
    required this.kind,
    required this.icon,
    required this.color,
    required this.unlocked,
    this.metricValue = 0,
  });

  final BadgeKind kind;
  final IconData icon;
  final Color color;
  final bool unlocked;
  final int metricValue;
}
