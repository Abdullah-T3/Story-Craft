import 'package:story_craft/core/error/failures.dart';
import 'package:story_craft/core/usecase/usecase.dart'; 
import 'package:story_craft/features/auth/sign_up/domain/entities/sign_up_data.dart';
import 'package:story_craft/features/auth/sign_up/domain/repositories/sign_up_repository.dart';

class SignUpUseCase implements UseCase<AppResult<SignUpData>, SignUpParams> {
  const SignUpUseCase(this._repository);

  final SignUpRepository _repository;

  @override
  Future<AppResult<SignUpData>> call(SignUpParams params) {
    return _repository.signUp(signUpData: params.data);
  }
}

class SignUpParams {
  const SignUpParams({required this.data});

  final SignUpData data;
}
