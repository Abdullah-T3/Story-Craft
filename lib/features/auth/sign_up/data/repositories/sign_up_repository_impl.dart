import 'package:firebase_auth/firebase_auth.dart';
import 'package:fpdart/fpdart.dart';
import 'package:story_craft/core/error/failures.dart';
import 'package:story_craft/features/auth/sign_up/data/datasources/sign_up_remote_datasource.dart';
import 'package:story_craft/features/auth/sign_up/domain/entities/sign_up_data.dart';
import 'package:story_craft/features/auth/sign_up/domain/repositories/sign_up_repository.dart';

class SignUpRepositoryImpl implements SignUpRepository {
  const SignUpRepositoryImpl(this._remoteDatasource);

  final SignUpRemoteDatasource _remoteDatasource;

  @override
  Future<AppResult<SignUpData>> signUp({
    required SignUpData signUpData,
  }) async {
    try {
      final result = await _remoteDatasource.signUp(signUpData: signUpData);
      return Right(result);
    } on FirebaseAuthException catch (e) {
      return Left(AuthFailure(
        message: _mapFirebaseErrorMessage(e.code),
        code: e.code,
      ));
    } on Exception {
      return const Left(AuthFailure(message: 'حدث خطأ غير متوقع'));
    }
  }

  @override
  Map<String, String> validateSignUpData({
    required SignUpData signUpData,
  }) {
    final errors = <String, String>{};

    if (signUpData.name.isEmpty) {
      errors['name'] = 'الاسم مطلوب';
    } else if (signUpData.name.length < 2) {
      errors['name'] = 'الاسم يجب أن يحتوي على حرفين على الأقل';
    }

    if (signUpData.email.isEmpty) {
      errors['email'] = 'البريد الإلكتروني مطلوب';
    } else if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}\$').hasMatch(signUpData.email)) {
      errors['email'] = 'البريد الإلكتروني غير صالح';
    }

    if (signUpData.password.isEmpty) {
      errors['password'] = 'كلمة المرور مطلوبة';
    } else if (signUpData.password.length < 6) {
      errors['password'] = 'كلمة المرور يجب أن تكون 6 أحرف على الأقل';
    }

    if (signUpData.childName.isEmpty) {
      errors['childName'] = 'اسم الطفل مطلوب';
    }

    if (signUpData.ageCategory.isEmpty) {
      errors['ageCategory'] = 'فئة العمر مطلوبة';
    }

    return errors;
  }

  @override
  Future<AppResult<bool>> isEmailRegistered({
    required String email,
  }) async {
    try {
      final isRegistered = await _remoteDatasource.isEmailRegistered(email);
      return Right(isRegistered);
    } on FirebaseAuthException catch (e) {
      return Left(AuthFailure(
        message: _mapFirebaseErrorMessage(e.code),
        code: e.code,
      ));
    } on Exception {
      return const Left(AuthFailure(message: 'حدث خطأ غير متوقع'));
    }
  }

  String _mapFirebaseErrorMessage(String code) {
    return switch (code) {
      'email-already-in-use' => 'البريد الإلكتروني مستخدم بالفعل',
      'invalid-email' => 'البريد الإلكتروني غير صالح',
      'weak-password' => 'كلمة المرور ضعيفة جداً',
      'operation-not-allowed' => 'التسجيل معطل حالياً',
      'too-many-requests' => 'محاولات كثيرة، حاول لاحقاً',
      _ => 'حدث خطأ، حاول مرة أخرى',
    };
  }
}
