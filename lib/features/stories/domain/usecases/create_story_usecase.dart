import 'package:story_craft/core/error/failures.dart';
import 'package:story_craft/core/usecase/usecase.dart';
import 'package:story_craft/features/stories/domain/entities/story.dart';
import 'package:story_craft/features/stories/domain/repositories/stories_repository.dart';

class CreateStoryParams {
  const CreateStoryParams({
    required this.title,
    required this.summary,
    required this.categoryId,
    required this.coverColor,
    required this.coverEmoji,
    required this.ageRangeFrom,
    required this.ageRangeTo,
    required this.durationMinutes,
    required this.pageTexts,
    required this.tags,
    this.coverImageUrl,
    this.pageImageUrls = const [],
  });

  final String title;
  final String summary;
  final String categoryId;
  final int coverColor;
  final String coverEmoji;
  final int ageRangeFrom;
  final int ageRangeTo;
  final int durationMinutes;
  final List<String> pageTexts;
  final List<String> tags;
  final String? coverImageUrl;
  final List<String?> pageImageUrls;
}

class CreateStoryUseCase
    implements UseCase<AppResult<Story>, CreateStoryParams> {
  const CreateStoryUseCase(this._repo);
  final StoriesRepository _repo;

  @override
  Future<AppResult<Story>> call(CreateStoryParams p) {
    return _repo.createStory(
      title: p.title,
      summary: p.summary,
      categoryId: p.categoryId,
      coverColor: p.coverColor,
      coverEmoji: p.coverEmoji,
      ageRangeFrom: p.ageRangeFrom,
      ageRangeTo: p.ageRangeTo,
      durationMinutes: p.durationMinutes,
      pageTexts: p.pageTexts,
      tags: p.tags,
      coverImageUrl: p.coverImageUrl,
      pageImageUrls: p.pageImageUrls,
    );
  }
}
