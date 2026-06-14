import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'dart:ui';
import 'package:provider/provider.dart';
import 'package:project_1/Zahida_pages/providers.dart';

class HomePage extends StatefulWidget {
  final Function(int)? onNavigate;

  const HomePage({super.key, this.onNavigate});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    // Memulakan pendengar data dari Firebase sebaik sahaja masuk ke Dashboard
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<FinanceProvider>(context, listen: false);
      provider.listenToExpenses();
      provider.listenToIncomes();
    });
  }

  @override
  Widget build(BuildContext context) {
    const Color primaryText = Color(0xFF111827);
    const Color secondaryText = Color(0xFF6B7280);
    const Color primaryPurple = Color(0xFF8B5CF6);

    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 48),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // TOP BAR
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.menu, size: 28),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  onPressed: () => Scaffold.of(context).openDrawer(),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Smart Financial Tracker',
                    style: GoogleFonts.inter(color: secondaryText, fontSize: 14, fontWeight: FontWeight.w800, letterSpacing: 0.5),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.settings_outlined, size: 24, color: primaryText),
                  onPressed: () => widget.onNavigate?.call(10),
                ),
                const SizedBox(width: 4),
                MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: GestureDetector(
                    onTap: () => widget.onNavigate?.call(9),
                    child: CircleAvatar(
                      radius: 18,
                      backgroundColor: const Color(0xFFE6DEFF),
                      child: Icon(Icons.person, size: 20, color: primaryPurple.withOpacity(0.8)),
                    ),
                  ),
                ),
              ],
            ).animate().fadeIn(duration: 200.ms).slideY(begin: -0.1),
            const SizedBox(height: 32),

            _buildGlassBalanceCard(context, primaryPurple),
            const SizedBox(height: 32),

            _buildIncomeExpenseSummary().animate().fadeIn(delay: 150.ms, duration: 250.ms).slideX(begin: -0.05),
            const SizedBox(height: 32),

            Text('Quick actions', style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.bold, color: primaryText)).animate().fadeIn(delay: 200.ms),
            const SizedBox(height: 16),
            _buildQuickActionsGrid(context),
            const SizedBox(height: 32),

            Text('Latest transaction', style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.bold, color: primaryText)).animate().fadeIn(delay: 350.ms),
            const SizedBox(height: 16),
            _buildLatestTransactionsList(primaryText, secondaryText),
          ],
        ),
      ),
    );
  }

  Widget _buildGlassBalanceCard(BuildContext context, Color themeColor) {
    return Container(
      width: double.infinity,
      height: 200,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(32),
        gradient: LinearGradient(
          colors: [themeColor.withOpacity(0.85), themeColor.withOpacity(0.65)],
          begin: Alignment.topLeft, end: Alignment.bottomRight,
        ),
        boxShadow: [BoxShadow(color: themeColor.withOpacity(0.3), blurRadius: 20, offset: const Offset(0, 10))],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(32),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Main balance', style: GoogleFonts.inter(color: Colors.white.withOpacity(0.8), fontSize: 14, fontWeight: FontWeight.w500)),
                  const SizedBox(height: 4),
                  Consumer<FinanceProvider>(
                    builder: (context, finance, child) {
                      // Baki bermula 0.00 dan berubah ikut transaksi
                      return FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                            'RM ${finance.totalBalance.toStringAsFixed(2)}',
                            style: GoogleFonts.inter(color: Colors.white, fontSize: 38, fontWeight: FontWeight.bold)
                        ),
                      );
                    },
                  ),
                  const Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      _glassActionBtn(Icons.trending_up_rounded, "Income", () => widget.onNavigate?.call(2)),
                      const SizedBox(width: 12),
                      _glassActionBtn(Icons.trending_down_rounded, "Expense", () => widget.onNavigate?.call(3)),
                      const SizedBox(width: 12),
                      _glassActionBtn(Icons.refresh, "Reset", () {
                         Provider.of<FinanceProvider>(context, listen: false).resetAllData();
                      }),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _glassActionBtn(IconData icon, String label, VoidCallback? onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), shape: BoxShape.circle), child: Icon(icon, color: Colors.white, size: 20)),
          const SizedBox(height: 4),
          Text(label, style: GoogleFonts.inter(color: Colors.white, fontSize: 9, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  Widget _buildIncomeExpenseSummary() {
    return Consumer<FinanceProvider>(
      builder: (context, finance, child) {
        return Row(
          children: [
            Expanded(child: _summaryCard("Income", "RM ${finance.totalIncome.toStringAsFixed(0)}", Icons.arrow_upward, Colors.green)),
            const SizedBox(width: 12),
            Expanded(child: _summaryCard("Expense", "RM ${finance.totalExpenses.toStringAsFixed(0)}", Icons.arrow_downward, Colors.redAccent)),
          ],
        );
      },
    );
  }

  Widget _summaryCard(String label, String amount, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10)]),
      child: Row(
        children: [
          Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: color.withOpacity(0.1), shape: BoxShape.circle), child: Icon(icon, color: color, size: 18)),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: GoogleFonts.inter(color: const Color(0xFF6B7280), fontSize: 11), overflow: TextOverflow.ellipsis),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(amount, style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 15)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionsGrid(BuildContext context) {
    return GridView.count(
      crossAxisCount: 5, shrinkWrap: true, physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 10, crossAxisSpacing: 10,
      childAspectRatio: 0.7,
      children: [
        _imageMenuCard('Trans', const Color(0xFF8B5CF6), 'https://img.icons8.com/color/96/transaction.png', 1),
        _imageMenuCard('Incomes', const Color(0xFF10B981), 'https://img.icons8.com/color/96/money-box.png', 2),
        _imageMenuCard('Expense', const Color(0xFF06B6D4), 'https://img.icons8.com/color/96/expensive.png', 3),
        _imageMenuCard('Bills', const Color(0xFFF97316), 'https://img.icons8.com/color/96/bill.png', 4),
        _imageMenuCard('Budget', const Color(0xFF3B82F6), 'https://img.icons8.com/color/96/budget.png', 5), 
      ],
    );
  }

  Widget _imageMenuCard(String title, Color color, String imageUrl, int index) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () => widget.onNavigate?.call(index),
        child: Container(
          decoration: BoxDecoration(color: color.withOpacity(0.08), borderRadius: BorderRadius.circular(16)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(child: Image.network(imageUrl, width: 32, height: 32)),
              const SizedBox(height: 6),
              Text(title, textAlign: TextAlign.center, style: GoogleFonts.inter(color: color, fontSize: 8.5, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLatestTransactionsList(Color pText, Color sText) {
    return Consumer<FinanceProvider>(
      builder: (context, finance, child) {
        final transactions = finance.expenses;
        if (transactions.isEmpty) {
          return Center(child: Text("No transactions yet", style: GoogleFonts.inter(color: sText)));
        }
        return Column(
          children: transactions.take(5).map((tx) {
            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.01), blurRadius: 10)]),
              child: Row(
                children: [
                  Container(width: 40, height: 40, decoration: const BoxDecoration(color: Color(0xFFF3F4F6), shape: BoxShape.circle), child: Icon(tx.icon ?? Icons.shopping_bag_outlined, color: Colors.black, size: 20)),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text(tx.description, style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 14, color: pText), overflow: TextOverflow.ellipsis), 
                      Text("${tx.category} • ${tx.date.day}/${tx.date.month}", style: GoogleFonts.inter(color: sText, fontSize: 11))
                    ]),
                  ),
                  Text("-RM ${tx.amount.toStringAsFixed(2)}", style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.redAccent)),
                ],
              ),
            );
          }).toList(),
        );
      },
    );
  }
}
