import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import 'package:project_1/Amira_pages/login.dart';
import 'package:project_1/Amira_pages/user_registration.dart';
import 'providers.dart';
import 'models.dart';

class UserProfilePage extends StatefulWidget {
  final VoidCallback? onBack;
  const UserProfilePage({super.key, this.onBack});

  @override
  State<UserProfilePage> createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  bool _isEditing = false;
  bool _isLoading = false;

  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _addressController;

  final user = FirebaseAuth.instance.currentUser;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
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

  Future<void> _saveProfileChanges() async {
    if (user != null) {
      setState(() => _isLoading = true);
      try {
        await _firestore.collection('users').doc(user!.uid).update({
          'name': _nameController.text.trim(),
          'phone': _phoneController.text.trim(),
          'address': _addressController.text.trim(),
        });
        await user!.updateDisplayName(_nameController.text.trim());
        setState(() {
          _isEditing = false;
          _isLoading = false;
        });
        _showSuccessPopup();
      } catch (e) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    const Color accentPurple = Color(0xFF8B5CF6);

    // PAPARAN GUEST MODE JIKA USER NULL
    if (user == null) {
      return _buildGuestMode(context, accentPurple);
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
      body: StreamBuilder<DocumentSnapshot>(
        stream: _firestore.collection('users').doc(user!.uid).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: accentPurple));
          }
          if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Center(child: Text('Data profil tidak dijumpai.'));
          }
          final data = snapshot.data!.data() as Map<String, dynamic>?;
          final dbName = data?['name'] ?? '—';
          final dbEmail = data?['email'] ?? '—';
          final dbPhone = data?['phone'] ?? '—';
          final dbAddress = data?['address'] ?? '—';

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
                  child: Text("Personal Information", style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.bold, color: const Color(0xFF1F2937))),
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10)]),
                  child: Column(
                    children: [
                      _buildEditableTile(Icons.person_outline, "Full Name", _nameController),
                      _buildEditableTile(Icons.email_outlined, "Email", _emailController, readOnly: true),
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
                        onPressed: () => setState(() => _isEditing = !_isEditing),
                        style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)), side: BorderSide(color: _isEditing ? Colors.redAccent : accentPurple, width: 1.5)),
                        child: Text(_isEditing ? "Cancel" : "Edit Profile", style: GoogleFonts.inter(color: _isEditing ? Colors.redAccent : accentPurple, fontWeight: FontWeight.bold)),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: !_isEditing || _isLoading ? null : () => _saveProfileChanges(),
                        style: ElevatedButton.styleFrom(backgroundColor: accentPurple, foregroundColor: Colors.white, disabledBackgroundColor: Colors.grey.shade300, padding: const EdgeInsets.symmetric(vertical: 16), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)), elevation: 0),
                        child: _isLoading 
                          ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                          : Text("Save Changes", style: GoogleFonts.inter(fontWeight: FontWeight.bold)),
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

  Widget _buildGuestMode(BuildContext context, Color accentPurple) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: widget.onBack ?? () => Navigator.pop(context),
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(28),
                decoration: BoxDecoration(color: accentPurple.withOpacity(0.1), shape: BoxShape.circle),
                child: Icon(Icons.person_outline_rounded, color: accentPurple, size: 80),
              ).animate().scale(duration: 400.ms, curve: Curves.easeOutBack), 
              
              const SizedBox(height: 32),
              
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  "Join Smart Tracker",
                  style: GoogleFonts.inter(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.black87),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                "Sign in to sync your financial data and unlock all features of the app.",
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(fontSize: 14, color: Colors.black45, height: 1.5),
              ),
              
              const SizedBox(height: 48),
              
              SizedBox(
                width: double.infinity,
                height: 56,
                child: MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const LoginPage()), (route) => false);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: accentPurple,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      elevation: 0,
                    ),
                    child: Text("Log In Now", style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 16)),
                  ),
                ),
              ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.1),
              
              const SizedBox(height: 16),
              
              SizedBox(
                width: double.infinity,
                height: 56,
                child: MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const UserRegistrationPage()));
                    },
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: accentPurple, width: 2),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    ),
                    child: Text("Create Account", style: GoogleFonts.inter(color: accentPurple, fontWeight: FontWeight.bold, fontSize: 16)),
                  ),
                ),
              ).animate().fadeIn(delay: 400.ms).slideY(begin: 0.1),
            ],
          ),
        ),
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
        FittedBox(fit: BoxFit.scaleDown, child: Text(name, style: GoogleFonts.inter(fontSize: 22, fontWeight: FontWeight.bold))),
        Text(email, style: GoogleFonts.inter(color: Colors.grey, fontSize: 14)),
      ],
    ).animate().fadeIn().scale();
  }

  Widget _buildEditableTile(IconData icon, String title, TextEditingController controller, {bool isLast = false, bool readOnly = false}) {
    return Column(
      children: [
        ListTile(
          leading: Container(
            padding: const EdgeInsets.all(10),
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
