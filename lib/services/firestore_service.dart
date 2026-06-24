import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/post_model.dart';
import '../models/student_model.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> createPost(PostModel post) async {
    await _firestore
        .collection('posts')
        .doc(post.postId)
        .set(post.toMap());
  }

  Stream<List<PostModel>> getAllPosts() {
    return _firestore
        .collection('posts')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snap) => snap.docs
        .map((doc) => PostModel.fromMap(doc.data()))
        .toList());
  }

  Stream<List<PostModel>> getUserPosts(String uid) {
    return _firestore
        .collection('posts')
        .where('uid', isEqualTo: uid)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snap) => snap.docs
        .map((doc) => PostModel.fromMap(doc.data()))
        .toList());
  }

  Future<void> toggleLike(String postId, String uid) async {
    DocumentReference ref =
    _firestore.collection('posts').doc(postId);
    DocumentSnapshot doc = await ref.get();
    List likedBy = (doc.data() as Map)['likedBy'] ?? [];
    if (likedBy.contains(uid)) {
      await ref.update({
        'likedBy': FieldValue.arrayRemove([uid]),
        'likes': FieldValue.increment(-1),
      });
    } else {
      await ref.update({
        'likedBy': FieldValue.arrayUnion([uid]),
        'likes': FieldValue.increment(1),
      });
    }
  }

  Stream<List<StudentModel>> getAllStudents() {
    return _firestore.collection('users').snapshots().map((snap) =>
        snap.docs
            .map((doc) => StudentModel.fromMap(doc.data()))
            .toList());
  }

  Future<void> updateProfile(
      String uid, Map<String, dynamic> data) async {
    await _firestore.collection('users').doc(uid).update(data);
  }

  Future<void> connect(String currentUid, String targetUid) async {
    await _firestore.collection('users').doc(currentUid).update({
      'connections': FieldValue.arrayUnion([targetUid]),
    });
  }

  Future<void> disconnect(String currentUid, String targetUid) async {
    await _firestore.collection('users').doc(currentUid).update({
      'connections': FieldValue.arrayRemove([targetUid]),
    });
  }
}