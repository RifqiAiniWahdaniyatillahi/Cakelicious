import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthService extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? user;
  String? lastError;

  AuthService() {
    _auth.authStateChanges().listen((u) {
      user = u;
      notifyListeners();
    });
  }

  // ================= LOGIN =================
  Future<bool> login(String email, String password) async {
    try {
      lastError = null;
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      return true;
    } on FirebaseAuthException catch (e) {
      lastError = _translateError(e.code);
      return false;
    }
  }

  // ================= REGISTER =================
  Future<bool> register(String name, String email, String password) async {
    try {
      lastError = null;
      final cred = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      await cred.user?.updateDisplayName(name);
      return true;
    } on FirebaseAuthException catch (e) {
      lastError = _translateError(e.code);
      return false;
    }
  }

  Future<void> logout() async {
    await _auth.signOut();
  }

  // ================= ERROR TRANSLATION =================
  String _translateError(String code) {
    switch (code) {
      case 'user-not-found':
        return 'Email tidak terdaftar';
      case 'wrong-password':
        return 'Password salah';
      case 'email-already-in-use':
        return 'Email sudah digunakan';
      case 'weak-password':
        return 'Password terlalu lemah (min. 6 karakter)';
      case 'invalid-email':
        return 'Format email tidak valid';
      default:
        return 'Terjadi kesalahan, coba lagi';
    }
  }
}
