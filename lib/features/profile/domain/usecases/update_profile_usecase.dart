import 'package:story_craft/core/error/failures.dart';
import 'package:story_craft/core/usecase/usecase.dart';
import 'package:story_craft/features/profile/domain/entities/reader_profile.dart';
import 'package:story_craft/features/profile/domain/repositories/profile_repository.dart';

class UpdateProfileParams {
  const UpdateProfileParams({
    this.parentName,
    this.childName,
    this.ageCategory,
    this.photoUrl,
  });

  final String? parentName;
  final String? childName;
  final String? ageCategory;
  final String? photoUrl;
}

class UpdateProfileUseCase
    implements UseCase<AppResult<ReaderProfile>, UpdateProfileParams> {
  const UpdateProfileUseCase(this._repo);
  final ProfileRepository _repo;

  @override
  Future<AppResult<ReaderProfile>> call(UpdateProfileParams params) {
    return _repo.updateProfile(
      parentName: params.parentName,
      childName: params.childName,
      ageCategory: params.ageCategory,
      photoUrl: params.photoUrl,
    );
  }
}
