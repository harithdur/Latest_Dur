import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:firebase_auth/firebase_auth.dart'; // <-- 1. Tambah import Firebase Auth di sini

// Import fail Dur
import 'package:project_1/Dur_pages/homepage.dart';
import 'package:project_1/Dur_pages/transactions_page.dart';
import 'package:project_1/Dur_pages/budget_page.dart';
import 'package:project_1/Dur_pages/report_page.dart';
import 'package:project_1/Dur_pages/settings_page.dart';

// Import fail Amira
import 'package:project_1/Amira_pages/income.management.dart';
import 'package:project_1/Amira_pages/category.management.dart';

// Import komponen Zaim
import 'package:project_1/Zaim_pages/add_goal.dart';
import 'package:project_1/Zaim_pages/insights.dart';
import 'package:project_1/Zaim_pages/notifications.dart';

// Import fail Zahida
import 'package:project_1/Zahida_pages/expenses_management.dart';
import 'package:project_1/Zahida_pages/recurring_transactions.dart';
import 'package:project_1/Zahida_pages/user_profile.dart';
import 'package:project_1/Zahida_pages/providers.dart';

// --- MODEL GOAL ---
class Goal {
  final String title;
  final double targetAmount;
  double savedAmount;
  final Color color;
  final IconData icon;

  Goal({
    required this.title,
    required this.targetAmount,
    required this.savedAmount,
    required this.color,
    required this.icon,
  });

  double get progress => (targetAmount > 0) ? (savedAmount / targetAmount).clamp(0.0, 1.0) : 0.0;
}

class SubMain extends StatefulWidget {
  const SubMain({super.key});

  @override
  State<SubMain> createState() => _SubMainState();
}

class _SubMainState extends State<SubMain> {
  int _selectedIndex = 0;

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
    setState(() => _sharedCategories = newCategories);
  }

  void _goToDashboard() {
    setState(() => _selectedIndex = 0);
  }

  @override
  void initState() {
    super.initState();
    // Panggil fungsi untuk mula mendengar data dari Firebase sebaik sahaja app buka
    Future.microtask(() {
      Provider.of<FinanceProvider>(context, listen: false).listenToExpenses();
    });
  }

  @override
  Widget build(BuildContext context) {
    const Color sidebarBg = Color(0xFF111827);

    return ChangeNotifierProvider(
      create: (context) => FinanceProvider(),
      child: Scaffold(
        drawer: Drawer(
          width: 280,
          child: Container(
            color: sidebarBg,
            padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildBrandLogo().animate().fadeIn(duration: 300.ms).slideX(begin: -0.1),
                const SizedBox(height: 25),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: AnimateList(
                      interval: 20.ms,
                      effects: [FadeEffect(duration: 200.ms), SlideEffect(begin: const Offset(-0.05, 0))],
                      children: [
                        _sidebarNavItem(Icons.home_filled, 'Dashboard', 0),
                        _sidebarNavItem(Icons.list_alt_rounded, 'Transactions', 1),
                        _sidebarNavItem(Icons.add_chart_rounded, 'Incomes', 2),
                        _sidebarNavItem(Icons.money_off_rounded, 'Expenses', 3),
                        _sidebarNavItem(Icons.event_repeat_rounded, 'Recurring Bills', 4),
                        _sidebarNavItem(Icons.account_balance_wallet_rounded, 'Budget', 5),
                        _sidebarNavItem(Icons.track_changes_rounded, 'Financial Goals', 6),
                        _sidebarNavItem(Icons.category_rounded, 'Categories', 7),
                        _sidebarNavItem(Icons.bar_chart_rounded, 'Reports', 8),
                        _sidebarNavItem(Icons.person_outline_rounded, 'Profile', 9),
                        _sidebarNavItem(Icons.settings_outlined, 'Settings', 10),
                      ],
                    ),
                  ),
                ),
                _sidebarNavItem(Icons.logout_rounded, 'Logout', 99, isLogout: true).animate().fadeIn(delay: 400.ms),
              ],
            ),
          ),
        ),
        body: IndexedStack(
          index: _selectedIndex,
          children: [
            // Dashboard (Index 0)
            HomePage(onNavigate: (index) {
              setState(() => _selectedIndex = index); // Gunakan index terus
            }),
            TransactionsPage(onBack: _goToDashboard), // Index 1
            IncomeManagement(categories: _sharedCategories, onBack: _goToDashboard), // Index 2
            ExpenseManagementPage(onBack: _goToDashboard), // Index 3
            RecurringTransactionsPage(onBack: _goToDashboard), // Index 4
            BudgetPage(onBack: _goToDashboard), // Index 5
            GoalsPage(onBack: _goToDashboard), // Index 6
            CategoryManagementPage(
              categories: _sharedCategories,
              onCategoriesUpdated: _updateCategories,
              onBack: _goToDashboard,
            ), // Index 7
            ReportPage(onBack: _goToDashboard), // Index 8
            UserProfilePage(onBack: _goToDashboard), // Index 9
            SettingsPage(onBack: _goToDashboard), // Index 10
          ].map((page) => page.animate(key: ValueKey(_selectedIndex))
              .fadeIn(duration: 200.ms, curve: Curves.easeOut)
              .scale(begin: const Offset(0.99, 0.99), duration: 200.ms, curve: Curves.easeOut)
          ).toList(),
        ),
      ),
    );
  }

  Widget _buildBrandLogo() {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            gradient: const LinearGradient(colors: [Color(0xFF8B5CF6), Color(0xFF6D28D9)]),
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Icon(Icons.auto_graph_rounded, color: Colors.white, size: 20),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text('Smart Financial\nTracker',
              style: GoogleFonts.inter(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w900, height: 1.1, letterSpacing: -0.2),
              overflow: TextOverflow.ellipsis),
        ),
      ],
    );
  }

  Widget _sidebarNavItem(IconData icon, String label, int index, {bool isLogout = false}) {
    bool isSelected = _selectedIndex == index;
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: InkWell(
        mouseCursor: SystemMouseCursors.click,
        // <-- 2. Jadikan fungsi ini async dan kemas kini fungsi Logout
        onTap: () async {
          if (!isLogout) {
            setState(() => _selectedIndex = index);
            Navigator.pop(context);
          } else {
            await FirebaseAuth.instance.signOut(); // Gunakan fungsi Firebase untuk logout
          }
        },
        child: Row(
          children: [
            Icon(icon, color: isLogout ? Colors.redAccent : (isSelected ? Colors.white : Colors.white54), size: 18),
            const SizedBox(width: 12),
            Expanded(
              child: Text(label,
                  style: GoogleFonts.inter(
                      color: isLogout ? Colors.redAccent : (isSelected ? Colors.white : Colors.white54),
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                      fontSize: 13),
                  overflow: TextOverflow.ellipsis),
            ),
          ],
        ),
      ),
    );
  }
}

// --- KELAS GOALSPAGE ---
class GoalsPage extends StatefulWidget {
  final VoidCallback onBack;
  const GoalsPage({super.key, required this.onBack});
  @override
  State<GoalsPage> createState() => _GoalsPageState();
}

class _GoalsPageState extends State<GoalsPage> {
  int _tabIndex = 0;
  final List<Goal> _goals = [];

  Future<void> _navigateToConfirmAddGoal(BuildContext context) async {
    final result = await Navigator.push(context, MaterialPageRoute(builder: (context) => const AddGoalPage()));
    if (result != null && result is Map<String, String>) {
      double target = double.tryParse(result['target']!.replaceAll(RegExp(r'[^0-9.]'), '')) ?? 0;
      setState(() {
        _goals.add(Goal(title: result['title']!, targetAmount: target, savedAmount: 0, color: const Color(0xFF8B5CF6), icon: Icons.star_border));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        title: Text(_tabIndex == 0 ? "Financial Goals" : "Insights", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.black)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: MouseRegion(
          cursor: SystemMouseCursors.click,
          child: IconButton(icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.black, size: 20), onPressed: widget.onBack),
        ),
        actions: [
          IconButton(
            icon: Icon(_tabIndex == 0 ? Icons.insights_rounded : Icons.list_alt_rounded, color: const Color(0xFF8B5CF6)),
            onPressed: () => setState(() => _tabIndex = _tabIndex == 0 ? 1 : 0),
          ),
          IconButton(
            icon: const Icon(Icons.notifications_none_rounded, color: Colors.black),
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const NotificationsPage())),
          ),
        ],
      ),
      body: _tabIndex == 0 ? _buildGoalsContent() : const InsightsPage(),
    );
  }

  Widget _buildGoalsContent() {
    return SingleChildScrollView(
      child: Column(
        children: [
          _buildHero(),
          Padding(
            padding: const EdgeInsets.all(24),
            child: _goals.isEmpty
                ? const Center(child: Text("No goals yet. Start by adding a new one!", style: TextStyle(color: Colors.grey)))
                : Wrap(
              spacing: 16, runSpacing: 16,
              children: List.generate(_goals.length, (i) => _goalCard(_goals[i], i)),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildHero() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.all(24),
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [Color(0xFF8B5CF6), Color(0xFF6D28D9)]),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FittedBox(fit: BoxFit.scaleDown, child: const Text("Turn Savings Into\nBig Achievements", style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold))),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: () => _navigateToConfirmAddGoal(context),
            icon: const Icon(Icons.add), label: const Text("Add New Goal"),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.white, foregroundColor: const Color(0xFF8B5CF6)),
          ).animate(onPlay: (c) => c.repeat(reverse: true)).scale(end: const Offset(1.03, 1.03), duration: 1.seconds),
        ],
      ),
    );
  }

  Widget _goalCard(Goal goal, int index) {
    return Container(
      width: 160, padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10)]),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(goal.icon, color: goal.color, size: 20),
          const SizedBox(height: 12),
          Text(goal.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13), overflow: TextOverflow.ellipsis),
          const SizedBox(height: 8),
          LinearProgressIndicator(value: goal.progress, color: goal.color, backgroundColor: goal.color.withOpacity(0.1), minHeight: 4),
          const SizedBox(height: 8),
          Text("RM${goal.savedAmount.toStringAsFixed(0)}", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
        ],
      ),
    );
  }
}