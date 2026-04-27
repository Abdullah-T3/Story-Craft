import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreProfileDatasource {
  FirestoreProfileDatasource({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  static const String _usersCollection = 'users';
  static const String _savedStoriesCollection = 'saved_stories';
  static const String _parentalDoc = 'parental';

  DocumentReference<Map<String, dynamic>> _userDoc(String uid) =>
      _firestore.collection(_usersCollection).doc(uid);

  Future<Map<String, dynamic>?> getUser(String uid) async {
    final snap = await _userDoc(uid).get();
    return snap.data();
  }

  Future<void> updateUser(String uid, Map<String, dynamic> data) async {
    await _userDoc(uid).set({
      ...data,
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  Future<List<Map<String, dynamic>>> getSavedStories({
    required String uid,
    required bool favoritesOnly,
  }) async {
    Query<Map<String, dynamic>> query = _userDoc(
      uid,
    ).collection(_savedStoriesCollection);
    if (favoritesOnly) {
      query = query.where('isFavorite', isEqualTo: true);
    }
    final snap = await query.orderBy('lastOpenedAt', descending: true).get();
    return snap.docs.map((d) => {...d.data(), 'id': d.id}).toList();
  }

  Future<Map<String, dynamic>?> getParental(String uid) async {
    final snap = await _userDoc(
      uid,
    ).collection('settings').doc(_parentalDoc).get();
    return snap.data();
  }

  Future<void> setParental(String uid, Map<String, dynamic> data) async {
    await _userDoc(uid)
        .collection('settings')
        .doc(_parentalDoc)
        .set({...data, 'updatedAt': FieldValue.serverTimestamp()});
  }
}
