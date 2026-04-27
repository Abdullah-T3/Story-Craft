import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:story_craft/features/stories/domain/entities/reading_progress.dart';
import 'package:story_craft/features/stories/domain/entities/story.dart';
import 'package:story_craft/features/stories/domain/entities/story_page.dart';

DateTime _parseTs(dynamic value, {DateTime? fallback}) {
  if (value is Timestamp) return value.toDate();
  if (value is DateTime) return value;
  return fallback ?? DateTime.now();
}

Story storyFromMap(Map<String, dynamic> data) {
  final pagesRaw = (data['pages'] as List?) ?? const [];
  final pages = <StoryPage>[
    for (var i = 0; i < pagesRaw.length; i++)
      _pageFromMap(i, pagesRaw[i] as Map<String, dynamic>),
  ];
  return Story(
    id: data['id'] as String,
    title: (data['title'] ?? '') as String,
    summary: (data['summary'] ?? '') as String,
    categoryId: (data['categoryId'] ?? 'all') as String,
    ageRangeFrom: (data['ageRangeFrom'] ?? 4) as int,
    ageRangeTo: (data['ageRangeTo'] ?? 12) as int,
    durationMinutes: (data['durationMinutes'] ?? 5) as int,
    coverEmoji: (data['coverEmoji'] ?? '📖') as String,
    coverColor: Color((data['coverColor'] ?? 0xFFD6F0E8) as int),
    coverImageUrl: data['coverImageUrl'] as String?,
    pages: pages,
    tags: ((data['tags'] as List?) ?? const []).cast<String>(),
    isPremium: (data['isPremium'] ?? false) as bool,
    isFeatured: (data['isFeatured'] ?? false) as bool,
  );
}

StoryPage _pageFromMap(int index, Map<String, dynamic> data) {
  return StoryPage(
    index: (data['index'] ?? index) as int,
    text: (data['text'] ?? '') as String,
    imageUrl: data['imageUrl'] as String?,
    emoji: data['emoji'] as String?,
  );
}

ReadingProgress progressFromMap(Map<String, dynamic> data) {
  return ReadingProgress(
    storyId: data['storyId'] as String,
    lastPageIndex: (data['lastPageIndex'] ?? 0) as int,
    progress: ((data['progress'] ?? 0) as num).toDouble(),
    lastOpenedAt: _parseTs(data['lastOpenedAt']),
    completed: (data['completed'] ?? false) as bool,
  );
}
