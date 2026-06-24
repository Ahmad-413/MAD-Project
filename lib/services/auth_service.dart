import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/student_model.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  User? get currentUser => _auth.currentUser;
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  Future<String?> signUp({
    required String email,
    required String password,
    required String name,
    required String university,
  }) async {
    try {
      UserCredential result =
      await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      StudentModel student = StudentModel(
        uid: result.user!.uid,
        name: name,
        email: email,
        university: university,
        bio: '',
        profileImage: '',
        skills: [],
        connections: [],
        createdAt: DateTime.now(),
      );
      await _firestore
          .collection('users')
          .doc(result.user!.uid)
          .set(student.toMap());
      return null;
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  Future<String?> login({
    required String email,
    required String password,
  }) async {
    try {
      await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      return null;
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  Future<void> logout() async {
    await _auth.signOut();
  }

  Future<StudentModel?> getStudentData(String uid) async {
    try {
      DocumentSnapshot doc =
      await _firestore.collection('users').doc(uid).get();
      if (doc.exists) {
        return StudentModel.fromMap(
            doc.data() as Map<String, dynamic>);
      }
      return null;
    } catch (e) {
      return null;
    }
  }
}