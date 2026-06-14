import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'dart:async';
import 'package:project_1/Amira_pages/login.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Tunggu 3.5 saat supaya animasi habis dengan cantik sebelum ke Login
    Timer(const Duration(milliseconds: 3500), () {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) => const LoginPage(),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              return FadeTransition(opacity: animation, child: child);
            },
            transitionDuration: const Duration(milliseconds: 800),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    const Color primaryPurple = Color(0xFF8B5CF6);
    const Color bgDark = Color(0xFF0F172A); // Latar belakang gelap lebih premium

    return Scaffold(
      backgroundColor: bgDark,
      body: Stack(
        children: [
          // Kesan Glow di belakang
          Center(
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: primaryPurple.withOpacity(0.15),
                    blurRadius: 100,
                    spreadRadius: 50,
                  )
                ],
              ),
            ).animate(onPlay: (c) => c.repeat(reverse: true))
             .scale(begin: const Offset(0.8, 0.8), end: const Offset(1.2, 1.2), duration: 2.seconds),
          ),

          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // LOGO DENGAN ANIMASI GABUNGAN
                Container(
                  padding: const EdgeInsets.all(28),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF8B5CF6), Color(0xFF6D28D9)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(35),
                    boxShadow: [
                      BoxShadow(
                        color: primaryPurple.withOpacity(0.3),
                        blurRadius: 25,
                        offset: const Offset(0, 10),
                      )
                    ],
                  ),
                  child: const Icon(
                    Icons.auto_graph_rounded,
                    color: Colors.white,
                    size: 70,
                  ),
                )
                .animate()
                .fadeIn(duration: 800.ms)
                .scale(delay: 200.ms, duration: 800.ms, curve: Curves.elasticOut)
                .then(delay: 200.ms)
                .shimmer(duration: 1500.ms, color: Colors.white24)
                .shake(hz: 2, curve: Curves.easeInOut),

                const SizedBox(height: 40),

                // TEKS JENAMA DENGAN ANIMASI FADE & SLIDE
                Column(
                  children: [
                    Text(
                      'SMART FINANCIAL',
                      style: GoogleFonts.inter(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 4,
                      ),
                    ).animate().fadeIn(delay: 600.ms, duration: 800.ms).slideY(begin: 0.5),
                    
                    const SizedBox(height: 8),
                    
                    Text(
                      'TRACKER',
                      style: GoogleFonts.inter(
                        color: primaryPurple,
                        fontSize: 32,
                        fontWeight: FontWeight.w900,
                        letterSpacing: -1,
                      ),
                    ).animate().fadeIn(delay: 1000.ms, duration: 800.ms).slideY(begin: 0.3),
                  ],
                ),
              ],
            ),
          ),
          
          // LOADING BAR HALUS DI BAWAH
          Positioned(
            bottom: 80,
            left: 100,
            right: 100,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: const LinearProgressIndicator(
                backgroundColor: Colors.white10,
                color: primaryPurple,
                minHeight: 2,
              ),
            ).animate().fadeIn(delay: 1500.ms),
          ),
        ],
      ),
    );
  }
}
