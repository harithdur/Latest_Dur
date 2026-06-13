import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart'; // Pakej intl dari pubspec.yaml untuk format tarikh

class UserProfilePage extends StatelessWidget {
  final VoidCallback onBack;

  // Menerima parameter onBack dari SubMain supaya butang back berfungsi
  const UserProfilePage({super.key, required this.onBack});

  @override
  Widget build(BuildContext context) {
    // Dapatkan maklumat pengguna yang sedang login
    final user = FirebaseAuth.instance.currentUser;
    const Color primaryColor = Color(0xFF8B5CF6);

    if (user == null) {
      return const Center(child: Text('Sila log masuk.'));
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: MouseRegion(
          cursor: SystemMouseCursors.click,
          child: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.black, size: 20),
            onPressed: onBack,
          ),
        ),
        title: const Text('My Profile', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      // StreamBuilder membaca live stream data dari dokumen pengguna
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance.collection('users').doc(user.uid).snapshots(),
        builder: (context, snapshot) {
          // Paparkan loading semasa data sedang ditarik dari server
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: primaryColor));
          }

          if (snapshot.hasError) {
            return const Center(child: Text('Ralat memuatkan profil.'));
          }

          if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Center(child: Text('Data profil tidak dijumpai.'));
          }

          // Ekstrak data dari format Map Firestore
          final data = snapshot.data!.data() as Map<String, dynamic>?;
          final name = data?['name'] ?? '—';
          final email = data?['email'] ?? '—';
          final phone = data?['phone'] ?? '—';
          final Timestamp? createdAtTimestamp = data?['createdAt'];

          // Format tarikh jadi cantik (contoh: 13 Jun 2026)
          String formattedDate = '—';
          if (createdAtTimestamp != null) {
            formattedDate = DateFormat('d MMM yyyy').format(createdAtTimestamp.toDate());
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              children: [
                // Avatar Profil Bulat
                CircleAvatar(
                  radius: 50,
                  backgroundColor: primaryColor.withOpacity(0.1),
                  child: Text(
                    name.isNotEmpty ? name[0].toUpperCase() : '?',
                    style: const TextStyle(fontSize: 40, fontWeight: FontWeight.bold, color: primaryColor),
                  ),
                ),
                const SizedBox(height: 16),
                Text(name, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black)),
                const SizedBox(height: 4),
                Text(email, style: const TextStyle(fontSize: 14, color: Colors.grey)),
                const SizedBox(height: 32),

                // Paparan Kad Maklumat
                _buildProfileItem(Icons.person_outline, 'Full Name', name),
                _buildProfileItem(Icons.email_outlined, 'Email Address', email),
                _buildProfileItem(Icons.phone_outlined, 'Phone Number', phone),
                _buildProfileItem(Icons.calendar_today_outlined, 'Date Registered', formattedDate),
              ],
            ),
          );
        },
      ),
    );
  }

  // Fungsi pembantu untuk reka bentuk UI (Kad Info)
  Widget _buildProfileItem(IconData icon, String title, String value) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFF8B5CF6).withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: const Color(0xFF8B5CF6), size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontSize: 12, color: Colors.grey)),
                const SizedBox(height: 4),
                Text(value, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}