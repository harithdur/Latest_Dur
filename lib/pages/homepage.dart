import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:project_1/pages/transactions_page.dart'; // Dibetulkan

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    const Color primaryText = Color(0xFF111827);
    const Color secondaryText = Color(0xFF6B7280);

    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(48),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Section
            _buildDashboardHeader(context, primaryText, secondaryText),
            const SizedBox(height: 48),

            // Quick Actions Section
            Text(
              'Quick actions',
              style: GoogleFonts.inter(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: primaryText,
              ),
            ),
            const SizedBox(height: 24),
            _buildQuickActionsGrid(context),
            const SizedBox(height: 48),

            // Latest Transaction Section
            Text(
              'Latest transaction',
              style: GoogleFonts.inter(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: primaryText,
              ),
            ),
            const SizedBox(height: 24),
            _buildLatestTransactionsList(primaryText, secondaryText),
          ],
        ),
      ),
    );
  }

  Widget _buildDashboardHeader(BuildContext context, Color pText, Color sText) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 4.0),
              child: IconButton(
                icon: const Icon(Icons.menu, size: 28),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                onPressed: () => Scaffold.of(context).openDrawer(),
              ),
            ),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Smart Financial Tracker',
                    style: GoogleFonts.inter(
                      color: sText,
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.5,
                    )),
                const SizedBox(height: 8),
                Text('Main balance',
                    style: GoogleFonts.inter(color: sText, fontSize: 14)),
                const SizedBox(height: 8),
                Text('RM 3,465.80',
                    style: GoogleFonts.inter(fontSize: 40, fontWeight: FontWeight.bold, color: pText)),
              ],
            ),
          ],
        ),
        Row(
          children: [
            _headerActionBtn(context, Icons.add, 'Add'),
            _headerActionBtn(context, Icons.swap_horiz, 'Move'),
            _headerActionBtn(context, Icons.near_me_outlined, 'Send'),
            _headerActionBtn(context, Icons.more_horiz, 'Details'),
          ],
        ),
      ],
    );
  }

  Widget _headerActionBtn(BuildContext context, IconData icon, String label) {
    return Padding(
      padding: const EdgeInsets.only(left: 32),
      child: InkWell(
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const TransactionsPage())),
        child: Column(
          children: [
            Container(
              width: 52, height: 52,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.black.withValues(alpha: 0.05)),
                boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 10)],
              ),
              child: Icon(icon, color: Colors.black87, size: 22),
            ),
            const SizedBox(height: 8),
            Text(label, style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w500, color: Colors.black54)),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActionsGrid(BuildContext context) {
    return Row(
      children: [
        Expanded(child: _categoryCard(context, 'Groceries', 'RM 1,245.30', const Color(0xFF8B5CF6), Icons.shopping_bag)),
        const SizedBox(width: 20),
        Expanded(child: _categoryCard(context, 'Transport', 'RM 540.00', const Color(0xFF3B82F6), Icons.directions_car)),
        const SizedBox(width: 20),
        Expanded(child: _categoryCard(context, 'Entertainment', 'RM 600.00', const Color(0xFF10B981), Icons.local_activity)),
        const SizedBox(width: 20),
        Expanded(child: _categoryCard(context, 'Utilities', 'RM 1,080.50', const Color(0xFFF59E0B), Icons.home)),
      ],
    ).animate().fadeIn(duration: 600.ms).slideY(begin: 0.05);
  }

  Widget _categoryCard(BuildContext context, String title, String amount, Color color, IconData icon) {
    return InkWell(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const TransactionsPage())),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(color: color.withValues(alpha: 0.2), blurRadius: 15, offset: const Offset(0, 8))
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: Colors.white, size: 20),
            ),
            const SizedBox(height: 40),
            Text(title, style: GoogleFonts.inter(color: Colors.white70, fontSize: 13, fontWeight: FontWeight.w500)),
            const SizedBox(height: 4),
            Text(amount, style: GoogleFonts.inter(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
          ],
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
          margin: const EdgeInsets.only(bottom: 16),
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 10)],
          ),
          child: Row(
            children: [
              Container(
                width: 46, height: 46,
                decoration: const BoxDecoration(color: Color(0xFFF3F4F6), shape: BoxShape.circle),
                child: const Icon(Icons.shopping_bag_outlined, color: Colors.black, size: 22),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(tx['title']!, style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 15, color: pText)),
                    Text(tx['date']!, style: GoogleFonts.inter(color: sText, fontSize: 12)),
                  ],
                ),
              ),
              Text(tx['amount']!,
                  style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.redAccent)),
            ],
          ),
        );
      }).toList(),
    );
  }
}
