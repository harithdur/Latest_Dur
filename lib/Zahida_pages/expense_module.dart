import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'models.dart';

class ExpenseModule extends StatefulWidget {
  final List<Expense> expenses;
  final Function(Expense) onAddExpense;
  const ExpenseModule({super.key, required this.expenses, required this.onAddExpense, required void Function(Expense expense) onAdd});

  @override
  State<ExpenseModule> createState() => _ExpenseModuleState();
}

class _ExpenseModuleState extends State<ExpenseModule> {
  final _descController = TextEditingController();
  final _amountController = TextEditingController();
  String _selectedCategory = "Food";

  final Map<String, dynamic> _categoryConfig = {
    "Food": {"icon": Icons.restaurant, "color": const Color(0xFFA855F7)},
    "Transport": {"icon": Icons.directions_car, "color": const Color(0xFF3B82F6)},
    "Bills": {"icon": Icons.electric_bolt, "color": const Color(0xFFF59E0B)},
    "Entertainment": {"icon": Icons.movie_outlined, "color": const Color(0xFF10B981)},
  };

  @override
  Widget build(BuildContext context) {
    double todayTotal = widget.expenses.fold(0, (sum, item) => sum + item.amount);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Expenses", style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSummaryCard(todayTotal),
            const SizedBox(height: 24),
            const Text("Add New Expense", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            _buildAddForm(),
            const SizedBox(height: 24),
            const Text("Recent Transactions", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            ...widget.expenses.map((e) => _expenseTile(e)),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryCard(double total) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Today's Summary", style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text("RM ${total.toStringAsFixed(2)}", 
                    style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            SizedBox(
              width: 60, height: 60,
              child: CustomPaint(painter: DonutChartPainter()),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildAddForm() {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _formDateRow(),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              initialValue: _selectedCategory,
              decoration: _inputDecoration("Category"),
              items: _categoryConfig.keys.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
              onChanged: (v) => setState(() => _selectedCategory = v!),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _descController,
              decoration: _inputDecoration("Description"),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              decoration: _inputDecoration("Amount (RM)"),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF8B5CF6),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 0,
                ),
                onPressed: () {
                  if (_amountController.text.isNotEmpty) {
                    final config = _categoryConfig[_selectedCategory];
                    widget.onAddExpense(Expense(
                      description: _descController.text,
                      amount: double.tryParse(_amountController.text) ?? 0,
                      category: _selectedCategory,
                      date: DateTime.now(),
                      icon: config['icon'],
                      color: config['color'], id: '',
                    ));
                    _amountController.clear();
                    _descController.clear();
                  }
                },
                child: const Text("Add Expense", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    );
  }

  Widget _formDateRow() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFFE2E8F0)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const Icon(Icons.calendar_today, size: 18, color: Color(0xFF8B5CF6)),
          const SizedBox(width: 12),
          const Text("20 May 2024", style: TextStyle(fontWeight: FontWeight.w500)),
          const Spacer(),
          const Icon(Icons.arrow_drop_down, color: Colors.grey),
        ],
      ),
    );
  }

  Widget _expenseTile(Expense e) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: e.color.withOpacity(0.1),
          child: Icon(e.icon, color: e.color, size: 20),
        ),
        title: Text(e.description, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text("${e.category} • Today"),
        trailing: Text("-RM ${e.amount.toStringAsFixed(2)}", 
          style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 16)),
      ),
    );
  }
}

class DonutChartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8;

    paint.color = const Color(0xFFA855F7);
    canvas.drawArc(Rect.fromCircle(center: center, radius: radius), -math.pi / 2, math.pi * 0.8, false, paint);

    paint.color = const Color(0xFF3B82F6);
    canvas.drawArc(Rect.fromCircle(center: center, radius: radius), math.pi * 0.3, math.pi * 0.5, false, paint);

    paint.color = const Color(0xFFE2E8F0);
    canvas.drawArc(Rect.fromCircle(center: center, radius: radius), math.pi * 0.8, math.pi * 0.7, false, paint);
  }

  @override
  bool shouldRepaint(CustomPainter old) => false;
}
