import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fpdart/fpdart.dart';
import 'package:story_craft/core/error/failures.dart';
import 'package:story_craft/features/auth/domain/repositories/auth_repository.dart';
import 'package:story_craft/features/stories/data/datasources/firestore_stories_datasource.dart';
import 'package:story_craft/features/stories/data/models/story_mappers.dart';
import 'package:story_craft/features/stories/data/seed/seed_stories.dart';
import 'package:story_craft/features/stories/domain/entities/reading_progress.dart';
import 'package:story_craft/features/stories/domain/entities/story.dart';
import 'package:story_craft/features/stories/domain/repositories/stories_repository.dart';

class StoriesRepositoryImpl implements StoriesRepository {
  const StoriesRepositoryImpl({
    required FirestoreStoriesDatasource firestore,
    required AuthRepository auth,
  }) : _firestore = firestore,
       _auth = auth;

  final FirestoreStoriesDatasource _firestore;
  final AuthRepository _auth;

  String? get _uid => _auth.currentUser?.uid;

  @override
  Future<AppResult<List<Story>>> getStories({String? categoryId}) async {
    // Run both reads independently so one failing (e.g. permission-denied
    // on public stories) does not hide the user's own stories.
    final publicDocs = await _safeGetPublic(categoryId);
    final mineDocs = await _loadMyStoriesRaw();

    final merged = <Story>[
      ...publicDocs.map(storyFromMap),
      ..._filterMyByCategory(mineDocs.map(storyFromMap), categoryId),
    ];
    final byId = <String, Story>{for (final s in merged) s.id: s};
    final unique = byId.values.toList();
    // Only fall back to seed stories when *everything* is empty (no public,
    // no personal). When the user has created at least one story, respect
    // that — even on a category filter that has no matches.
    final hasAnyReal = publicDocs.isNotEmpty || mineDocs.isNotEmpty;
    if (unique.isEmpty && !hasAnyReal) {
      return Right(_filterSeed(categoryId));
    }
    return Right(unique);
  }

  Future<List<Map<String, dynamic>>> _safeGetPublic(String? categoryId) async {
    try {
      return await _firestore.getStories(categoryId: categoryId);
    } on Exception {
      return const [];
    }
  }

  /// Pull the signed-in user's authored stories (or [] if not signed in /
  /// permission-denied). Errors are swallowed so library still renders.
  Future<List<Map<String, dynamic>>> _loadMyStoriesRaw() async {
    final uid = _uid;
    if (uid == null) return const [];
    try {
      return await _firestore.getMyStories(uid);
    } on Exception {
      return const [];
    }
  }

  Iterable<Story> _filterMyByCategory(Iterable<Story> mine, String? categoryId) {
    if (categoryId == null || categoryId == 'all') return mine;
    return mine.where((s) => s.categoryId == categoryId);
  }

  @override
  Future<AppResult<Story>> getStoryById(String id) async {
    try {
      final data = await _firestore.getStoryById(id, uid: _uid);
      if (data == null) {
        final fallback = SeedStories.all.where((s) => s.id == id).toList();
        if (fallback.isEmpty) {
          return const Left(ServerFailure(message: 'القصة غير موجودة'));
        }
        return Right(fallback.first);
      }
      return Right(storyFromMap(data));
    } on Exception {
      final fallback = SeedStories.all.where((s) => s.id == id).toList();
      if (fallback.isEmpty) {
        return const Left(ServerFailure(message: 'تعذر جلب القصة'));
      }
      return Right(fallback.first);
    }
  }

  @override
  Future<AppResult<Story>> getStoryOfTheDay() async {
    try {
      final id = await _firestore.getStoryOfTheDayId();
      if (id != null) {
        final data = await _firestore.getStoryById(id, uid: _uid);
        if (data != null) return Right(storyFromMap(data));
      }
      // No featured doc — surface the user's newest authored story instead.
      final mine = await _loadMyStoriesRaw();
      if (mine.isNotEmpty) {
        return Right(storyFromMap(mine.first));
      }
      return Right(SeedStories.storyOfTheDay);
    } on Exception {
      return Right(SeedStories.storyOfTheDay);
    }
  }

  @override
  Future<AppResult<List<Story>>> searchStories(String query) async {
    final trimmed = query.trim();
    if (trimmed.isEmpty) return const Right([]);
    try {
      final publicDocs = await _firestore.searchStories(trimmed);
      final results = <Story>[...publicDocs.map(storyFromMap)];
      final q = trimmed.toLowerCase();
      // Local filter over the user's authored stories — Firestore's prefix
      // index isn't shared with subcollections.
      final mineDocs = await _loadMyStoriesRaw();
      for (final m in mineDocs) {
        final s = storyFromMap(m);
        final hit = s.title.toLowerCase().contains(q) ||
            s.summary.toLowerCase().contains(q) ||
            s.tags.any((t) => t.toLowerCase().contains(q));
        if (hit && !results.any((x) => x.id == s.id)) {
          results.add(s);
        }
      }
      if (results.isEmpty) return Right(_searchSeed(trimmed));
      return Right(results);
    } on Exception {
      return Right(_searchSeed(trimmed));
    }
  }

  @override
  Future<AppResult<List<Story>>> getStoriesByIds(List<String> ids) async {
    if (ids.isEmpty) return const Right([]);
    try {
      final docs = await _firestore.getByIds(ids);
      final stories = docs.map(storyFromMap).toList();
      // Cover any IDs not present in the public collection by checking
      // the user's authored stories + the seed list.
      final foundIds = stories.map((s) => s.id).toSet();
      final missing = ids.where((id) => !foundIds.contains(id)).toList();
      if (missing.isNotEmpty) {
        final uid = _uid;
        if (uid != null) {
          final mine = await _firestore.getMyStories(uid);
          stories.addAll(
            mine
                .where((m) => missing.contains(m['id']))
                .map(storyFromMap),
          );
        }
        for (final s in SeedStories.all) {
          if (missing.contains(s.id) &&
              !stories.any((x) => x.id == s.id)) {
            stories.add(s);
          }
        }
      }
      if (stories.isEmpty) {
        return Right(SeedStories.all.where((s) => ids.contains(s.id)).toList());
      }
      return Right(stories);
    } on Exception {
      return Right(SeedStories.all.where((s) => ids.contains(s.id)).toList());
    }
  }

  @override
  Future<AppResult<List<String>>> getFavoriteIds() async {
    final uid = _uid;
    if (uid == null) return const Right([]);
    try {
      return Right(await _firestore.getFavoriteIds(uid));
    } on Exception {
      return const Right([]);
    }
  }

  @override
  Future<AppResult<bool>> toggleFavorite(String storyId) async {
    final uid = _uid;
    if (uid == null) {
      return const Left(AuthFailure(message: 'يجب تسجيل الدخول'));
    }
    try {
      return Right(await _firestore.toggleFavorite(uid, storyId));
    } on Exception {
      return const Left(ServerFailure(message: 'تعذر تحديث المفضلة'));
    }
  }

  @override
  Future<AppResult<ReadingProgress?>> getProgress(String storyId) async {
    final uid = _uid;
    if (uid == null) return const Right(null);
    try {
      final data = await _firestore.getProgress(uid, storyId);
      if (data == null) return const Right(null);
      return Right(progressFromMap({...data, 'storyId': storyId}));
    } on Exception {
      return const Right(null);
    }
  }

  @override
  Future<AppResult<void>> saveProgress({
    required String storyId,
    required int lastPageIndex,
    required int totalPages,
    required bool completed,
  }) async {
    final uid = _uid;
    if (uid == null) return const Right(null);
    try {
      final progress = totalPages == 0
          ? 0.0
          : ((lastPageIndex + 1) / totalPages).clamp(0.0, 1.0);
      await _firestore.saveProgress(uid, storyId, {
        'lastPageIndex': lastPageIndex,
        'progress': progress,
        'completed': completed,
      });
      return const Right(null);
    } on Exception {
      return const Left(ServerFailure(message: 'تعذر حفظ التقدم'));
    }
  }

  @override
  Future<AppResult<Story>> createStory({
    required String title,
    required String summary,
    required String categoryId,
    required int coverColor,
    required String coverEmoji,
    required int ageRangeFrom,
    required int ageRangeTo,
    required int durationMinutes,
    required List<String> pageTexts,
    required List<String> tags,
    String? coverImageUrl,
    List<String?> pageImageUrls = const [],
  }) async {
    final uid = _uid;
    if (uid == null) {
      return const Left(AuthFailure(message: 'يجب تسجيل الدخول'));
    }
    if (title.trim().isEmpty) {
      return const Left(
        AuthFailure(message: 'العنوان مطلوب', code: 'validation'),
      );
    }
    if (pageTexts.where((p) => p.trim().isNotEmpty).isEmpty) {
      return const Left(
        AuthFailure(message: 'أضف نصاً لصفحة واحدة على الأقل', code: 'validation'),
      );
    }
    try {
      final pages = <Map<String, dynamic>>[
        for (var i = 0; i < pageTexts.length; i++)
          {
            'index': i,
            'text': pageTexts[i],
            'emoji': coverEmoji,
            if (i < pageImageUrls.length && pageImageUrls[i] != null)
              'imageUrl': pageImageUrls[i],
          },
      ];
      final data = <String, dynamic>{
        'title': title,
        'titleLower': title.toLowerCase(),
        'summary': summary,
        'categoryId': categoryId,
        'coverColor': coverColor,
        'coverEmoji': coverEmoji,
        if (coverImageUrl != null && coverImageUrl.isNotEmpty)
          'coverImageUrl': coverImageUrl,
        'ageRangeFrom': ageRangeFrom,
        'ageRangeTo': ageRangeTo,
        'durationMinutes': durationMinutes,
        'pages': pages,
        'tags': tags,
        'isPremium': false,
        'isFeatured': false,
      };
      final id = await _firestore.createMyStory(uid, data);
      return Right(storyFromMap({...data, 'id': id}));
    } on FirebaseException catch (e) {
      // Surface the actual Firestore failure so the user sees what's wrong
      // (most often: permission-denied because rules are not deployed).
      return Left(
        ServerFailure(
          message: 'تعذر حفظ القصة: ${e.code}${e.message == null ? '' : ' — ${e.message}'}',
        ),
      );
    } catch (e) {
      return Left(ServerFailure(message: 'تعذر حفظ القصة: $e'));
    }
  }

  @override
  Future<AppResult<List<Story>>> getMyStories() async {
    final uid = _uid;
    if (uid == null) return const Right([]);
    try {
      final docs = await _firestore.getMyStories(uid);
      return Right(docs.map(storyFromMap).toList());
    } on Exception {
      return const Right([]);
    }
  }

  @override
  Future<AppResult<List<ReadingProgress>>> getHistory() async {
    final uid = _uid;
    if (uid == null) return const Right([]);
    try {
      final docs = await _firestore.getHistory(uid);
      return Right(docs.map(progressFromMap).toList());
    } on Exception {
      return const Right([]);
    }
  }

  // ── Seed helpers ───────────────────────────────────────────────────────────

  List<Story> _filterSeed(String? categoryId) {
    if (categoryId == null || categoryId == 'all') return SeedStories.all;
    return SeedStories.all.where((s) => s.categoryId == categoryId).toList();
  }

  List<Story> _searchSeed(String query) {
    final q = query.toLowerCase();
    return SeedStories.all
        .where(
          (s) =>
              s.title.toLowerCase().contains(q) ||
              s.tags.any((t) => t.toLowerCase().contains(q)) ||
              s.summary.toLowerCase().contains(q),
        )
        .toList();
  }
}
