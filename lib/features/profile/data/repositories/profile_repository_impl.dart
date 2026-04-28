import 'package:fpdart/fpdart.dart';
import 'package:story_craft/core/error/failures.dart';
import 'package:story_craft/core/theme/app_colors.dart';
import 'package:story_craft/features/auth/domain/repositories/auth_repository.dart';
import 'package:story_craft/features/profile/data/datasources/firestore_profile_datasource.dart';
import 'package:story_craft/features/profile/data/models/profile_mappers.dart';
import 'package:story_craft/features/profile/domain/entities/achievements_summary.dart';
import 'package:story_craft/features/profile/domain/entities/parental_settings.dart';
import 'package:story_craft/features/profile/domain/entities/reader_profile.dart';
import 'package:story_craft/features/profile/domain/entities/reader_stats.dart';
import 'package:story_craft/features/profile/domain/entities/saved_story.dart';
import 'package:story_craft/features/profile/domain/repositories/profile_repository.dart';
import 'package:story_craft/features/profile/domain/services/badge_rules.dart';
import 'package:story_craft/features/stories/domain/entities/reading_progress.dart';
import 'package:story_craft/features/stories/domain/entities/story.dart';
import 'package:story_craft/features/stories/domain/repositories/stories_repository.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  const ProfileRepositoryImpl({
    required FirestoreProfileDatasource firestore,
    required AuthRepository auth,
    required StoriesRepository stories,
  }) : _firestore = firestore,
       _auth = auth,
       _stories = stories;

  final FirestoreProfileDatasource _firestore;
  final AuthRepository _auth;
  final StoriesRepository _stories;

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
      return const Left(ServerFailure(message: 'تعذر جلب الملف الشخصي'));
    }
  }

  @override
  Future<AppResult<AchievementsSummary>> getAchievements() async {
    final profileResult = await getReaderProfile();
    return profileResult.fold<Future<AppResult<AchievementsSummary>>>(
      (f) async => Left(f),
      (p) async {
        final history =
            (await _stories.getHistory()).getRight().toNullable() ??
            const <ReadingProgress>[];
        final stats = _computeStats(history, p);
        final badges = BadgeRules.evaluate(stats);
        final unlockedCount = badges.where((b) => b.unlocked).length;
        // Keep the user doc's badge count in sync so the profile header
        // shows the same number unlocked on the achievements screen.
        if (unlockedCount != p.badgesCount) {
          await _persistBadgesCount(p.uid, unlockedCount);
        }
        return Right(
          AchievementsSummary(
            levelKey: p.levelKey,
            badges: badges,
            streakDays: stats.streakDays,
            streakWeek: stats.streakWeek,
          ),
        );
      },
    );
  }

  ReaderStats _computeStats(List<ReadingProgress> history, ReaderProfile p) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    // Any history entry on a given day counts as reading activity — we don't
    // want to break the streak just because the child paused mid-story.
    final readDays = <DateTime>{
      for (final h in history)
        DateTime(h.lastOpenedAt.year, h.lastOpenedAt.month, h.lastOpenedAt.day),
    };
    var streak = 0;
    var cursor = today;
    while (readDays.contains(cursor)) {
      streak++;
      cursor = cursor.subtract(const Duration(days: 1));
    }
    final week = <bool>[
      for (var i = 6; i >= 0; i--)
        readDays.contains(today.subtract(Duration(days: i))),
    ];
    DateTime? lastRead;
    for (final h in history) {
      if (lastRead == null || h.lastOpenedAt.isAfter(lastRead)) {
        lastRead = h.lastOpenedAt;
      }
    }
    return ReaderStats(
      streakDays: streak,
      lastReadDate: lastRead,
      storiesRead: history.where((h) => h.completed).length,
      storiesWritten: p.storiesWritten,
      storiesPrinted: p.storiesPrinted,
      streakWeek: week,
    );
  }

  Future<void> _persistBadgesCount(String uid, int count) async {
    try {
      await _firestore.updateUser(uid, {'badgesCount': count});
    } on Exception {
      // Best-effort mirror — don't fail the achievements load over it.
    }
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
      if (kind == SavedStoryListKind.favorites) {
        final favIds = (await _stories.getFavoriteIds()).getRight().toNullable() ?? const <String>[];
        if (favIds.isEmpty) return const Right([]);
        final stories =
            (await _stories.getStoriesByIds(favIds)).getRight().toNullable() ??
            const <Story>[];
        return Right(stories.map((s) => _toSavedFromStory(s, true)).toList());
      } else {
        final history =
            (await _stories.getHistory()).getRight().toNullable() ??
            const <ReadingProgress>[];
        if (history.isEmpty) return const Right([]);
        final stories =
            (await _stories.getStoriesByIds(
              history.map((h) => h.storyId).toList(),
            )).getRight().toNullable() ??
            const <Story>[];
        final byId = {for (final s in stories) s.id: s};
        return Right([
          for (final h in history)
            if (byId[h.storyId] != null) _toSavedFromHistory(byId[h.storyId]!, h),
        ]);
      }
    } on Exception {
      return Right(_defaultSavedStories(kind));
    }
  }

  SavedStory _toSavedFromStory(Story s, bool fav) {
    return SavedStory(
      id: s.id,
      title: s.title,
      categoryLabel: s.categoryId,
      coverEmoji: s.coverEmoji,
      coverColor: s.coverColor,
      coverImageUrl: s.coverImageUrl,
      durationMinutes: s.durationMinutes,
      progress: 0,
      isFavorite: fav,
      lastOpenedAt: DateTime.now(),
    );
  }

  SavedStory _toSavedFromHistory(Story s, ReadingProgress p) {
    return SavedStory(
      id: s.id,
      title: s.title,
      categoryLabel: s.categoryId,
      coverEmoji: s.coverEmoji,
      coverColor: s.coverColor,
      coverImageUrl: s.coverImageUrl,
      durationMinutes: s.durationMinutes,
      progress: p.progress,
      isFavorite: false,
      lastOpenedAt: p.lastOpenedAt,
    );
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
  Future<AppResult<ReaderProfile>> updateProfile({
    String? parentName,
    String? childName,
    String? ageCategory,
    String? photoUrl,
  }) async {
    final uid = _uid;
    if (uid == null) {
      return const Left(AuthFailure(message: 'لا يوجد مستخدم مسجل'));
    }
    try {
      final data = <String, dynamic>{};
      if (parentName != null) data['name'] = parentName;
      if (childName != null) data['childName'] = childName;
      if (ageCategory != null) data['ageCategory'] = ageCategory;
      if (photoUrl != null) data['photoUrl'] = photoUrl;
      await _firestore.updateUser(uid, data);
      return getReaderProfile();
    } on Exception {
      return const Left(ServerFailure(message: 'تعذر حفظ المعلومات'));
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
      displayName: _auth.currentUser?.displayName ?? '',
      avatarEmoji: '🐻',
      photoUrl: _auth.currentUser?.photoUrl ?? '',
      levelKey: 'levelSkilledReader',
      joinedAt: DateTime.now(),
      badgesCount: 0,
      storiesWritten: 0,
      storiesPrinted: 0,
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
