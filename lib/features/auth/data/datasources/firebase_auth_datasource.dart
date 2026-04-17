import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:story_craft/core/services/cloudinary/cloudinary_service.dart';
import 'package:story_craft/features/auth/data/datasources/firestore_user_datasource.dart';
import 'package:story_craft/features/auth/domain/entities/app_user.dart';
import 'package:story_craft/features/auth/domain/entities/sign_up_data.dart';

class FirebaseAuthDatasource {
  FirebaseAuthDatasource({
    required FirestoreUserDatasource firestoreUserDatasource,
    required CloudinaryService cloudinaryService,
    FirebaseAuth? firebaseAuth,
    GoogleSignIn? googleSignIn,
  }) : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
       _googleSignIn = googleSignIn ?? GoogleSignIn(),
       _firestoreUserDatasource = firestoreUserDatasource,
       _cloudinaryService = cloudinaryService;

  final FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;
  final FirestoreUserDatasource _firestoreUserDatasource;
  final CloudinaryService _cloudinaryService;

  Future<AppUser> loginWithEmail({
    required String email,
    required String password,
  }) async {
    final credential = await _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    return _mapUser(credential.user!);
  }

  Future<AppUser> loginWithGoogle() async {
    final googleUser = await _googleSignIn.signIn();
    if (googleUser == null) {
      throw FirebaseAuthException(
        code: 'google-sign-in-cancelled',
        message: 'تم إلغاء تسجيل الدخول بجوجل',
      );
    }

    final googleAuth = await googleUser.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final userCredential = await _firebaseAuth.signInWithCredential(credential);
    return _mapUser(userCredential.user!);
  }

  Future<void> resetPassword({required String email}) async {
    await _firebaseAuth.sendPasswordResetEmail(email: email);
  }

  Future<void> logout() async {
    await Future.wait([_firebaseAuth.signOut(), _googleSignIn.signOut()]);
  }

  AppUser? get currentUser {
    final user = _firebaseAuth.currentUser;
    if (user == null) return null;
    return _mapUser(user);
  }

  Future<SignUpData> signUp({required SignUpData signUpData}) async {
    final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
      email: signUpData.email,
      password: signUpData.password,
    );

    final user = userCredential.user;
    if (user == null) {
      throw FirebaseAuthException(
        code: 'unknown',
        message: 'Failed to create user',
      );
    }

    await user.updateDisplayName(signUpData.name);

    var photoUrl = signUpData.photoUrl;
    final localPath = signUpData.localPhotoPath;
    if (localPath != null && localPath.isNotEmpty) {
      photoUrl = await _cloudinaryService.uploadImage(File(localPath));
      await user.updatePhotoURL(photoUrl);
    }

    await _firestoreUserDatasource.createUser(
      uid: user.uid,
      name: signUpData.name,
      email: signUpData.email,
      childName: signUpData.childName,
      ageCategory: signUpData.ageCategory,
      photoUrl: photoUrl,
    );

    return signUpData.copyWith(photoUrl: photoUrl);
  }

  Future<bool> isEmailRegistered(String email) async {
    try {
      final methods = await _firebaseAuth.fetchSignInMethodsForEmail(email);
      return methods.isNotEmpty;
    } on FirebaseAuthException catch (_) {
      return false;
    }
  }

  AppUser _mapUser(User user) {
    return AppUser(
      uid: user.uid,
      email: user.email ?? '',
      displayName: user.displayName,
      photoUrl: user.photoURL,
    );
  }
}
