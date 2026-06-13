import 'package:flutter/material.dart';
import 'models.dart';

class RecurringModule extends StatelessWidget {
  final List<RecurringBill> bills;
  const RecurringModule({super.key, required this.bills});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Recurring Bills", style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Column(
        children: [
          _buildNoticeBanner(),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _TabItem(title: "Upcoming", isActive: true),
                SizedBox(width: 32),
                _TabItem(title: "Active", isActive: false),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                const Text("This Month", 
                  style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold, fontSize: 14)),
                const SizedBox(height: 12),
                ...bills.map((b) => _buildBillCard(b)),
              ],
            ),
          ),
          _buildFooterBox(),
        ],
      ),
    );
  }

  Widget _buildNoticeBanner() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFEFF6FF),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFDBEAFE)),
      ),
      child: const Row(
        children: [
          Icon(Icons.info_outline, color: Color(0xFF3B82F6), size: 20),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              "Recurring transactions are added automatically based on your schedule.",
              style: TextStyle(fontSize: 12, color: Color(0xFF1E40AF), fontWeight: FontWeight.w500),
            ),
          ),
          Icon(Icons.sync, color: Color(0xFF3B82F6), size: 20),
        ],
      ),
    );
  }

  Widget _buildBillCard(RecurringBill b) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: Colors.white,
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: CircleAvatar(
          backgroundColor: b.color.withOpacity(0.1),
          child: Icon(b.icon, color: b.color, size: 20),
        ),
        title: Text(b.title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text("${b.schedule} • Next: ${b.nextDate.day} Jun 2024", 
          style: const TextStyle(color: Colors.grey, fontSize: 12)),
        trailing: Text("RM ${b.amount.toStringAsFixed(2)}", 
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
      ),
    );
  }

  Widget _buildFooterBox() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("Auto-Added (Next 30 Days)", 
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
              Text("3 transactions will be added", 
                style: TextStyle(color: Colors.grey, fontSize: 12)),
            ],
          ),
          Text("RM 1,272.90", 
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF8B5CF6))),
        ],
      ),
    );
  }
}

class _TabItem extends StatelessWidget {
  final String title;
  final bool isActive;
  const _TabItem({required this.title, required this.isActive});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          title,
          style: TextStyle(
            color: isActive ? const Color(0xFF8B5CF6) : Colors.grey,
            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
            fontSize: 16,
          ),
        ),
        if (isActive)
          Container(
            margin: const EdgeInsets.only(top: 4),
            height: 3,
            width: 40,
            decoration: BoxDecoration(
              color: const Color(0xFF8B5CF6),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
      ],
    );
  }
}
