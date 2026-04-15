import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:story_craft/features/auth/sign_up/domain/entities/sign_up_data.dart';
import 'package:story_craft/features/auth/sign_up/domain/usecases/sign_up_usecase.dart';
import 'package:story_craft/features/auth/sign_up/presentation/cubit/sign_up_state.dart';

class SignUpCubit extends Cubit<SignUpState> {
  SignUpCubit(this._signUpUseCase) : super(const SignUpInitial());

  final SignUpUseCase _signUpUseCase;

  Future<void> signUp(SignUpData data) async {
    emit(const SignUpLoading());

    final result = await _signUpUseCase(
      SignUpParams(data: data),
    );

    result.fold(
      (failure) => emit(SignUpError(failure.message)),
      (user) => emit(SignUpSuccess(user)),
    );
  }
}