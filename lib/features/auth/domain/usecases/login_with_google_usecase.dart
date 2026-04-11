import 'package:story_craft/core/error/failures.dart';
import 'package:story_craft/core/usecase/usecase.dart';
import 'package:story_craft/features/auth/domain/entities/app_user.dart';
import 'package:story_craft/features/auth/domain/repositories/auth_repository.dart';

class LoginWithGoogleUseCase implements UseCase<AppResult<AppUser>, NoParams> {
  const LoginWithGoogleUseCase(this._repository);

  final AuthRepository _repository;

  @override
  Future<AppResult<AppUser>> call(NoParams params) {
    return _repository.loginWithGoogle();
  }
}
