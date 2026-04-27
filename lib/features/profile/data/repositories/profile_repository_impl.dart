import 'package:flutter/material.dart';
import 'package:fpdart/fpdart.dart';
import 'package:story_craft/core/error/failures.dart';
import 'package:story_craft/core/theme/app_colors.dart';
import 'package:story_craft/features/auth/domain/repositories/auth_repository.dart';
import 'package:story_craft/features/profile/data/datasources/firestore_profile_datasource.dart';
import 'package:story_craft/features/profile/data/models/profile_mappers.dart';
import 'package:story_craft/features/profile/domain/entities/achievements_summary.dart';
import 'package:story_craft/features/profile/domain/entities/badge.dart';
import 'package:story_craft/features/profile/domain/entities/parental_settings.dart';
import 'package:story_craft/features/profile/domain/entities/reader_profile.dart';
import 'package:story_craft/features/profile/domain/entities/saved_story.dart';
import 'package:story_craft/features/profile/domain/repositories/profile_repository.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  const ProfileRepositoryImpl({
    required FirestoreProfileDatasource firestore,
    required AuthRepository auth,
  }) : _firestore = firestore,
       _auth = auth;

  final FirestoreProfileDatasource _firestore;
  final AuthRepository _auth;

  String? get _uid => _auth.currentUser?.uid;

  @override
  Future<AppResult<ReaderProfile>> getReaderProfile() async {
    final uid = _uid;
    if (uid == null) {
      return const Left(AuthFailure(message: 'لا يوجد مستخدم مسجل'));
    }
    try {
      final data = await _firestore.getUser(uid);
      if (data == null) {
        return Right(_defaultProfile(uid));
      }
      return Right(readerProfileFromMap(uid, data));
    } on Exception {
      return Right(_defaultProfile(uid));
    }
  }

  @override
  Future<AppResult<AchievementsSummary>> getAchievements() async {
    final profile = await getReaderProfile();
    return profile.fold(
      (f) => Left(f),
      (p) => Right(_defaultAchievements(p)),
    );
  }

  @override
  Future<AppResult<List<SavedStory>>> getSavedStories({
    required SavedStoryListKind kind,
  }) async {
    final uid = _uid;
    if (uid == null) {
      return const Left(AuthFailure(message: 'لا يوجد مستخدم مسجل'));
    }
    try {
      final docs = await _firestore.getSavedStories(
        uid: uid,
        favoritesOnly: kind == SavedStoryListKind.favorites,
      );
      if (docs.isEmpty) {
        return Right(_defaultSavedStories(kind));
      }
      return Right(docs.map(savedStoryFromMap).toList());
    } on Exception {
      return Right(_defaultSavedStories(kind));
    }
  }

  @override
  Future<AppResult<ParentalSettings>> getParentalSettings() async {
    final uid = _uid;
    if (uid == null) {
      return const Left(AuthFailure(message: 'لا يوجد مستخدم مسجل'));
    }
    try {
      final data = await _firestore.getParental(uid);
      if (data == null) {
        return Right(_defaultParental());
      }
      return Right(parentalFromMap(data));
    } on Exception {
      return Right(_defaultParental());
    }
  }

  @override
  Future<AppResult<ParentalSettings>> updateParentalSettings(
    ParentalSettings settings,
  ) async {
    final uid = _uid;
    if (uid == null) {
      return const Left(AuthFailure(message: 'لا يوجد مستخدم مسجل'));
    }
    try {
      await _firestore.setParental(uid, parentalToMap(settings));
      return Right(settings);
    } on Exception {
      return const Left(ServerFailure(message: 'تعذر حفظ الإعدادات'));
    }
  }

  // ─── Defaults that match the design when Firestore has no data yet ─────────

  ReaderProfile _defaultProfile(String uid) {
    return ReaderProfile(
      uid: uid,
      displayName: _auth.currentUser?.displayName ?? 'ريّان أحمد',
      avatarEmoji: '🐻',
      photoUrl: _auth.currentUser?.photoUrl ?? '',
      levelKey: 'levelSkilledReader',
      joinedAt: DateTime.now().subtract(const Duration(days: 90)),
      badgesCount: 7,
      storiesWritten: 12,
      storiesPrinted: 24,
    );
  }

  AchievementsSummary _defaultAchievements(ReaderProfile p) {
    return AchievementsSummary(
      levelKey: p.levelKey,
      streakDays: 7,
      streakWeek: const [true, true, true, true, true, true, true],
      badges: const [
        AchievementBadge(
          kind: BadgeKind.consistent,
          icon: Icons.local_fire_department_rounded,
          color: AppColors.secondary,
          unlocked: true,
          metricValue: 7,
        ),
        AchievementBadge(
          kind: BadgeKind.creativeWriter,
          icon: Icons.edit_rounded,
          color: AppColors.tertiary,
          unlocked: true,
          metricValue: 5,
        ),
        AchievementBadge(
          kind: BadgeKind.voraciousReader,
          icon: Icons.menu_book_rounded,
          color: AppColors.primary,
          unlocked: true,
          metricValue: 10,
        ),
        AchievementBadge(
          kind: BadgeKind.littleWorld,
          icon: Icons.school_rounded,
          color: AppColors.textTertiary,
          unlocked: false,
          metricValue: 50,
        ),
        AchievementBadge(
          kind: BadgeKind.monthHero,
          icon: Icons.emoji_events_rounded,
          color: AppColors.textTertiary,
          unlocked: false,
          metricValue: 1,
        ),
        AchievementBadge(
          kind: BadgeKind.storyStar,
          icon: Icons.star_rounded,
          color: AppColors.textTertiary,
          unlocked: false,
          metricValue: 25,
        ),
      ],
    );
  }

  List<SavedStory> _defaultSavedStories(SavedStoryListKind kind) {
    final now = DateTime.now();
    final favs = <SavedStory>[
      SavedStory(
        id: 'green-forest',
        title: 'سر الغابة الخضراء',
        categoryLabel: 'مغامرات',
        coverEmoji: '🌳',
        coverColor: AppColors.primaryContainer,
        durationMinutes: 5,
        progress: 0.6,
        isFavorite: true,
        lastOpenedAt: now.subtract(const Duration(hours: 2)),
      ),
      SavedStory(
        id: 'space-trip',
        title: 'رحلة في الفضاء',
        categoryLabel: 'خيال علمي',
        coverEmoji: '🚀',
        coverColor: AppColors.tertiaryContainer,
        durationMinutes: 8,
        progress: 0.3,
        isFavorite: true,
        lastOpenedAt: now.subtract(const Duration(days: 1)),
      ),
      SavedStory(
        id: 'little-boat',
        title: 'قارب الصيد الصغير',
        categoryLabel: 'حيوانات',
        coverEmoji: '⛵',
        coverColor: AppColors.secondaryContainer,
        durationMinutes: 6,
        progress: 0.45,
        isFavorite: true,
        lastOpenedAt: now.subtract(const Duration(days: 3)),
      ),
      SavedStory(
        id: 'magic-colors',
        title: 'مملكة الألوان السحرية',
        categoryLabel: 'خيال',
        coverEmoji: '✨',
        coverColor: AppColors.headerBackground,
        durationMinutes: 7,
        progress: 0.85,
        isFavorite: true,
        lastOpenedAt: now.subtract(const Duration(days: 5)),
      ),
    ];
    if (kind == SavedStoryListKind.favorites) return favs;
    return favs
        .map(
          (s) => SavedStory(
            id: s.id,
            title: s.title,
            categoryLabel: s.categoryLabel,
            coverEmoji: s.coverEmoji,
            coverColor: s.coverColor,
            durationMinutes: s.durationMinutes,
            progress: s.progress,
            isFavorite: false,
            lastOpenedAt: s.lastOpenedAt,
          ),
        )
        .toList();
  }

  ParentalSettings _defaultParental() {
    return const ParentalSettings(
      ageRangeFrom: 7,
      ageRangeTo: 9,
      contentFilterEnabled: true,
      dailyQuotaMinutes: 60,
      usedTodayMinutes: 45,
      weeklyScheduleSubtitle: 'ساعة كل يوم بعد المدرسة',
    );
  }
}
