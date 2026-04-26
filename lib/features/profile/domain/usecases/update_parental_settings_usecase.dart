import 'package:story_craft/core/error/failures.dart';
import 'package:story_craft/core/usecase/usecase.dart';
import 'package:story_craft/features/profile/domain/entities/parental_settings.dart';
import 'package:story_craft/features/profile/domain/repositories/profile_repository.dart';

class UpdateParentalSettingsUseCase
    implements UseCase<AppResult<ParentalSettings>, ParentalSettings> {
  const UpdateParentalSettingsUseCase(this._repository);

  final ProfileRepository _repository;

  @override
  Future<AppResult<ParentalSettings>> call(ParentalSettings params) =>
      _repository.updateParentalSettings(params);
}
