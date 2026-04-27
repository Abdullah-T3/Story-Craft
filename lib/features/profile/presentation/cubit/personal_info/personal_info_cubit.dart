import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:story_craft/core/usecase/usecase.dart';
import 'package:story_craft/features/profile/domain/usecases/get_reader_profile_usecase.dart';
import 'package:story_craft/features/profile/domain/usecases/update_profile_usecase.dart';
import 'package:story_craft/features/profile/presentation/cubit/personal_info/personal_info_state.dart';

class PersonalInfoCubit extends Cubit<PersonalInfoState> {
  PersonalInfoCubit({
    required GetReaderProfileUseCase getProfile,
    required UpdateProfileUseCase updateProfile,
  }) : _getProfile = getProfile,
       _updateProfile = updateProfile,
       super(const PersonalInfoState());

  final GetReaderProfileUseCase _getProfile;
  final UpdateProfileUseCase _updateProfile;

  Future<void> load() async {
    emit(state.copyWith(isLoading: true, clearError: true));
    final result = await _getProfile(const NoParams());
    result.fold(
      (f) => emit(state.copyWith(isLoading: false, error: f.message)),
      (p) => emit(state.copyWith(isLoading: false, profile: p)),
    );
  }

  Future<void> save({
    required String parentName,
    required String childName,
    required String ageCategory,
    String? photoUrl,
  }) async {
    emit(state.copyWith(isSaving: true, clearError: true, clearSavedAt: true));
    final result = await _updateProfile(
      UpdateProfileParams(
        parentName: parentName,
        childName: childName,
        ageCategory: ageCategory,
        photoUrl: photoUrl,
      ),
    );
    result.fold(
      (f) => emit(state.copyWith(isSaving: false, error: f.message)),
      (p) => emit(
        state.copyWith(
          isSaving: false,
          profile: p,
          savedAt: DateTime.now(),
        ),
      ),
    );
  }
}
