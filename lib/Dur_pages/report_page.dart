import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';

class ReportPage extends StatefulWidget {
  final VoidCallback? onBack;
  const ReportPage({super.key, this.onBack});

  @override
  State<ReportPage> createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  int _reportTypeIndex = 1; 

  @override
  Widget build(BuildContext context) {
    const Color bgColor = Color(0xFFF9FAFB);
    const Color primaryPurple = Color(0xFF8B5CF6);

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: MouseRegion(
          cursor: SystemMouseCursors.click,
          child: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.black, size: 20),
            onPressed: widget.onBack ?? () => Navigator.pop(context),
          ),
        ),
        title: Text('Reports', style: GoogleFonts.inter(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 18)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            FittedBox( // DIBETULKAN
              fit: BoxFit.scaleDown,
              child: Text(
                '📈 Analytics Overview',
                style: GoogleFonts.inter(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black),
              ),
            ).animate().fadeIn().slideX(begin: -0.1),
            const SizedBox(height: 24),
            
            _buildToggle().animate().fadeIn(delay: 100.ms),
            const SizedBox(height: 32),

            Text('Cash Flow Graph', style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87)),
            const SizedBox(height: 12),
            _buildLineChartCard().animate().fadeIn(delay: 200.ms).scale(begin: const Offset(0.95, 0.95)),
            const SizedBox(height: 12),
            
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _legendItem("Income", Colors.green),
                const SizedBox(width: 20),
                _legendItem("Expense", Colors.red),
              ],
            ),
            
            const SizedBox(height: 40),

            Text('Spending by Category', style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87)),
            const SizedBox(height: 16),
            _buildPieChartCard(primaryPurple).animate().fadeIn(delay: 300.ms),
            const SizedBox(height: 12),
            
            Center(
              child: Wrap( // DIBETULKAN: Wrap supaya legenda turun bawah jika skrin sempit
                spacing: 12, runSpacing: 8,
                alignment: WrapAlignment.center,
                children: [
                  _legendItem("Food", Colors.purple),
                  _legendItem("Trans", Colors.blue),
                  _legendItem("Bills", Colors.green),
                  _legendItem("Rent", Colors.orange),
                ],
              ),
            ),
            
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }

  Widget _buildToggle() {
    return Container(
      height: 45,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.white, 
        borderRadius: BorderRadius.circular(15), 
        border: Border.all(color: Colors.black.withOpacity(0.05))
      ),
      child: Row(
        children: [
          _toggleBtn("Weekly", 0),
          _toggleBtn("Monthly", 1),
        ],
      ),
    );
  }

  Widget _toggleBtn(String label, int index) {
    bool isSel = _reportTypeIndex == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _reportTypeIndex = index),
        child: MouseRegion(
          cursor: SystemMouseCursors.click,
          child: Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: isSel ? Colors.black : Colors.transparent,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(label, style: GoogleFonts.inter(color: isSel ? Colors.white : Colors.black38, fontWeight: FontWeight.bold, fontSize: 13)),
          ),
        ),
      ),
    );
  }

  Widget _buildLineChartCard() {
    return Container(
      height: 250, // Dikecilkan sedikit
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(5, 20, 20, 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.black.withOpacity(0.03)),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 15, offset: const Offset(0, 5))],
      ),
      child: LineChart(
        LineChartData(
          gridData: FlGridData(
            show: true,
            drawVerticalLine: true,
            horizontalInterval: 25,
            verticalInterval: 2,
            getDrawingHorizontalLine: (value) => FlLine(color: Colors.grey.withOpacity(0.1), strokeWidth: 1),
            getDrawingVerticalLine: (value) => FlLine(color: Colors.grey.withOpacity(0.1), strokeWidth: 1),
          ),
          titlesData: FlTitlesData(
            show: true,
            rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 22,
                interval: 2,
                getTitlesWidget: (value, meta) => Text(value.toInt().toString(), style: const TextStyle(color: Colors.black38, fontSize: 10)),
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                interval: 25,
                getTitlesWidget: (value, meta) => Text(value.toInt().toString(), style: const TextStyle(color: Colors.black38, fontSize: 10)),
                reservedSize: 25,
              ),
            ),
          ),
          borderData: FlBorderData(
            show: true,
            border: Border(
              bottom: BorderSide(color: Colors.black.withOpacity(0.05), width: 1),
              left: BorderSide(color: Colors.black.withOpacity(0.05), width: 1),
            ),
          ),
          minX: 0, maxX: 12, minY: 0, maxY: 100,
          lineBarsData: [
            LineChartBarData(
              spots: const [FlSpot(0, 15), FlSpot(2, 60), FlSpot(4, 40), FlSpot(6, 85), FlSpot(8, 70), FlSpot(10, 90), FlSpot(12, 95)],
              isCurved: false,
              color: Colors.green,
              barWidth: 2,
              dotData: const FlDotData(show: true),
            ),
            LineChartBarData(
              spots: const [FlSpot(0, 5), FlSpot(2, 25), FlSpot(4, 55), FlSpot(6, 40), FlSpot(8, 80), FlSpot(10, 75), FlSpot(12, 90)],
              isCurved: false,
              color: Colors.red,
              barWidth: 2,
              dotData: const FlDotData(show: true),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPieChartCard(Color primaryPurple) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 20, offset: const Offset(0, 10))],
      ),
      child: SizedBox(
        height: 180, // Dikecilkan sedikit
        child: PieChart(
          PieChartData(
            sectionsSpace: 4,
            centerSpaceRadius: 30,
            sections: [
              PieChartSectionData(color: Colors.purple, value: 40, title: '40%', radius: 45, titleStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 10)),
              PieChartSectionData(color: Colors.blue, value: 25, title: '25%', radius: 45, titleStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 10)),
              PieChartSectionData(color: Colors.green, value: 20, title: '20%', radius: 45, titleStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 10)),
              PieChartSectionData(color: Colors.orange, value: 15, title: '15%', radius: 45, titleStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 10)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _legendItem(String label, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        CircleAvatar(radius: 3, backgroundColor: color),
        const SizedBox(width: 6),
        Text(label, style: GoogleFonts.inter(fontSize: 11, color: Colors.black54, fontWeight: FontWeight.w600)),
      ],
    );
  }
}
