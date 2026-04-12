import 'package:story_craft/core/error/failures.dart';
import 'package:story_craft/core/usecase/usecase.dart';
import 'package:story_craft/features/auth/domain/repositories/auth_repository.dart';

class ResetPasswordUseCase implements UseCase<AppResult<void>, String> {
  const ResetPasswordUseCase(this._repository);

  final AuthRepository _repository;

  @override
  Future<AppResult<void>> call(String email) {
    return _repository.resetPassword(email: email);
  }
}
