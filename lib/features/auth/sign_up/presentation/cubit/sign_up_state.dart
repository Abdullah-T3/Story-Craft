import 'package:story_craft/features/auth/domain/entities/sign_up_data.dart';

sealed class SignUpState {
  const SignUpState();
}

final class SignUpInitial extends SignUpState {
  const SignUpInitial();
}

final class SignUpLoading extends SignUpState {
  const SignUpLoading();
}

final class SignUpSuccess extends SignUpState {
  const SignUpSuccess(this.user);
  final SignUpData user;
}

final class SignUpError extends SignUpState {
  const SignUpError(this.message);
  final String message;
}

class SignUpStepState extends SignUpState {
  final int step;
  const SignUpStepState(this.step);
}