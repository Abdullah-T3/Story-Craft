import 'package:story_craft/core/error/failures.dart';
import 'package:story_craft/core/usecase/usecase.dart';
import 'package:story_craft/features/profile/domain/entities/parental_settings.dart';
import 'package:story_craft/features/profile/domain/repositories/profile_repository.dart';

class GetParentalSettingsUseCase
    implements UseCase<AppResult<ParentalSettings>, NoParams> {
  const GetParentalSettingsUseCase(this._repository);

  final ProfileRepository _repository;

  @override
  Future<AppResult<ParentalSettings>> call(NoParams params) =>
      _repository.getParentalSettings();
}
