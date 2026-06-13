import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart'; 
import 'category.management.dart';

class IncomeManagement extends StatefulWidget {
  final List<CategoryModel> categories;
  final VoidCallback? onBack;

  const IncomeManagement({
    super.key,
    required this.categories,
    this.onBack,
  });

  @override
  State<IncomeManagement> createState() => _IncomeManagementState();
}

class _IncomeManagementState extends State<IncomeManagement> {
  final List<Map<String, dynamic>> _incomeList = [
    {'id': '1', 'title': 'Monthly Salary', 'category': 'Salary', 'amount': 12000.00, 'date': '01 Jun'},
    {'id': '2', 'title': 'Project Bonus', 'category': 'Freelance', 'amount': 3000.00, 'date': '05 Jun'},
  ];

  final Color primaryPurple = const Color(0xFF8B5CF6);
  final Color bgColor = const Color(0xFFF9FAFB);

  void _showAddIncomeDialog() {
    final titleController = TextEditingController();
    final categoryController = TextEditingController();
    final amountController = TextEditingController();
    DateTime selectedDate = DateTime.now();
    final dateController = TextEditingController(text: DateFormat('dd MMM').format(selectedDate));

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          title: Text('Add New Income', style: GoogleFonts.inter(fontWeight: FontWeight.bold)),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildPopupField(titleController, 'Income Source', Icons.source),
                const SizedBox(height: 16),
                _buildPopupField(categoryController, 'Category', Icons.category_outlined),
                const SizedBox(height: 16),
                _buildPopupField(amountController, 'Amount (RM)', Icons.attach_money, isNumber: true),
                const SizedBox(height: 16),
                TextField(
                  controller: dateController,
                  readOnly: true,
                  decoration: InputDecoration(
                    labelText: 'Date',
                    prefixIcon: Icon(Icons.calendar_today, color: primaryPurple),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onTap: () async {
                    DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: selectedDate,
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2101),
                    );
                    if (pickedDate != null) {
                      setDialogState(() {
                        selectedDate = pickedDate;
                        dateController.text = DateFormat('dd MMM').format(pickedDate);
                      });
                    }
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: primaryPurple, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
              onPressed: () {
                if (titleController.text.isNotEmpty && amountController.text.isNotEmpty) {
                  setState(() {
                    _incomeList.insert(0, {
                      'id': DateTime.now().toString(),
                      'title': titleController.text,
                      'category': categoryController.text,
                      'amount': double.tryParse(amountController.text) ?? 0.0,
                      'date': dateController.text,
                    });
                  });
                  Navigator.pop(context);
                }
              },
              child: const Text('Add Income', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }

  void _confirmDelete(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Delete Record?"),
        content: const Text("Are you sure you want to remove this record?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
          TextButton(
            onPressed: () {
              setState(() => _incomeList.removeAt(index));
              Navigator.pop(context);
            },
            child: const Text("Delete", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  Widget _buildPopupField(TextEditingController controller, String label, IconData icon, {bool isNumber = false}) {
    return TextField(
      controller: controller,
      keyboardType: isNumber ? const TextInputType.numberWithOptions(decimal: true) : TextInputType.text,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: primaryPurple),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double total = _incomeList.fold(0, (sum, item) => sum + item['amount']);

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: MouseRegion(
          cursor: SystemMouseCursors.click,
          child: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: widget.onBack ?? () => Navigator.pop(context),
          ),
        ),
        title: Text('Income Management', style: GoogleFonts.inter(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18)),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddIncomeDialog,
        backgroundColor: Colors.black,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: const Icon(Icons.add, color: Colors.white, size: 28),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            _buildBalanceCard(total),
            const SizedBox(height: 32),
            Text('Recent Income', style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black)),
            const SizedBox(height: 16),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _incomeList.length,
              itemBuilder: (context, index) => _buildIncomeItem(_incomeList[index], index),
            ),
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }

  Widget _buildBalanceCard(double total) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: primaryPurple,
        borderRadius: BorderRadius.circular(35),
        boxShadow: [BoxShadow(color: primaryPurple.withOpacity(0.3), blurRadius: 20, offset: const Offset(0, 10))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('TOTAL INCOME', style: GoogleFonts.inter(color: Colors.white.withOpacity(0.8), fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 1)),
          const SizedBox(height: 12),
          FittedBox( // DIBETULKAN: Elak overflow pada amaun besar
            fit: BoxFit.scaleDown,
            child: Text('RM ${total.toStringAsFixed(2)}', style: GoogleFonts.inter(color: Colors.white, fontSize: 34, fontWeight: FontWeight.w900)),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              _buildMiniStat(Icons.arrow_upward, 'Monthly', 'RM ${total.toStringAsFixed(0)}'),
              const SizedBox(width: 24),
              _buildMiniStat(Icons.trending_up, 'Growth', '+100%'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMiniStat(IconData icon, String label, String value) {
    return Expanded( // DIBETULKAN: Gunakan Expanded supaya muat di skrin kecil
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.greenAccent, size: 16),
          const SizedBox(width: 8),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: GoogleFonts.inter(color: Colors.white70, fontSize: 10), overflow: TextOverflow.ellipsis),
                FittedBox(fit: BoxFit.scaleDown, child: Text(value, style: GoogleFonts.inter(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold))),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIncomeItem(Map<String, dynamic> income, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 4))]),
      child: Row(
        children: [
          Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: const Color(0xFFF3F4F6), borderRadius: BorderRadius.circular(12)), child: Icon(Icons.account_balance_wallet_outlined, color: primaryPurple, size: 24)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(income['title'], style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.black), overflow: TextOverflow.ellipsis),
                Text(income['category'], style: GoogleFonts.inter(color: Colors.black38, fontSize: 11)),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  FittedBox(child: Text('RM ${income['amount'].toStringAsFixed(2)}', style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.black))),
                  const SizedBox(width: 4),
                  IconButton(
                    icon: const Icon(Icons.delete_outline, color: Colors.redAccent, size: 18),
                    onPressed: () => _confirmDelete(index),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              ),
              Text(income['date'], style: GoogleFonts.inter(color: Colors.black38, fontSize: 10)),
            ],
          ),
        ],
      ),
    );
  }
}
