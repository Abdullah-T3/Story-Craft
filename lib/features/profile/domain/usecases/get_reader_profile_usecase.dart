import 'package:story_craft/core/error/failures.dart';
import 'package:story_craft/core/usecase/usecase.dart';
import 'package:story_craft/features/profile/domain/entities/reader_profile.dart';
import 'package:story_craft/features/profile/domain/repositories/profile_repository.dart';

class GetReaderProfileUseCase
    implements UseCase<AppResult<ReaderProfile>, NoParams> {
  const GetReaderProfileUseCase(this._repository);

  final ProfileRepository _repository;

  @override
  Future<AppResult<ReaderProfile>> call(NoParams params) =>
      _repository.getReaderProfile();
}
