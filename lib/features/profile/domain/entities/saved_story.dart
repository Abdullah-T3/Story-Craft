import 'package:flutter/material.dart';

enum SavedStoryListKind { favorites, history }

class SavedStory {
  const SavedStory({
    required this.id,
    required this.title,
    required this.categoryLabel,
    required this.coverEmoji,
    required this.coverColor,
    required this.durationMinutes,
    required this.progress,
    required this.isFavorite,
    required this.lastOpenedAt,
  });

  final String id;
  final String title;
  final String categoryLabel;
  final String coverEmoji;
  final Color coverColor;
  final int durationMinutes;
  final double progress;
  final bool isFavorite;
  final DateTime lastOpenedAt;
}
