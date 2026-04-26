import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:story_craft/core/usecase/usecase.dart';
import 'package:story_craft/features/profile/domain/usecases/get_achievements_usecase.dart';
import 'package:story_craft/features/profile/presentation/cubit/achievements/achievements_state.dart';

class AchievementsCubit extends Cubit<AchievementsState> {
  AchievementsCubit(this._getAchievements) : super(const AchievementsInitial());

  final GetAchievementsUseCase _getAchievements;

  Future<void> load() async {
    emit(const AchievementsLoading());
    final result = await _getAchievements(const NoParams());
    result.fold(
      (f) => emit(AchievementsErrorState(f.message)),
      (s) => emit(AchievementsLoaded(s)),
    );
  }
}
