import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreStoriesDatasource {
  FirestoreStoriesDatasource({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  static const _stories = 'stories';
  static const _users = 'users';
  static const _favorites = 'favorites';
  static const _history = 'history';
  static const _featured = 'featured';
  static const _myStories = 'myStories';

  CollectionReference<Map<String, dynamic>> get _storiesRef =>
      _firestore.collection(_stories);

  Future<List<Map<String, dynamic>>> getStories({String? categoryId}) async {
    Query<Map<String, dynamic>> q = _storiesRef;
    if (categoryId != null && categoryId != 'all') {
      q = q.where('categoryId', isEqualTo: categoryId);
    }
    final snap = await q.get();
    return snap.docs.map((d) => {...d.data(), 'id': d.id}).toList();
  }

  Future<Map<String, dynamic>?> getStoryById(String id, {String? uid}) async {
    final doc = await _storiesRef.doc(id).get();
    final data = doc.data();
    if (data != null) return {...data, 'id': doc.id};
    // Fallback: maybe it's a user-authored story under users/{uid}/myStories.
    if (uid != null) {
      final mine = await _firestore
          .collection(_users)
          .doc(uid)
          .collection(_myStories)
          .doc(id)
          .get();
      final m = mine.data();
      if (m != null) return {...m, 'id': mine.id};
    }
    return null;
  }

  Future<List<Map<String, dynamic>>> getByIds(List<String> ids) async {
    if (ids.isEmpty) return const [];
    final results = <Map<String, dynamic>>[];
    // Firestore "whereIn" supports max 30 items per query.
    for (var i = 0; i < ids.length; i += 30) {
      final chunk = ids.sublist(i, (i + 30).clamp(0, ids.length));
      final snap = await _storiesRef
          .where(FieldPath.documentId, whereIn: chunk)
          .get();
      results.addAll(
        snap.docs.map((d) => {...d.data(), 'id': d.id}),
      );
    }
    return results;
  }

  Future<String?> getStoryOfTheDayId() async {
    final doc = await _firestore
        .collection(_featured)
        .doc('storyOfTheDay')
        .get();
    return doc.data()?['storyId'] as String?;
  }

  Future<List<Map<String, dynamic>>> searchStories(String query) async {
    final lowered = query.toLowerCase();
    if (lowered.isEmpty) return const [];
    final snap = await _storiesRef
        .orderBy('titleLower')
        .startAt([lowered])
        .endAt(['$lowered'])
        .limit(40)
        .get();
    return snap.docs.map((d) => {...d.data(), 'id': d.id}).toList();
  }

  // ── User-scoped ────────────────────────────────────────────────────────────

  Future<List<String>> getFavoriteIds(String uid) async {
    final snap = await _firestore
        .collection(_users)
        .doc(uid)
        .collection(_favorites)
        .get();
    return snap.docs.map((d) => d.id).toList();
  }

  Future<bool> isFavorite(String uid, String storyId) async {
    final doc = await _firestore
        .collection(_users)
        .doc(uid)
        .collection(_favorites)
        .doc(storyId)
        .get();
    return doc.exists;
  }

  Future<bool> toggleFavorite(String uid, String storyId) async {
    final ref = _firestore
        .collection(_users)
        .doc(uid)
        .collection(_favorites)
        .doc(storyId);
    final exists = (await ref.get()).exists;
    if (exists) {
      await ref.delete();
      return false;
    }
    await ref.set({'addedAt': FieldValue.serverTimestamp()});
    return true;
  }

  Future<Map<String, dynamic>?> getProgress(String uid, String storyId) async {
    final doc = await _firestore
        .collection(_users)
        .doc(uid)
        .collection(_history)
        .doc(storyId)
        .get();
    return doc.data();
  }

  Future<void> saveProgress(
    String uid,
    String storyId,
    Map<String, dynamic> data,
  ) async {
    await _firestore
        .collection(_users)
        .doc(uid)
        .collection(_history)
        .doc(storyId)
        .set({
          ...data,
          'lastOpenedAt': FieldValue.serverTimestamp(),
        }, SetOptions(merge: true));
  }

  Future<List<Map<String, dynamic>>> getHistory(String uid) async {
    final snap = await _firestore
        .collection(_users)
        .doc(uid)
        .collection(_history)
        .orderBy('lastOpenedAt', descending: true)
        .get();
    return snap.docs.map((d) => {...d.data(), 'storyId': d.id}).toList();
  }

  // ── Authoring ──────────────────────────────────────────────────────────────

  Future<String> createMyStory(String uid, Map<String, dynamic> data) async {
    final batch = _firestore.batch();
    final storyRef = _firestore
        .collection(_users)
        .doc(uid)
        .collection(_myStories)
        .doc();
    batch.set(storyRef, {
      ...data,
      'authorId': uid,
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    });
    final userRef = _firestore.collection(_users).doc(uid);
    batch.set(userRef, {
      'storiesWritten': FieldValue.increment(1),
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
    await batch.commit();
    return storyRef.id;
  }

  Future<List<Map<String, dynamic>>> getMyStories(String uid) async {
    final snap = await _firestore
        .collection(_users)
        .doc(uid)
        .collection(_myStories)
        .orderBy('createdAt', descending: true)
        .get();
    return snap.docs.map((d) => {...d.data(), 'id': d.id}).toList();
  }
}
