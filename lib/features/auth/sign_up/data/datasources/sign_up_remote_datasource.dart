import 'package:firebase_auth/firebase_auth.dart';
import 'package:story_craft/features/auth/sign_up/domain/entities/sign_up_data.dart';

class SignUpRemoteDatasource {
  SignUpRemoteDatasource({
    FirebaseAuth? firebaseAuth,
  }) : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance;

  final FirebaseAuth _firebaseAuth;

  Future<SignUpData> signUp({
    required SignUpData signUpData,
  }) async {
    final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
      email: signUpData.email,
      password: signUpData.password,
    );

    await userCredential.user?.updateDisplayName(signUpData.name);

    return signUpData;
  }

  Future<bool> isEmailRegistered(String email) async {
    try {
      final methods = await _firebaseAuth.fetchSignInMethodsForEmail(email);
      return methods.isNotEmpty;
    } on FirebaseAuthException catch (_) {
      return false;
    }
  }
}
