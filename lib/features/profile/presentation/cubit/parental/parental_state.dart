import 'package:story_craft/features/profile/domain/entities/parental_settings.dart';

class ParentalState {
  const ParentalState({
    this.settings,
    this.isLoading = false,
    this.isSaving = false,
    this.error,
  });

  final ParentalSettings? settings;
  final bool isLoading;
  final bool isSaving;
  final String? error;

  ParentalState copyWith({
    ParentalSettings? settings,
    bool? isLoading,
    bool? isSaving,
    String? error,
    bool clearError = false,
  }) {
    return ParentalState(
      settings: settings ?? this.settings,
      isLoading: isLoading ?? this.isLoading,
      isSaving: isSaving ?? this.isSaving,
      error: clearError ? null : (error ?? this.error),
    );
  }
}
