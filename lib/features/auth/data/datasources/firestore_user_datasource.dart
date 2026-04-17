import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreUserDatasource {
  FirestoreUserDatasource({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  static const String _collection = 'users';

  Future<void> createUser({
    required String uid,
    required String name,
    required String email,
    required String childName,
    required String ageCategory,
    required String photoUrl,
  }) async {
    final now = FieldValue.serverTimestamp();
    await _firestore.collection(_collection).doc(uid).set({
      'uid': uid,
      'name': name,
      'email': email,
      'childName': childName,
      'ageCategory': ageCategory,
      'photoUrl': photoUrl,
      'createdAt': now,
      'updatedAt': now,
    });
  }
}
