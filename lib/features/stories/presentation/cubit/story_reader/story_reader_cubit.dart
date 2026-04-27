import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:story_craft/features/profile/domain/entities/parental_settings.dart';
import 'package:story_craft/features/profile/domain/usecases/get_parental_settings_usecase.dart';
import 'package:story_craft/features/profile/domain/usecases/update_parental_settings_usecase.dart';
import 'package:story_craft/core/usecase/usecase.dart';
import 'package:story_craft/features/stories/domain/repositories/stories_repository.dart';
import 'package:story_craft/features/stories/domain/usecases/get_story_by_id_usecase.dart';
import 'package:story_craft/features/stories/domain/usecases/save_progress_usecase.dart';
import 'package:story_craft/features/stories/presentation/cubit/story_reader/story_reader_state.dart';

class StoryReaderCubit extends Cubit<StoryReaderState> {
  StoryReaderCubit({
    required GetStoryByIdUseCase getStoryById,
    required SaveProgressUseCase saveProgress,
    required StoriesRepository repository,
    required GetParentalSettingsUseCase getParental,
    required UpdateParentalSettingsUseCase updateParental,
  }) : _getStoryById = getStoryById,
       _saveProgress = saveProgress,
       _repository = repository,
       _getParental = getParental,
       _updateParental = updateParental,
       super(const StoryReaderState());

  final GetStoryByIdUseCase _getStoryById;
  final SaveProgressUseCase _saveProgress;
  final StoriesRepository _repository;
  final GetParentalSettingsUseCase _getParental;
  final UpdateParentalSettingsUseCase _updateParental;

  ParentalSettings? _parental;
  DateTime? _sessionStart;

  Future<void> load(String storyId) async {
    emit(state.copyWith(isLoading: true, clearError: true));
    final result = await _getStoryById(storyId);
    final progress = await _repository.getProgress(storyId);
    final parental = await _getParental(const NoParams());
    _parental = parental.getRight().toNullable();
    _sessionStart = DateTime.now();

    result.fold(
      (f) => emit(state.copyWith(isLoading: false, error: f.message)),
      (story) {
        final start = progress.getRight().toNullable()?.lastPageIndex ?? 0;
        emit(
          state.copyWith(
            isLoading: false,
            story: story,
            currentIndex: start.clamp(0, story.pageCount - 1),
            completed: false,
          ),
        );
      },
    );
  }

  Future<void> goToPage(int index) async {
    final story = state.story;
    if (story == null) return;
    final clamped = index.clamp(0, story.pageCount - 1);
    if (clamped == state.currentIndex) return;
    emit(state.copyWith(currentIndex: clamped));
    await _saveProgress(
      SaveProgressParams(
        storyId: story.id,
        lastPageIndex: clamped,
        totalPages: story.pageCount,
        completed: false,
      ),
    );
  }

  Future<void> markFinished() async {
    final story = state.story;
    if (story == null) return;
    emit(state.copyWith(completed: true));
    await _saveProgress(
      SaveProgressParams(
        storyId: story.id,
        lastPageIndex: story.pageCount - 1,
        totalPages: story.pageCount,
        completed: true,
      ),
    );
    await _flushUsage();
  }

  bool isOverDailyQuota() {
    final p = _parental;
    if (p == null) return false;
    return p.usedTodayMinutes >= p.dailyQuotaMinutes;
  }

  /// Persist the elapsed session minutes back to parental settings.
  Future<void> _flushUsage() async {
    final p = _parental;
    final start = _sessionStart;
    if (p == null || start == null) return;
    final elapsedMinutes = DateTime.now().difference(start).inMinutes;
    if (elapsedMinutes <= 0) return;
    final updated = p.copyWith(
      usedTodayMinutes: (p.usedTodayMinutes + elapsedMinutes).clamp(
        0,
        p.dailyQuotaMinutes,
      ),
    );
    _parental = updated;
    _sessionStart = DateTime.now();
    await _updateParental(updated);
  }

  @override
  Future<void> close() async {
    await _flushUsage();
    return super.close();
  }
}
