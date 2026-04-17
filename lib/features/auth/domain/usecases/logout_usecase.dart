import 'package:story_craft/core/error/failures.dart';
import 'package:story_craft/core/usecase/usecase.dart';
import 'package:story_craft/features/auth/domain/repositories/auth_repository.dart';

class LogoutUseCase implements UseCase<AppResult<void>, NoParams> {
  const LogoutUseCase(this._repository);

  final AuthRepository _repository;

  @override
  Future<AppResult<void>> call(NoParams params) {
    return _repository.logout();
  }
}
