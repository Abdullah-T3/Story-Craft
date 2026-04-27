import 'package:story_craft/features/profile/domain/entities/reader_profile.dart';

class PersonalInfoState {
  const PersonalInfoState({
    this.profile,
    this.isLoading = false,
    this.isSaving = false,
    this.savedAt,
    this.error,
  });

  final ReaderProfile? profile;
  final bool isLoading;
  final bool isSaving;
  final DateTime? savedAt;
  final String? error;

  PersonalInfoState copyWith({
    ReaderProfile? profile,
    bool? isLoading,
    bool? isSaving,
    DateTime? savedAt,
    String? error,
    bool clearError = false,
    bool clearSavedAt = false,
  }) {
    return PersonalInfoState(
      profile: profile ?? this.profile,
      isLoading: isLoading ?? this.isLoading,
      isSaving: isSaving ?? this.isSaving,
      savedAt: clearSavedAt ? null : (savedAt ?? this.savedAt),
      error: clearError ? null : (error ?? this.error),
    );
  }
}
