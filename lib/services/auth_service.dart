import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/user_model.dart';

class AuthService {
  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;

  AuthService(this._auth, this._firestore);

  Future<AppUser> login(String email, String password) async {
    final credential = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    final doc = await _firestore
        .collection('users')
        .doc(credential.user!.uid)
        .get();

    return AppUser.fromMap(
      credential.user!.uid,
      doc.data()!,
    );
  }

  Future<AppUser> register(
    String email,
    String password,
    String role,
  ) async {
    final credential = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    final user = AppUser(
      uid: credential.user!.uid,
      email: email,
      role: role,
    );

    await _firestore
        .collection('users')
        .doc(user.uid)
        .set(user.toMap());

    return user;
  }

  Future<void> logout() async {
    await _auth.signOut();
  }
}