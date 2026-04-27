import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreNotificationsDatasource {
  FirestoreNotificationsDatasource({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> _ref(String uid) =>
      _firestore.collection('users').doc(uid).collection('notifications');

  Future<List<Map<String, dynamic>>> getAll(String uid) async {
    final snap = await _ref(uid).orderBy('createdAt', descending: true).get();
    return snap.docs.map((d) => {...d.data(), 'id': d.id}).toList();
  }

  Future<int> getUnreadCount(String uid) async {
    final snap = await _ref(uid).where('isRead', isEqualTo: false).count().get();
    return snap.count ?? 0;
  }

  Future<void> markRead(String uid, String id) async {
    await _ref(uid).doc(id).update({'isRead': true});
  }

  Future<void> markAllRead(String uid) async {
    final snap = await _ref(uid).where('isRead', isEqualTo: false).get();
    final batch = _firestore.batch();
    for (final d in snap.docs) {
      batch.update(d.reference, {'isRead': true});
    }
    await batch.commit();
  }
}
