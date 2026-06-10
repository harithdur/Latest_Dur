import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _notificationsEnabled = true;
  bool _darkMode = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F6),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('Settings', style: GoogleFonts.inter(fontWeight: FontWeight.bold, color: Colors.black)),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _buildSection('Account'),
          _buildItem(Icons.person_outline, 'Edit Profile'),
          _buildItem(Icons.notifications_none, 'Notifications', 
            trailing: Switch(
              value: _notificationsEnabled, 
              onChanged: (v) => setState(() => _notificationsEnabled = v),
              activeColor: Colors.black,
            )
          ),
          const SizedBox(height: 20),
          _buildSection('Preferences'),
          _buildItem(Icons.dark_mode_outlined, 'Dark Mode',
            trailing: Switch(
              value: _darkMode, 
              onChanged: (v) => setState(() => _darkMode = v),
              activeColor: Colors.black,
            )
          ),
          _buildItem(Icons.language, 'Language', trailingText: 'English'),
        ],
      ),
    );
  }

  Widget _buildSection(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      child: Text(title.toUpperCase(), style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.black38)),
    );
  }

  Widget _buildItem(IconData icon, String title, {Widget? trailing, String? trailingText}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
      child: ListTile(
        leading: Icon(icon, color: Colors.black87),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
        trailing: trailing ?? (trailingText != null ? Text(trailingText, style: const TextStyle(color: Colors.black38)) : const Icon(Icons.chevron_right, size: 20)),
      ),
    );
  }
}
