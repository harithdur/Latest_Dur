import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:project_1/Zahida_pages/providers.dart'; // Pastikan path ini betul

class TransactionsPage extends StatelessWidget {
  final VoidCallback? onBack;
  const TransactionsPage({super.key, this.onBack});

  @override
  Widget build(BuildContext context) {
    const Color bgColor = Colors.white;
    const Color primaryText = Color(0xFF1A1A1A);
    const Color accentPurple = Color(0xFF8B5CF6);

    return Consumer<FinanceProvider>(
      builder: (context, finance, child) {
        return Scaffold(
          backgroundColor: bgColor,
          appBar: AppBar(
            backgroundColor: bgColor,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new_rounded, color: primaryText, size: 20),
              onPressed: onBack ?? () => Navigator.pop(context),
            ),
            title: Text('Wallet details', style: GoogleFonts.inter(fontWeight: FontWeight.bold, color: primaryText, fontSize: 18)),
            centerTitle: true,
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(color: accentPurple, borderRadius: BorderRadius.circular(32)),
                  child: Row(
                    children: [
                      Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(16)), child: const Icon(Icons.shopping_bag, color: Colors.white, size: 28)),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Total Expenses', style: GoogleFonts.inter(color: Colors.white70, fontSize: 14)),
                            Text('RM ${finance.totalExpenses.toStringAsFixed(2)}', style: GoogleFonts.inter(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
                Text('Latest transaction', style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.bold, color: primaryText)),
                const SizedBox(height: 16),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: finance.expenses.length,
                  itemBuilder: (context, index) {
                    final tx = finance.expenses[index];
                    return _buildTransactionItem(tx.description, "${tx.date.day}/${tx.date.month}", tx.amount.toStringAsFixed(2), const Color(0xFFF3F4F6), primaryText);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Fungsi ini sekarang berada DI DALAM kelas TransactionsPage
  Widget _buildTransactionItem(String title, String date, String amount, Color bg, Color pText) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        children: [
          CircleAvatar(backgroundColor: bg, radius: 20, child: const Icon(Icons.shopping_bag_outlined, color: Colors.black, size: 20)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 14, color: pText), overflow: TextOverflow.ellipsis),
                Text(date, style: const TextStyle(color: Colors.grey, fontSize: 11)),
              ],
            ),
          ),
          Text('-RM $amount', style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 14, color: pText)),
        ],
      ),
    );
  }
}