import 'package:firebase_auth/firebase_auth.dart';
import 'package:fpdart/fpdart.dart';
import 'package:story_craft/core/error/failures.dart';
import 'package:story_craft/core/services/cloudinary/cloudinary_service.dart';
import 'package:story_craft/features/auth/data/datasources/firebase_auth_datasource.dart';
import 'package:story_craft/features/auth/domain/entities/app_user.dart';
import 'package:story_craft/features/auth/domain/entities/sign_up_data.dart';
import 'package:story_craft/features/auth/domain/repositories/auth_repository.dart';
import 'package:story_craft/features/auth/shared/validators/auth_validators.dart';

class AuthRepositoryImpl implements AuthRepository {
  const AuthRepositoryImpl(this._datasource);

  final FirebaseAuthDatasource _datasource;

  @override
  Future<AppResult<AppUser>> loginWithEmail({
    required String email,
    required String password,
  }) async {
    final emailError = AuthValidators.email(email);
    if (emailError != null) {
      return Left(AuthFailure(message: emailError, code: 'validation'));
    }
    final passwordError = AuthValidators.password(password);
    if (passwordError != null) {
      return Left(AuthFailure(message: passwordError, code: 'validation'));
    }

    try {
      final user = await _datasource.loginWithEmail(
        email: email,
        password: password,
      );
      return Right(user);
    } on FirebaseAuthException catch (e) {
      return Left(
        AuthFailure(message: _mapFirebaseErrorMessage(e.code), code: e.code),
      );
    } on Exception {
      return const Left(AuthFailure(message: 'حدث خطأ غير متوقع'));
    }
  }

  @override
  Future<AppResult<AppUser>> loginWithGoogle() async {
    try {
      final user = await _datasource.loginWithGoogle();
      return Right(user);
    } on FirebaseAuthException catch (e) {
      return Left(
        AuthFailure(message: _mapFirebaseErrorMessage(e.code), code: e.code),
      );
    } on Exception {
      return const Left(AuthFailure(message: 'حدث خطأ غير متوقع'));
    }
  }

  @override
  Future<AppResult<void>> resetPassword({required String email}) async {
    final emailError = AuthValidators.email(email);
    if (emailError != null) {
      return Left(AuthFailure(message: emailError, code: 'validation'));
    }

    try {
      await _datasource.resetPassword(email: email);
      return const Right(null);
    } on FirebaseAuthException catch (e) {
      return Left(
        AuthFailure(message: _mapFirebaseErrorMessage(e.code), code: e.code),
      );
    } on Exception {
      return const Left(AuthFailure(message: 'حدث خطأ غير متوقع'));
    }
  }

  @override
  Future<AppResult<void>> logout() async {
    try {
      await _datasource.logout();
      return const Right(null);
    } on Exception {
      return const Left(AuthFailure(message: 'حدث خطأ أثناء تسجيل الخروج'));
    }
  }

  @override
  AppUser? get currentUser => _datasource.currentUser;

  @override
  Future<AppResult<SignUpData>> signUp({
    required SignUpData signUpData,
  }) async {
    final errors = validateSignUpData(signUpData: signUpData);
    if (errors.isNotEmpty) {
      return Left(
        AuthFailure(message: errors.values.first, code: 'validation'),
      );
    }

    try {
      final result = await _datasource.signUp(signUpData: signUpData);
      return Right(result);
    } on FirebaseAuthException catch (e) {
      return Left(
        AuthFailure(message: _mapFirebaseErrorMessage(e.code), code: e.code),
      );
    } on CloudinaryUploadException {
      return const Left(
        AuthFailure(message: 'تعذر رفع الصورة، حاول مرة أخرى'),
      );
    } on Exception {
      return const Left(AuthFailure(message: 'حدث خطأ غير متوقع'));
    }
  }

  @override
  Future<AppResult<bool>> isEmailRegistered({required String email}) async {
    try {
      final isRegistered = await _datasource.isEmailRegistered(email);
      return Right(isRegistered);
    } on FirebaseAuthException catch (e) {
      return Left(
        AuthFailure(message: _mapFirebaseErrorMessage(e.code), code: e.code),
      );
    } on Exception {
      return const Left(AuthFailure(message: 'حدث خطأ غير متوقع'));
    }
  }

  @override
  Map<String, String> validateSignUpData({required SignUpData signUpData}) {
    final errors = <String, String>{};

    final nameError = AuthValidators.name(signUpData.name);
    if (nameError != null) errors['name'] = nameError;

    final emailError = AuthValidators.email(signUpData.email);
    if (emailError != null) errors['email'] = emailError;

    final passwordError = AuthValidators.password(signUpData.password);
    if (passwordError != null) errors['password'] = passwordError;

    final childNameError = AuthValidators.childName(signUpData.childName);
    if (childNameError != null) errors['childName'] = childNameError;

    if (signUpData.ageCategory.isEmpty) {
      errors['ageCategory'] = 'فئة العمر مطلوبة';
    }

    return errors;
  }

  String _mapFirebaseErrorMessage(String code) {
    return switch (code) {
      // Login
      'user-not-found' => 'لا يوجد حساب بهذا البريد الإلكتروني',
      'wrong-password' => 'كلمة المرور غير صحيحة',
      'user-disabled' => 'تم تعطيل هذا الحساب',
      'invalid-credential' => 'بيانات الدخول غير صحيحة',
      'google-sign-in-cancelled' => 'تم إلغاء تسجيل الدخول بجوجل',
      // Signup
      'email-already-in-use' => 'البريد الإلكتروني مستخدم بالفعل',
      'weak-password' => 'كلمة المرور ضعيفة جداً',
      'operation-not-allowed' => 'التسجيل معطل حالياً',
      // Shared
      'invalid-email' => 'البريد الإلكتروني غير صالح',
      'too-many-requests' => 'محاولات كثيرة، حاول لاحقاً',
      _ => 'حدث خطأ، حاول مرة أخرى',
    };
  }
}
