import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// Import fail anda dari folder pages (Dibetulkan)
import 'package:project_1/pages/homepage.dart';
import 'package:project_1/pages/transactions_page.dart';
import 'package:project_1/pages/budget_page.dart';
import 'package:project_1/pages/report_page.dart';
import 'package:project_1/pages/profile_page.dart';
import 'package:project_1/pages/settings_page.dart';

// Import fail kawan anda dari folder lib
import 'package:project_1/pages/income.management.dart';
import 'package:project_1/pages/category.management.dart';

class SubMain extends StatefulWidget {
  const SubMain({super.key});

  @override
  State<SubMain> createState() => _SubMainState();
}

class _SubMainState extends State<SubMain> {
  int _selectedIndex = 0;

  // DATA KATEGORI (Terkongsi antara Dashboard, Income, dan Category Page)
  List<CategoryModel> _sharedCategories = [
    CategoryModel(id: '1', name: 'Food & Dining', icon: '🍔', color: const Color(0xFFFF5722)),
    CategoryModel(id: '2', name: 'Transport', icon: '🚗', color: const Color(0xFF4CAF50)),
    CategoryModel(id: '3', name: 'Shopping', icon: '🛒', color: const Color(0xFF2196F3)),
    CategoryModel(id: '4', name: 'Housing', icon: '🏠', color: const Color(0xFF9C27B0)),
    CategoryModel(id: '5', name: 'Salary', icon: '💰', color: const Color(0xFF8B5CF6)),
    CategoryModel(id: '6', name: 'Freelance', icon: '💻', color: const Color(0xFF00BCD4)),
    CategoryModel(id: '7', name: 'Investment', icon: '📈', color: const Color(0xFFFF9800)),
  ];

  void _updateCategories(List<CategoryModel> newCategories) {
    setState(() {
      _sharedCategories = newCategories;
    });
  }

  @override
  Widget build(BuildContext context) {
    const Color sidebarBg = Color(0xFF111827);

    // Senarai halaman mengikut turutan menu
    final List<Widget> _pages = [
      const HomePage(),         // Index 0
      const TransactionsPage(),  // Index 1
      const BudgetPage(),        // Index 2
      IncomeManagement(categories: _sharedCategories), // Index 3
      CategoryManagementPage(    // Index 4
        categories: _sharedCategories,
        onCategoriesUpdated: _updateCategories,
      ),
      const ReportPage(),        // Index 5
      const ProfilePage(),       // Index 6
      const SettingsPage(),      // Index 7
    ];

    return Scaffold(
      drawer: Drawer(
        width: 280,
        child: Container(
          color: sidebarBg,
          padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildBrandLogo(),
              const SizedBox(height: 40),
              
              _sidebarNavItem(Icons.home_filled, 'Dashboard', 0),
              _sidebarNavItem(Icons.list_alt_rounded, 'Transactions', 1),
              _sidebarNavItem(Icons.account_balance_wallet_rounded, 'Budget', 2),
              
              const Divider(color: Colors.white10, height: 32),
              const Text('MANAGEMENT', 
                style: TextStyle(color: Colors.white30, fontSize: 10, letterSpacing: 1.2)),
              const SizedBox(height: 16),
              
              _sidebarNavItem(Icons.add_chart_rounded, 'Incomes', 3),
              _sidebarNavItem(Icons.category_rounded, 'Categories', 4),
              
              const Divider(color: Colors.white10, height: 32),
              _sidebarNavItem(Icons.bar_chart_rounded, 'Reports', 5),
              _sidebarNavItem(Icons.person_outline_rounded, 'Profile', 6),
              _sidebarNavItem(Icons.settings_outlined, 'Settings', 7),
              
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

  Widget _buildBrandLogo() {
    return Row(
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
    );
  }

  Widget _sidebarNavItem(IconData icon, String label, int index, {bool isLogout = false}) {
    bool isSelected = _selectedIndex == index;
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: InkWell(
        onTap: () {
          if (!isLogout) {
            setState(() => _selectedIndex = index);
            Navigator.pop(context);
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
