import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:story_craft/features/profile/domain/entities/parental_settings.dart';
import 'package:story_craft/features/profile/domain/entities/reader_profile.dart';
import 'package:story_craft/features/profile/domain/entities/saved_story.dart';

DateTime _parseTs(dynamic value, {DateTime? fallback}) {
  if (value is Timestamp) return value.toDate();
  if (value is DateTime) return value;
  return fallback ?? DateTime.now();
}

ReaderProfile readerProfileFromMap(String uid, Map<String, dynamic> data) {
  return ReaderProfile(
    uid: uid,
    displayName: (data['childName'] ?? data['name'] ?? '') as String,
    avatarEmoji: (data['avatarEmoji'] ?? '🐻') as String,
    photoUrl: (data['photoUrl'] ?? '') as String,
    levelKey: (data['levelKey'] ?? 'levelBeginner') as String,
    joinedAt: _parseTs(data['createdAt']),
    badgesCount: (data['badgesCount'] ?? 0) as int,
    storiesWritten: (data['storiesWritten'] ?? 0) as int,
    storiesPrinted: (data['storiesPrinted'] ?? 0) as int,
  );
}

SavedStory savedStoryFromMap(Map<String, dynamic> data) {
  return SavedStory(
    id: data['id'] as String,
    title: (data['title'] ?? '') as String,
    categoryLabel: (data['categoryLabel'] ?? '') as String,
    coverEmoji: (data['coverEmoji'] ?? '📖') as String,
    coverColor: Color((data['coverColor'] ?? 0xFFD6F0E8) as int),
    coverImageUrl: data['coverImageUrl'] as String?,
    durationMinutes: (data['durationMinutes'] ?? 0) as int,
    progress: ((data['progress'] ?? 0) as num).toDouble(),
    isFavorite: (data['isFavorite'] ?? false) as bool,
    lastOpenedAt: _parseTs(data['lastOpenedAt']),
  );
}

ParentalSettings parentalFromMap(Map<String, dynamic> data) {
  return ParentalSettings(
    ageRangeFrom: (data['ageRangeFrom'] ?? 7) as int,
    ageRangeTo: (data['ageRangeTo'] ?? 9) as int,
    contentFilterEnabled: (data['contentFilterEnabled'] ?? true) as bool,
    dailyQuotaMinutes: (data['dailyQuotaMinutes'] ?? 60) as int,
    usedTodayMinutes: (data['usedTodayMinutes'] ?? 0) as int,
    weeklyScheduleSubtitle: (data['weeklyScheduleSubtitle'] ?? '') as String,
  );
}

Map<String, dynamic> parentalToMap(ParentalSettings s) {
  return {
    'ageRangeFrom': s.ageRangeFrom,
    'ageRangeTo': s.ageRangeTo,
    'contentFilterEnabled': s.contentFilterEnabled,
    'dailyQuotaMinutes': s.dailyQuotaMinutes,
    'usedTodayMinutes': s.usedTodayMinutes,
    'weeklyScheduleSubtitle': s.weeklyScheduleSubtitle,
  };
}
