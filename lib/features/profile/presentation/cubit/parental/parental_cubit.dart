import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:story_craft/core/usecase/usecase.dart';
import 'package:story_craft/features/profile/domain/usecases/get_parental_settings_usecase.dart';
import 'package:story_craft/features/profile/domain/usecases/update_parental_settings_usecase.dart';
import 'package:story_craft/features/profile/presentation/cubit/parental/parental_state.dart';

class ParentalCubit extends Cubit<ParentalState> {
  ParentalCubit({
    required GetParentalSettingsUseCase getSettings,
    required UpdateParentalSettingsUseCase updateSettings,
  }) : _getSettings = getSettings,
       _updateSettings = updateSettings,
       super(const ParentalState());

  final GetParentalSettingsUseCase _getSettings;
  final UpdateParentalSettingsUseCase _updateSettings;

  Future<void> load() async {
    emit(state.copyWith(isLoading: true, clearError: true));
    final result = await _getSettings(const NoParams());
    result.fold(
      (f) => emit(state.copyWith(isLoading: false, error: f.message)),
      (s) => emit(state.copyWith(isLoading: false, settings: s)),
    );
  }

  Future<void> setContentFilter({required bool enabled}) async {
    final current = state.settings;
    if (current == null) return;
    final updated = current.copyWith(contentFilterEnabled: enabled);
    emit(state.copyWith(settings: updated, isSaving: true));
    final result = await _updateSettings(updated);
    result.fold(
      (f) => emit(
        state.copyWith(
          settings: current,
          isSaving: false,
          error: f.message,
        ),
      ),
      (s) => emit(state.copyWith(settings: s, isSaving: false)),
    );
  }
}
