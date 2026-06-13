import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Tambahan Firebase
import 'package:project_1/auth_service.dart'; // Tambahan AuthService

class UserRegistrationPage extends StatefulWidget {
  const UserRegistrationPage({super.key});

  @override
  State<UserRegistrationPage> createState() => _UserRegistrationPageState();
}

class _UserRegistrationPageState extends State<UserRegistrationPage> {
  final _formKey = GlobalKey<FormState>();
  final AuthService _authService = AuthService(); // Tambahan instance AuthService

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  final Color bgDark = const Color(0xFF071129);
  final Color secondaryDark = const Color(0xFF0D1735);
  final Color accentPurple = const Color(0xFF8B5CF6);
  final Color accentPurpleEnd = const Color(0xFFA855F7);
  final Color textGrey = const Color(0xFF94A3B8);

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _isLoading = false; // Tambahan state loading

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _dobController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  // Wayar Firebase dimasukkan di sini
  Future<void> _registerUser() async {
    if (_formKey.currentState!.validate()) {
      // Check extra untuk sahkan kata laluan
      if (_passwordController.text != _confirmPasswordController.text) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Passwords do not match'), backgroundColor: Colors.red),
        );
        return;
      }

      setState(() => _isLoading = true);

      try {
        await _authService.registerWithEmail(
          name: _nameController.text.trim(),
          email: _emailController.text.trim(),
          phone: _phoneController.text.trim(),
          password: _passwordController.text,
        );

        if (mounted) {
          // Tutup page register bila berjaya, StreamBuilder di main.dart akan detect dan bawa ke SubMain
          Navigator.pop(context);
        }

      } on FirebaseAuthException catch (e) {
        String errorMessage = 'Registration failed. Please try again.';
        if (e.code == 'weak-password') {
          errorMessage = 'The password provided is too weak.';
        } else if (e.code == 'email-already-in-use') {
          errorMessage = 'The account already exists for that email.';
        } else if (e.code == 'invalid-email') {
          errorMessage = 'Invalid email format.';
        }

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(errorMessage), backgroundColor: Colors.red),
          );
        }
      } finally {
        if (mounted) {
          setState(() => _isLoading = false);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgDark,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [bgDark, secondaryDark],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
              child: Container(
                constraints: const BoxConstraints(maxWidth: 450),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: accentPurple.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.auto_graph_rounded, color: accentPurple, size: 40),
                    ),
                    const SizedBox(height: 20),
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      child: const Text(
                        'Create Account',
                        style: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text('Sign up to get started', style: TextStyle(color: textGrey, fontSize: 16)),
                    const SizedBox(height: 40),
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.03),
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
                      ),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            _buildTextField(
                              controller: _nameController,
                              label: 'Full Name', hint: 'Enter your full name', icon: Icons.person_outline,
                              validator: (value) => value!.isEmpty ? 'Name is required' : null,
                            ),
                            _buildTextField(
                              controller: _emailController,
                              label: 'Email', hint: 'name@example.com', icon: Icons.email_outlined,
                              validator: (value) => value!.isEmpty ? 'Email is required' : null,
                            ),
                            _buildTextField(
                              controller: _dobController,
                              label: 'Date of Birth',
                              hint: 'DD/MM/YYYY',
                              icon: Icons.calendar_today_outlined,
                              onTap: () async {
                                DateTime? picked = await showDatePicker(
                                  context: context,
                                  initialDate: DateTime(2000),
                                  firstDate: DateTime(1900),
                                  lastDate: DateTime.now(),
                                );
                                if (picked != null) {
                                  setState(() {
                                    _dobController.text = "${picked.day.toString().padLeft(2, '0')}/${picked.month.toString().padLeft(2, '0')}/${picked.year}";
                                  });
                                }
                              },
                            ),
                            _buildTextField(
                              controller: _phoneController,
                              label: 'Phone Number', hint: '+60 12-3456789', icon: Icons.phone_android_outlined,
                              validator: (value) => value!.isEmpty ? 'Phone number is required' : null,
                            ),
                            _buildTextField(
                              controller: _passwordController,
                              label: 'Password',
                              hint: 'Enter password',
                              icon: Icons.lock_outline,
                              isPassword: true,
                              obscure: _obscurePassword,
                              onToggle: () => setState(() => _obscurePassword = !_obscurePassword),
                              validator: (value) => value != null && value.length < 6 ? 'Min 6 characters' : null,
                            ),
                            _buildTextField(
                              controller: _confirmPasswordController,
                              label: 'Confirm Password',
                              hint: 'Confirm password',
                              icon: Icons.shield_outlined,
                              isPassword: true,
                              obscure: _obscureConfirmPassword,
                              onToggle: () => setState(() => _obscureConfirmPassword = !_obscureConfirmPassword),
                              validator: (value) => value!.isEmpty ? 'Confirm your password' : null,
                            ),
                            const SizedBox(height: 20),
                            Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(colors: [accentPurple, accentPurpleEnd]),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: ElevatedButton(
                                onPressed: _isLoading ? null : _registerUser,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.transparent,
                                  shadowColor: Colors.transparent,
                                  padding: const EdgeInsets.symmetric(vertical: 18),
                                ),
                                // Tukar jadi bulatan loading kalau tengah proses
                                child: _isLoading
                                    ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                                    : const Text('Sign Up', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text('Already have an account? Login', style: TextStyle(color: accentPurple, fontWeight: FontWeight.w600)),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    bool isPassword = false,
    bool obscure = false,
    VoidCallback? onToggle,
    VoidCallback? onTap,
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: TextStyle(color: textGrey, fontWeight: FontWeight.w500, fontSize: 13)),
          const SizedBox(height: 8),
          TextFormField(
            controller: controller,
            obscureText: obscure,
            validator: validator,
            readOnly: onTap != null,
            onTap: onTap,
            style: const TextStyle(color: Colors.white, fontSize: 14),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(color: textGrey.withValues(alpha: 0.3)),
              prefixIcon: Icon(icon, color: textGrey, size: 20),
              suffixIcon: isPassword
                  ? IconButton(icon: Icon(obscure ? Icons.visibility_off : Icons.visibility, color: textGrey, size: 20), onPressed: onToggle)
                  : null,
              filled: true,
              fillColor: Colors.white.withValues(alpha: 0.05),
              isDense: true,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
              enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.1))),
              focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide(color: accentPurple, width: 2)),
            ),
          ),
        ],
      ),
    );
  }
}