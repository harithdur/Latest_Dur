import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'firebase_options.dart'; // Akan wujud lepas awak run flutterfire configure

import 'package:project_1/Amira_pages/login.dart';
import 'package:project_1/submain.dart'; // Import fail submain awak

void main() async {
  // 1. Wajib ada sebelum initialize Firebase
  WidgetsFlutterBinding.ensureInitialized();

  // 2. Hubungkan app dengan Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Smart Financial Tracker',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF8B5CF6)),
        useMaterial3: true,
      ),
      // 3. Gunakan StreamBuilder untuk pantau status login
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          // Tunjuk loading indicator jika Firebase sedang semak status
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }

          // Jika pengguna dah login (ada data session), pergi ke SubMain
          if (snapshot.hasData && snapshot.data != null) {
            return const SubMain();
          }

          // Jika belum login atau dah logout, pergi ke LoginPage
          return const LoginPage();
        },
      ),
    );
  }
}