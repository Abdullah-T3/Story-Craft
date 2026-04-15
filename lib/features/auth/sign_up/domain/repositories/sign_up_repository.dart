import 'package:story_craft/core/error/failures.dart';
import 'package:story_craft/features/auth/sign_up/domain/entities/sign_up_data.dart';

abstract interface class SignUpRepository {
  Future<AppResult<SignUpData>> signUp({
    required SignUpData signUpData,
  });

  Future<AppResult<bool>> isEmailRegistered({
    required String email,
  });

  Map<String, String> validateSignUpData({
    required SignUpData signUpData,
  });
}
