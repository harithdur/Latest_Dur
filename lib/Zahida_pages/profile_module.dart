import 'package:flutter/material.dart';

class ProfileModule extends StatelessWidget {
  final double income;
  const ProfileModule({super.key, required this.income});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text("User Profile", style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            const SizedBox(height: 20),
            Center(
              child: Column(
                children: [
                  const CircleAvatar(
                    radius: 50,
                    backgroundColor: Color(0xFF8B5CF6),
                    child: Text("AH", style: TextStyle(fontSize: 32, color: Colors.white, fontWeight: FontWeight.bold)),
                  ),
                  const SizedBox(height: 16),
                  const Text("Aiman Hakim", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  const Text("Premium Member", style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w500)),
                ],
              ),
            ),
            const SizedBox(height: 30),
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              elevation: 0,
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("Monthly Income", style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w500)),
                        _buildDropdown(),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text("RM ${income.toStringAsFixed(2)}", 
                      style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Color(0xFF8B5CF6))),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              elevation: 0,
              color: Colors.white,
              child: Column(
                children: [
                  _infoTile("Full Name", "Aiman Hakim"),
                  _divider(),
                  _infoTile("Email", "aiman@email.com"),
                  _divider(),
                  _infoTile("Phone Number", "012-345 6789"),
                  _divider(),
                  _infoTile("Date of Birth", "12 May 1995"),
                  _divider(),
                  _infoTile("Address", "Kuala Lumpur, Malaysia"),
                ],
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildDropdown() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Row(
        children: [
          Text("RM Ringgit Malaysia", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
          Icon(Icons.arrow_drop_down, size: 18),
        ],
      ),
    );
  }

  Widget _infoTile(String title, String value) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      title: Text(title, style: const TextStyle(fontSize: 12, color: Colors.grey, fontWeight: FontWeight.w500)),
      subtitle: Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black)),
      trailing: const Icon(Icons.chevron_right, color: Colors.grey),
    );
  }

  Widget _divider() => const Divider(height: 1, indent: 20, endIndent: 20, color: Color(0xFFF1F5F9));
}
