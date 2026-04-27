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
    try {
      final docs = await _firestore.getStories(categoryId: categoryId);
      if (docs.isEmpty) {
        return Right(_filterSeed(categoryId));
      }
      return Right(docs.map(storyFromMap).toList());
    } on Exception {
      return Right(_filterSeed(categoryId));
    }
  }

  @override
  Future<AppResult<Story>> getStoryById(String id) async {
    try {
      final data = await _firestore.getStoryById(id);
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
      if (id == null) return Right(SeedStories.storyOfTheDay);
      final data = await _firestore.getStoryById(id);
      if (data == null) return Right(SeedStories.storyOfTheDay);
      return Right(storyFromMap(data));
    } on Exception {
      return Right(SeedStories.storyOfTheDay);
    }
  }

  @override
  Future<AppResult<List<Story>>> searchStories(String query) async {
    final trimmed = query.trim();
    if (trimmed.isEmpty) return const Right([]);
    try {
      final docs = await _firestore.searchStories(trimmed);
      if (docs.isEmpty) return Right(_searchSeed(trimmed));
      return Right(docs.map(storyFromMap).toList());
    } on Exception {
      return Right(_searchSeed(trimmed));
    }
  }

  @override
  Future<AppResult<List<Story>>> getStoriesByIds(List<String> ids) async {
    if (ids.isEmpty) return const Right([]);
    try {
      final docs = await _firestore.getByIds(ids);
      if (docs.isEmpty) {
        return Right(SeedStories.all.where((s) => ids.contains(s.id)).toList());
      }
      return Right(docs.map(storyFromMap).toList());
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
