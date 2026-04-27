import 'package:flutter/material.dart';
import 'package:story_craft/features/stories/domain/entities/story_page.dart';

class Story {
  const Story({
    required this.id,
    required this.title,
    required this.summary,
    required this.categoryId,
    required this.ageRangeFrom,
    required this.ageRangeTo,
    required this.durationMinutes,
    required this.coverEmoji,
    required this.coverColor,
    required this.pages,
    required this.tags,
    this.coverImageUrl,
    this.isPremium = false,
    this.isFeatured = false,
  });

  final String id;
  final String title;
  final String summary;
  final String categoryId;
  final int ageRangeFrom;
  final int ageRangeTo;
  final int durationMinutes;
  final String coverEmoji;
  final Color coverColor;
  final String? coverImageUrl;
  final List<StoryPage> pages;
  final List<String> tags;
  final bool isPremium;
  final bool isFeatured;

  int get pageCount => pages.length;

  bool fitsAge(int from, int to) {
    return ageRangeFrom <= to && ageRangeTo >= from;
  }
}
