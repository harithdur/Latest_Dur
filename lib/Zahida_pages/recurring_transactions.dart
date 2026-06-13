import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'providers.dart';
import 'models.dart';

class RecurringTransactionsPage extends StatelessWidget {
  final VoidCallback? onBack;
  const RecurringTransactionsPage({super.key, this.onBack});

  void _showAddBillDialog(BuildContext context) {
    final titleController = TextEditingController();
    final amountController = TextEditingController();
    String selectedCategory = 'Subscription';
    String selectedSchedule = 'Monthly';
    final finance = Provider.of<FinanceProvider>(context, listen: false);

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          title: Text('Add Recurring Bill', style: GoogleFonts.inter(fontWeight: FontWeight.bold)),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildPopupField(titleController, 'Bill Title', Icons.title),
                const SizedBox(height: 16),
                _buildPopupField(amountController, 'Amount (RM)', Icons.attach_money, isNumber: true),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: selectedCategory,
                  decoration: _inputDecoration('Category'),
                  items: ['Subscription', 'Rent', 'Insurance', 'Utilities']
                      .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                      .toList(),
                  onChanged: (val) => setDialogState(() => selectedCategory = val!),
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: selectedSchedule,
                  decoration: _inputDecoration('Frequency'),
                  items: ['Monthly', 'Yearly', 'Weekly']
                      .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                      .toList(),
                  onChanged: (val) => setDialogState(() => selectedSchedule = val!),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: () {
                if (titleController.text.isNotEmpty && amountController.text.isNotEmpty) {
                  finance.addRecurringBill(RecurringBill(
                    id: DateTime.now().toString(),
                    title: titleController.text,
                    amount: double.tryParse(amountController.text) ?? 0.0,
                    category: selectedCategory,
                    schedule: selectedSchedule,
                    nextDate: DateTime.now().add(const Duration(days: 30)),
                    icon: _getIconForCategory(selectedCategory),
                    color: _getColorForCategory(selectedCategory),
                  ));
                  Navigator.pop(context);
                }
              },
              child: const Text('Add Bill', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String label) => InputDecoration(
    labelText: label,
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
  );

  Widget _buildPopupField(TextEditingController controller, String label, IconData icon, {bool isNumber = false}) {
    return TextField(
      controller: controller,
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: const Color(0xFF8B5CF6)),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  IconData _getIconForCategory(String category) {
    switch (category) {
      case 'Rent': return Icons.home;
      case 'Subscription': return Icons.subscriptions;
      case 'Utilities': return Icons.flash_on;
      default: return Icons.receipt_long;
    }
  }

  Color _getColorForCategory(String category) {
    switch (category) {
      case 'Rent': return Colors.orange;
      case 'Subscription': return Colors.red;
      case 'Utilities': return Colors.green;
      default: return Colors.blue;
    }
  }

  @override
  Widget build(BuildContext context) {
    final finance = Provider.of<FinanceProvider>(context);
    final recurringBills = finance.recurringBills;

    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: MouseRegion(
          cursor: SystemMouseCursors.click,
          child: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: onBack ?? () => Navigator.pop(context),
          ),
        ),
        title: const Text("Recurring Bills", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18)),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddBillDialog(context),
        backgroundColor: Colors.black,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: const Icon(Icons.add, color: Colors.white, size: 28),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Summary Card
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: const Color(0xFF111827),
                borderRadius: BorderRadius.circular(30),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Monthly Commitments", style: TextStyle(color: Colors.white70, fontSize: 13)),
                      const SizedBox(width: 8),
                      Expanded( // DIBETULKAN
                        child: FittedBox(
                          alignment: Alignment.centerRight,
                          fit: BoxFit.scaleDown,
                          child: Text("RM ${finance.totalMonthlyCommitments.toStringAsFixed(2)}", 
                            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
                        ),
                      ),
                    ],
                  ),
                  const Divider(color: Colors.white10, height: 32),
                  Row(
                    children: [
                      Expanded(child: _buildSummaryItem("Active Bills", finance.recurringBills.length.toString(), Colors.blueAccent)),
                      Container(height: 30, width: 1, color: Colors.white10),
                      Expanded(child: _buildSummaryItem("Upcoming", "3", Colors.orangeAccent)),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            Text("Subscription List", style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87)),
            const SizedBox(height: 16),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: recurringBills.length,
              itemBuilder: (context, index) {
                final bill = recurringBills[index];
                return _buildRecurringCard(context, bill);
              },
            ),
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryItem(String label, String value, Color color) {
    return Column(
      children: [
        FittedBox(fit: BoxFit.scaleDown, child: Text(value, style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 18))),
        Text(label, style: const TextStyle(color: Colors.white60, fontSize: 11), overflow: TextOverflow.ellipsis),
      ],
    );
  }

  Widget _buildRecurringCard(BuildContext context, RecurringBill bill) {
    final finance = Provider.of<FinanceProvider>(context, listen: false);
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10)],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: bill.color.withOpacity(0.1), borderRadius: BorderRadius.circular(15)),
            child: Icon(bill.icon, color: bill.color),
          ),
          const SizedBox(width: 12),
          Expanded( // DIBETULKAN
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(bill.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15), overflow: TextOverflow.ellipsis),
                Text("${bill.schedule} • ${bill.category}", style: const TextStyle(color: Colors.grey, fontSize: 11)),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  FittedBox(fit: BoxFit.scaleDown, child: Text("RM ${bill.amount.toStringAsFixed(2)}", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15))),
                  const SizedBox(width: 8),
                  IconButton(
                    icon: const Icon(Icons.delete_outline, color: Colors.redAccent, size: 20),
                    onPressed: () => finance.removeRecurringBill(bill.id),
                    constraints: const BoxConstraints(),
                    padding: EdgeInsets.zero,
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
