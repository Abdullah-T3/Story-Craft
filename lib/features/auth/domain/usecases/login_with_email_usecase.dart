import 'package:story_craft/core/error/failures.dart';
import 'package:story_craft/core/usecase/usecase.dart';
import 'package:story_craft/features/auth/domain/entities/app_user.dart';
import 'package:story_craft/features/auth/domain/repositories/auth_repository.dart';

class LoginWithEmailUseCase
    implements UseCase<AppResult<AppUser>, LoginParams> {
  const LoginWithEmailUseCase(this._repository);

  final AuthRepository _repository;

  @override
  Future<AppResult<AppUser>> call(LoginParams params) {
    return _repository.loginWithEmail(
      email: params.email,
      password: params.password,
    );
  }
}

class LoginParams {
  const LoginParams({required this.email, required this.password});

  final String email;
  final String password;
}
