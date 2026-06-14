import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart'; 
import 'package:project_1/Amira_pages/splash_screen.dart'; // Import SplashScreen
import 'package:project_1/Zahida_pages/providers.dart';

// fail: lib/main.dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Gunakan firebase_options.dart yang anda dah generate
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => FinanceProvider()),
      ],
      child: const MyApp(),
    ),
  );
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
      // Mula dengan SplashScreen
      home: const SplashScreen(),
    );
  }
}
