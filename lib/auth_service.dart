import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  // Inisialisasi instance untuk Firebase Auth dan Firestore
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // 1. Fungsi untuk DAFTAR PENGGUNA BARU (Register)
  Future<UserCredential> registerWithEmail({
    required String name,
    required String email,
    required String phone,
    required String password,
  }) async {
    try {
      // Langkah A: Cipta akaun Firebase Auth menggunakan e-mel dan kata laluan
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Langkah B: Simpan nama paparan (display name) ke dalam profil Firebase Auth
      await credential.user!.updateDisplayName(name);

      // Langkah C: Simpan semua butiran profil ke dalam koleksi 'users' di Cloud Firestore
      await _firestore.collection('users').doc(credential.user!.uid).set({
        'name': name,
        'email': email,
        'phone': phone,
        'createdAt': FieldValue.serverTimestamp(), // Tarikh & masa automatik dari server Firebase
      });

      return credential;
    } catch (e) {
      // Tangkap dan pulangkan ralat (error) jika pendaftaran gagal
      rethrow;
    }
  }

  // 2. Fungsi untuk LOG MASUK (Sign In)
  Future<UserCredential> signInWithEmail(String email, String password) async {
    try {
      return await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      rethrow;
    }
  }

  // 3. Fungsi untuk LOG KELUAR (Sign Out)
  Future<void> signOut() async {
    await _auth.signOut();
  }
}