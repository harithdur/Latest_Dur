import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project_1/homepage.dart';
import 'package:project_1/transactions_page.dart';
import 'package:project_1/Budget.dart';
import 'package:project_1/report_page.dart';
import 'package:project_1/profile_page.dart';
import 'package:project_1/settings_page.dart';

class SubMain extends StatefulWidget {
  const SubMain({super.key});

  @override
  State<SubMain> createState() => _SubMainState();
}

class _SubMainState extends State<SubMain> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const HomePage(),
    const TransactionsPage(),
    const BudgetPage(),
    const ReportPage(),
    const ProfilePage(),
    const SettingsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    const Color sidebarBg = Color(0xFF111827);

    return Scaffold(
      drawer: Drawer(
        width: 280,
        child: Container(
          color: sidebarBg,
          padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Logo / Brand Name
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF8B5CF6), Color(0xFF6D28D9)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.auto_graph_rounded, color: Colors.white, size: 24),
                  ),
                  const SizedBox(width: 14),
                  Text(
                    'Smart Financial\nTracker',
                    style: GoogleFonts.inter(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                      height: 1.1,
                      letterSpacing: -0.2,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 60),
              _sidebarNavItem(Icons.home_filled, 'Dashboard', 0),
              _sidebarNavItem(Icons.list_alt_rounded, 'Transactions', 1),
              _sidebarNavItem(Icons.account_balance_wallet_rounded, 'Budget', 2),
              _sidebarNavItem(Icons.bar_chart_rounded, 'Reports', 3),
              _sidebarNavItem(Icons.person_outline_rounded, 'Profile', 4),
              _sidebarNavItem(Icons.settings_outlined, 'Settings', 5),
              const SizedBox(height: 32),
              
              const Spacer(),
              _sidebarNavItem(Icons.logout_rounded, 'Logout', 99, isLogout: true),
            ],
          ),
        ),
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
    );
  }

  Widget _sidebarNavItem(IconData icon, String label, int index, {bool isLogout = false}) {
    bool isSelected = _selectedIndex == index;
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: InkWell(
        onTap: () {
          if (!isLogout) {
            setState(() => _selectedIndex = index);
            Navigator.pop(context); // Close drawer
          }
        },
        child: Row(
          children: [
            Icon(icon,
              color: isLogout ? Colors.redAccent : (isSelected ? Colors.white : Colors.white54),
              size: 22
            ),
            const SizedBox(width: 16),
            Text(
              label,
              style: GoogleFonts.inter(
                color: isLogout ? Colors.redAccent : (isSelected ? Colors.white : Colors.white54),
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                fontSize: 15,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
