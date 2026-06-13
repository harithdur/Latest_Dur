import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';

class UserProfilePage extends StatefulWidget {
  final VoidCallback? onBack;
  const UserProfilePage({super.key, this.onBack});

  @override
  State<UserProfilePage> createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  bool _isEditing = false;

  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _addressController;

  final user = FirebaseAuth.instance.currentUser;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    // Initialize controllers with empty strings first
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _phoneController = TextEditingController();
    _addressController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  void _showSuccessPopup() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        elevation: 0,
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        content: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: const Color(0xFF10B981),
            borderRadius: BorderRadius.circular(20),
            boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 10, offset: Offset(0, 4))],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.check_circle, color: Colors.white, size: 28),
              const SizedBox(width: 12),
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text("Success!", style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white)),
                    Text("Profile updated successfully", style: GoogleFonts.inter(fontSize: 12, color: Colors.white)),
                  ],
                ),
              ),
            ],
          ),
        ).animate().fadeIn(duration: 300.ms).slideY(begin: 0.5),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  // Fungsi simpan data ke Firebase bila user tekan Save Changes
  Future<void> _saveProfileChanges() async {
    if (user != null) {
      try {
        await _firestore.collection('users').doc(user!.uid).update({
          'name': _nameController.text.trim(),
          'phone': _phoneController.text.trim(),
          'address': _addressController.text.trim(),
        });

        // Update display name di Firebase Auth juga
        await user!.updateDisplayName(_nameController.text.trim());

        setState(() => _isEditing = false);
        _showSuccessPopup();
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error updating profile: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    const Color accentPurple = Color(0xFF8B5CF6);

    if (user == null) {
      return const Scaffold(body: Center(child: Text("Sila log masuk.")));
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: Text("My Profile", style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: widget.onBack ?? () => Navigator.pop(context),
        ),
      ),
      // StreamBuilder membaca live data dari Firestore
      body: StreamBuilder<DocumentSnapshot>(
        stream: _firestore.collection('users').doc(user!.uid).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: accentPurple));
          }

          if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Center(child: Text('Data profil tidak dijumpai.'));
          }

          // Dapatkan data dari Firestore
          final data = snapshot.data!.data() as Map<String, dynamic>?;
          final dbName = data?['name'] ?? '—';
          final dbEmail = data?['email'] ?? '—';
          final dbPhone = data?['phone'] ?? '—';
          final dbAddress = data?['address'] ?? '—';

          // Jika tak tengah edit, sentiasa pastikan text box ikut data database terkini
          if (!_isEditing) {
            _nameController.text = dbName;
            _emailController.text = dbEmail;
            _phoneController.text = dbPhone;
            _addressController.text = dbAddress == '—' ? '' : dbAddress;
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 100),
            child: Column(
              children: [
                _buildProfileHeader(dbName, dbEmail, accentPurple),
                const SizedBox(height: 32),

                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Personal Information",
                    style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.bold, color: const Color(0xFF1F2937)),
                  ),
                ),
                const SizedBox(height: 16),

                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10)],
                  ),
                  child: Column(
                    children: [
                      _buildEditableTile(Icons.person_outline, "Full Name", _nameController),
                      _buildEditableTile(Icons.email_outlined, "Email", _emailController, readOnly: true), // Email tak boleh edit
                      _buildEditableTile(Icons.phone_android, "Phone Number", _phoneController),
                      _buildEditableTile(Icons.home_outlined, "Address", _addressController, isLast: true),
                    ],
                  ),
                ),

                const SizedBox(height: 40),

                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          setState(() => _isEditing = !_isEditing);
                        },
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                          side: BorderSide(color: _isEditing ? Colors.redAccent : accentPurple, width: 1.5),
                        ),
                        child: Text(
                          _isEditing ? "Cancel" : "Edit Profile",
                          style: GoogleFonts.inter(color: _isEditing ? Colors.redAccent : accentPurple, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: !_isEditing ? null : () => _saveProfileChanges(),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: accentPurple,
                          foregroundColor: Colors.white,
                          disabledBackgroundColor: Colors.grey.shade300,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                          elevation: 0,
                        ),
                        child: const Text("Save Changes", style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildProfileHeader(String name, String email, Color color) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: color, width: 2)),
          child: CircleAvatar(
            radius: 50,
            backgroundColor: color.withOpacity(0.1),
            child: Text(
              name.isNotEmpty ? name[0].toUpperCase() : '?',
              style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold, color: color),
            ),
          ),
        ),
        const SizedBox(height: 16),
        Text(name, style: GoogleFonts.inter(fontSize: 22, fontWeight: FontWeight.bold)),
        Text(email, style: GoogleFonts.inter(color: Colors.grey, fontSize: 14)),
      ],
    ).animate().fadeIn().scale();
  }

  Widget _buildEditableTile(IconData icon, String title, TextEditingController controller, {bool isLast = false, bool readOnly = false}) {
    return Column(
      children: [
        ListTile(
          leading: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: const Color(0xFFF3F4F6), borderRadius: BorderRadius.circular(12)),
            child: Icon(icon, color: const Color(0xFF8B5CF6), size: 20),
          ),
          title: Text(title, style: GoogleFonts.inter(color: Colors.grey, fontSize: 11, fontWeight: FontWeight.w500)),
          subtitle: _isEditing && !readOnly
              ? TextField(
            controller: controller,
            style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 15),
            decoration: InputDecoration(
                hintText: 'Enter $title',
                isDense: true,
                border: InputBorder.none,
                contentPadding: const EdgeInsets.only(top: 4)
            ),
          )
              : Text(
              controller.text.isEmpty ? '—' : controller.text,
              style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 15, color: readOnly ? Colors.grey : const Color(0xFF1F2937))
          ),
        ),
        if (!isLast) Divider(height: 1, color: Colors.grey.shade100, indent: 70),
      ],
    );
  }
}