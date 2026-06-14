import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'providers.dart';
import 'models.dart';

class ExpenseManagementPage extends StatelessWidget {
  final VoidCallback? onBack;
  const ExpenseManagementPage({super.key, this.onBack});

  void _showAddExpenseDialog(BuildContext context) {
    final descController = TextEditingController();
    final amountController = TextEditingController();
    String selectedCategory = 'Food';
    final finance = Provider.of<FinanceProvider>(context, listen: false);

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          title: Text('Add New Expense', style: GoogleFonts.inter(fontWeight: FontWeight.bold)),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: descController,
                  decoration: InputDecoration(
                    labelText: 'Description',
                    prefixIcon: const Icon(Icons.description_outlined, color: Color(0xFF6750A4)),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: amountController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Amount (RM)',
                    prefixIcon: const Icon(Icons.attach_money, color: Color(0xFF6750A4)),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: selectedCategory,
                  decoration: InputDecoration(
                    labelText: 'Category',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  items: ['Food', 'Transport', 'Bills', 'Shopping', 'Entertainment']
                      .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                      .toList(),
                  onChanged: (val) => setDialogState(() => selectedCategory = val!),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF6750A4),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: () {
                if (descController.text.isNotEmpty && amountController.text.isNotEmpty) {
                  final amount = double.tryParse(amountController.text) ?? 0.0;
                  finance.addExpense(Expense(
                    id: DateTime.now().toString(),
                    description: descController.text,
                    amount: amount,
                    category: selectedCategory,
                    date: DateTime.now(),
                    icon: _getIconForCategory(selectedCategory),
                    color: _getColorForCategory(selectedCategory),
                  ));
                  Navigator.pop(context);
                }
              },
              child: const Text('Save Expense', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getIconForCategory(String category) {
    switch (category) {
      case 'Food': return Icons.restaurant;
      case 'Transport': return Icons.directions_car;
      case 'Bills': return Icons.receipt_long;
      case 'Shopping': return Icons.shopping_bag;
      default: return Icons.category;
    }
  }

  Color _getColorForCategory(String category) {
    switch (category) {
      case 'Food': return Colors.orange;
      case 'Transport': return Colors.blue;
      case 'Bills': return Colors.green;
      case 'Shopping': return Colors.pink;
      default: return Colors.purple;
    }
  }

  @override
  Widget build(BuildContext context) {
    final finance = Provider.of<FinanceProvider>(context);

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
        title: Text("Expenses", style: GoogleFonts.inter(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: const LinearGradient(colors: [Color(0xFF6750A4), Color(0xFF9581FF)]),
                borderRadius: BorderRadius.circular(30),
                boxShadow: [BoxShadow(color: const Color(0xFF6750A4).withOpacity(0.3), blurRadius: 15, offset: const Offset(0, 8))],
              ),
              child: Column(
                children: [
                  const Text("Today's Expenses", style: TextStyle(color: Colors.white70, fontSize: 13)),
                  const SizedBox(height: 8),
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text("RM ${finance.totalExpenses.toStringAsFixed(2)}",
                        style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            Text("Recent Expenses", style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87)),
            const SizedBox(height: 16),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: finance.expenses.length,
              itemBuilder: (context, index) {
                final expense = finance.expenses[index];
                return _buildExpenseCard(context, expense);
              },
            ),
            const SizedBox(height: 100),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black,
        onPressed: () => _showAddExpenseDialog(context),
        mouseCursor: SystemMouseCursors.click,
        child: const Icon(Icons.add, color: Colors.white, size: 28),
      ),
    );
  }

  Widget _buildExpenseCard(BuildContext context, Expense expense) {
    final finance = Provider.of<FinanceProvider>(context, listen: false);
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10)],
      ),
      child: Row(
        children: [
          CircleAvatar(
            // DIBETULKAN: Ditambah null check (?? Colors.grey)
            backgroundColor: (expense.color ?? Colors.grey).withOpacity(0.1),
            child: Icon(expense.icon ?? Icons.category, color: expense.color ?? Colors.grey),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(expense.description, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14), overflow: TextOverflow.ellipsis),
                Text(expense.category, style: const TextStyle(color: Colors.grey, fontSize: 11)),
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
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text("- RM ${expense.amount.toStringAsFixed(2)}",
                        style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.redAccent, fontSize: 14)),
                  ),
                  const SizedBox(width: 4),
                  IconButton(
                    icon: const Icon(Icons.delete_outline, color: Colors.redAccent, size: 18),
                    onPressed: () {
                      _confirmDelete(context, () => finance.removeExpense(expense.id));
                    },
                    mouseCursor: SystemMouseCursors.click,
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

  void _confirmDelete(BuildContext context, VoidCallback onDelete) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Delete Record?"),
        content: const Text("Are you sure you want to remove this transaction?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
          TextButton(
            onPressed: () {
              onDelete();
              Navigator.pop(context);
            },
            child: const Text("Delete", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}