import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:project_1/Dur_pages/transactions_page.dart';
import 'dart:ui';
// 1. Import Provider untuk guna Consumer
import 'package:provider/provider.dart';

// 2. Import fail provider awak (sesuaikan path folder jika perlu)
import 'package:project_1/Zahida_pages/providers.dart';

class HomePage extends StatelessWidget {
  final Function(int)? onNavigate;

  const HomePage({super.key, this.onNavigate});

  @override
  Widget build(BuildContext context) {
    const Color primaryText = Color(0xFF111827);
    const Color secondaryText = Color(0xFF6B7280);
    const Color primaryPurple = Color(0xFF8B5CF6);

    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 48), // Padding dikecilkan sedikit
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
                    style: GoogleFonts.inter(
                      color: secondaryText,
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.5,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.settings_outlined, size: 24, color: primaryText),
                  onPressed: () => onNavigate?.call(10),
                ),
                const SizedBox(width: 4),
                MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: GestureDetector(
                    onTap: () => onNavigate?.call(9),
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

            Text(
              'Quick actions',
              style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.bold, color: primaryText),
            ).animate().fadeIn(delay: 200.ms),
            const SizedBox(height: 16),
            _buildQuickActionsGrid(context),
            const SizedBox(height: 32),

            Text(
              'Latest transaction',
              style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.bold, color: primaryText),
            ).animate().fadeIn(delay: 350.ms),
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
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.transparent, Colors.white.withOpacity(0.1), Colors.transparent],
                    stops: const [0.3, 0.5, 0.7],
                    begin: const Alignment(-1.5, -1.0), end: const Alignment(1.5, 1.0),
                  ),
                ),
              ).animate(onPlay: (c) => c.repeat()).shimmer(duration: 1500.ms, color: Colors.white.withOpacity(0.1)),
            ),
            BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.white.withOpacity(0.15), Colors.white.withOpacity(0.02)],
                    begin: Alignment.topLeft, end: Alignment.bottomRight,
                  ),
                  border: Border.all(color: Colors.white.withOpacity(0.2), width: 1.5),
                  borderRadius: BorderRadius.circular(32),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Main balance', style: GoogleFonts.inter(color: Colors.white.withOpacity(0.8), fontSize: 14, fontWeight: FontWeight.w500)),
                  const SizedBox(height: 4),
                  Consumer<FinanceProvider>(
                    builder: (context, finance, child) {
                      // Kita kira baki (Income - Expense)
                      // Nota: Kalau belum ada field 'income' di Provider,
                      // awak boleh tukar logic ni ikut kesesuaian
                      double balance = 10500.00 - finance.totalExpenses;

                      return FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                            'RM ${balance.toStringAsFixed(2)}',
                            style: GoogleFonts.inter(color: Colors.white, fontSize: 38, fontWeight: FontWeight.bold)
                        ),
                      );
                    },
                  ),
                  const Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      _glassActionBtn(Icons.trending_up_rounded, "Income", true, true, () => onNavigate?.call(2)),
                      const SizedBox(width: 12),
                      _glassActionBtn(Icons.trending_down_rounded, "Expense", true, true, () => onNavigate?.call(3)),
                      const SizedBox(width: 12),
                      _glassActionBtn(Icons.share_outlined, "Share", false, false, null),
                      const SizedBox(width: 12),
                      _glassActionBtn(Icons.more_horiz, "Details", false, false, null),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ).animate().fadeIn(duration: 300.ms).scale(begin: const Offset(0.95, 0.95));
  }

  Widget _glassActionBtn(IconData icon, String label, bool hasPulse, bool isEnabled, VoidCallback? onTap) {
    Widget btn = MouseRegion(
      cursor: isEnabled ? SystemMouseCursors.click : SystemMouseCursors.basic,
      child: GestureDetector(
        onTap: onTap,
        child: Opacity(
          opacity: isEnabled ? 1.0 : 0.5,
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), shape: BoxShape.circle),
                child: Icon(icon, color: Colors.white, size: 20), 
              ),
              const SizedBox(height: 4),
              Text(
                label, 
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(color: Colors.white, fontSize: 9, fontWeight: FontWeight.w600)
              ),
            ],
          ),
        ),
      ),
    );
    
    if (hasPulse && isEnabled) {
      return btn.animate(onPlay: (c) => c.repeat(reverse: true))
          .scale(end: const Offset(1.15, 1.15), duration: 800.ms, curve: Curves.easeInOut);
    }
    return btn;
  }

  Widget _buildIncomeExpenseSummary() {
    return Row(
      children: [
        Expanded(child: _summaryCard("Income", "RM 15,000", Icons.arrow_upward, Colors.green)),
        const SizedBox(width: 12),
        Expanded(child: _summaryCard("Expense", "RM 4,500", Icons.arrow_downward, Colors.redAccent)),
      ],
    );
  }

  Widget _summaryCard(String label, String amount, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: color.withOpacity(0.1), shape: BoxShape.circle),
            child: Icon(icon, color: color, size: 18), 
          ),
          const SizedBox(width: 8),
          Expanded( // DIBETULKAN: Gunakan Expanded untuk elak ralat kuning
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(label, style: GoogleFonts.inter(color: const Color(0xFF6B7280), fontSize: 11, fontWeight: FontWeight.w500), overflow: TextOverflow.ellipsis),
                FittedBox( // DIBETULKAN: Mengecilkan teks jumlah jika ruang sempit
                  fit: BoxFit.scaleDown,
                  child: Text(amount, style: GoogleFonts.inter(color: const Color(0xFF111827), fontSize: 15, fontWeight: FontWeight.bold)),
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
      crossAxisCount: 5, 
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 10,
      crossAxisSpacing: 10,
      childAspectRatio: 0.7, 
      children: AnimateList(
        interval: 20.ms,
        effects: [FadeEffect(duration: 200.ms), ScaleEffect(begin: const Offset(0.9, 0.9))],
        children: [
          _imageMenuCard(context, 'Trans', const Color(0xFF8B5CF6), 'https://img.icons8.com/color/96/transaction.png', 1),
          _imageMenuCard(context, 'Budget', const Color(0xFF3B82F6), 'https://img.icons8.com/color/96/budget.png', 5), // Index dilaraskan
          _imageMenuCard(context, 'Incomes', const Color(0xFF10B981), 'https://img.icons8.com/color/96/money-box.png', 2),
          _imageMenuCard(context, 'Category', const Color(0xFFF59E0B), 'https://img.icons8.com/color/96/category.png', 7),
          _imageMenuCard(context, 'Goals', const Color(0xFFEC4899), 'https://img.icons8.com/color/96/goal.png', 6),
          _imageMenuCard(context, 'Expense', const Color(0xFF06B6D4), 'https://img.icons8.com/color/96/expensive.png', 3),
          _imageMenuCard(context, 'Bills', const Color(0xFFF97316), 'https://img.icons8.com/color/96/bill.png', 4),
          _imageMenuCard(context, 'Reports', const Color(0xFF6366F1), 'https://img.icons8.com/color/96/graph-report.png', 8),
        ],
      ),
    );
  }

  Widget _imageMenuCard(BuildContext context, String title, Color color, String imageUrl, int index) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () => onNavigate?.call(index),
        child: Container(
          decoration: BoxDecoration(
            color: color.withOpacity(0.08), 
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: color.withOpacity(0.15)),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(child: Image.network(imageUrl, width: 32, height: 32)), // Dikecilkan sedikit untuk skrin kecil
              const SizedBox(height: 6),
              Text(
                title, 
                textAlign: TextAlign.center, 
                style: GoogleFonts.inter(color: color, fontSize: 8.5, fontWeight: FontWeight.bold),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLatestTransactionsList(Color pText, Color sText) {
    final List<Map<String, String>> mockTransactions = [
      {'title': 'Supermart Groceries', 'date': 'Sep 14, 2025', 'amount': '-RM 52.30'},
      {'title': 'Fresh Bakery', 'date': 'Sep 13, 2025', 'amount': '-RM 30.45'},
    ];
    return Column(
      children: mockTransactions.map((tx) {
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.01), blurRadius: 10)]),
          child: Row(
            children: [
              Container(width: 40, height: 40, decoration: const BoxDecoration(color: Color(0xFFF3F4F6), shape: BoxShape.circle), child: const Icon(Icons.shopping_bag_outlined, color: Colors.black, size: 20)),
              const SizedBox(width: 12),
              Expanded(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(tx['title']!, style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 14, color: pText), overflow: TextOverflow.ellipsis), 
                  Text(tx['date']!, style: GoogleFonts.inter(color: sText, fontSize: 11))
                ]),
              ),
              Text(tx['amount']!, style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.redAccent)),
            ],
          ),
        ).animate().fadeIn(delay: 350.ms, duration: 250.ms).slideY(begin: 0.1);
      }).toList(),
    );
  }
}
