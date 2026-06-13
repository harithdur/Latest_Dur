import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:project_1/auth_service.dart'; // Pastikan path ini menunjuk ke fail auth_service.dart awak

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final AuthService _authService = AuthService();

  // Controllers untuk baca input pengguna
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  // Fungsi untuk memproses pendaftaran
  Future<void> _handleRegister() async {
    // Semak jika semua validation form lulus
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      try {
        // Panggil fungsi register dari auth_service.dart
        await _authService.registerWithEmail(
          name: _nameController.text.trim(),
          email: _emailController.text.trim(),
          phone: _phoneController.text.trim(),
          password: _passwordController.text,
        );

        // Jika berjaya, tutup halaman pendaftaran.
        // StreamBuilder di main.dart akan automatik kesan login dan bawa ke SubMain.
        if (mounted) {
          Navigator.pop(context);
        }

      } on FirebaseAuthException catch (e) {
        // Kendalikan ralat (error handling) dari Firebase
        String errorMessage = 'Pendaftaran gagal. Sila cuba lagi.';

        if (e.code == 'weak-password') {
          errorMessage = 'Kata laluan terlalu lemah. Sila gunakan gabungan yang lebih kuat.';
        } else if (e.code == 'email-already-in-use') {
          errorMessage = 'E-mel ini telah pun didaftarkan.';
        } else if (e.code == 'invalid-email') {
          errorMessage = 'Format e-mel tidak sah.';
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
  void dispose() {
    // Bersihkan memori apabila halaman ditutup
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color(0xFF8B5CF6);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Create Account',
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.black),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                const Text(
                  'Start your smart financial journey today',
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),

                // 1. Field Nama
                TextFormField(
                  controller: _nameController,
                  decoration: _buildInputDecoration('Full Name', Icons.person_outline, primaryColor),
                  validator: (value) => value != null && value.trim().length < 2 ? 'Sila masukkan nama yang sah (min 2 huruf)' : null,
                ),
                const SizedBox(height: 16),

                // 2. Field E-mel
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: _buildInputDecoration('Email Address', Icons.email_outlined, primaryColor),
                  validator: (value) {
                    if (value == null || value.isEmpty) return 'Sila masukkan e-mel';
                    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) return 'Format e-mel tidak sah';
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // 3. Field Nombor Telefon
                TextFormField(
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  decoration: _buildInputDecoration('Phone Number', Icons.phone_outlined, primaryColor),
                  validator: (value) => value != null && value.trim().length < 8 ? 'Sila masukkan nombor telefon yang sah' : null,
                ),
                const SizedBox(height: 16),

                // 4. Field Kata Laluan
                TextFormField(
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  decoration: _buildInputDecoration('Password', Icons.lock_outline, primaryColor).copyWith(
                    suffixIcon: IconButton(
                      icon: Icon(_obscurePassword ? Icons.visibility_off : Icons.visibility, color: Colors.grey),
                      onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                    ),
                  ),
                  validator: (value) => value != null && value.length < 6 ? 'Kata laluan mesti sekurang-kurangnya 6 aksara' : null,
                ),
                const SizedBox(height: 16),

                // 5. Field Sahkan Kata Laluan
                TextFormField(
                  controller: _confirmPasswordController,
                  obscureText: _obscureConfirmPassword,
                  decoration: _buildInputDecoration('Confirm Password', Icons.lock_reset_outlined, primaryColor).copyWith(
                    suffixIcon: IconButton(
                      icon: Icon(_obscureConfirmPassword ? Icons.visibility_off : Icons.visibility, color: Colors.grey),
                      onPressed: () => setState(() => _obscureConfirmPassword = !_obscureConfirmPassword),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) return 'Sila sahkan kata laluan';
                    if (value != _passwordController.text) return 'Kata laluan tidak sepadan';
                    return null;
                  },
                ),
                const SizedBox(height: 32),

                // Butang Register
                SizedBox(
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    onPressed: _isLoading ? null : _handleRegister,
                    child: _isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text('Create Account', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Fungsi pembantu untuk reka bentuk input kotak teks (UI)
  InputDecoration _buildInputDecoration(String label, IconData icon, Color primaryColor) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon, color: Colors.grey),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: primaryColor, width: 2),
      ),
      filled: true,
      fillColor: Colors.grey.shade50,
    );
  }
}