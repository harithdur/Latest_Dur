import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:google_fonts/google_fonts.dart';

class ReportPage extends StatefulWidget {
  const ReportPage({super.key});

  @override
  State<ReportPage> createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  int _reportTypeIndex = 0; // 0 for Weekly, 1 for Monthly

  @override
  Widget build(BuildContext context) {
    const Color bgColor = Color(0xFFF3F4F6);
    const Color primaryPurple = Color(0xFF8B5CF6);
    const Color primaryBlue = Color(0xFF3B82F6);
    const Color primaryGreen = Color(0xFF10B981);
    const Color primaryOrange = Color(0xFFF59E0B);

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('Reports', style: GoogleFonts.inter(fontWeight: FontWeight.bold, color: Colors.black)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '📈 Reports & Analytics',
              style: GoogleFonts.inter(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 24),
            
            // Weekly / Monthly Toggle
            Container(
              height: 50,
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  _buildToggleItem('Weekly', 0),
                  _buildToggleItem('Monthly', 1),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Pie Chart Section
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(32),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.03),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  )
                ],
              ),
              child: Column(
                children: [
                  Text(
                    'Spending by category',
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 32),
                  SizedBox(
                    height: 240, 
                    child: PieChart(
                      PieChartData(
                        sectionsSpace: 4,
                        centerSpaceRadius: 40,
                        sections: [
                          PieChartSectionData(
                            color: primaryPurple,
                            value: 40,
                            title: 'Groceries\n40%',
                            radius: 60,
                            titleStyle: GoogleFonts.inter(
                                color: Colors.white, fontWeight: FontWeight.bold, fontSize: 10),
                          ),
                          PieChartSectionData(
                            color: primaryBlue,
                            value: 25,
                            title: 'Transport\n25%',
                            radius: 60,
                            titleStyle: GoogleFonts.inter(
                                color: Colors.white, fontWeight: FontWeight.bold, fontSize: 10),
                          ),
                          PieChartSectionData(
                            color: primaryGreen,
                            value: 20,
                            title: 'Ent.\n20%',
                            radius: 60,
                            titleStyle: GoogleFonts.inter(
                                color: Colors.white, fontWeight: FontWeight.bold, fontSize: 10),
                          ),
                          PieChartSectionData(
                            color: primaryOrange,
                            value: 15,
                            title: 'Rent\n15%',
                            radius: 60,
                            titleStyle: GoogleFonts.inter(
                                color: Colors.white, fontWeight: FontWeight.bold, fontSize: 10),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Breakdown Section
            Text(
              'Breakdown',
              style: GoogleFonts.inter(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 16),
            _buildCategoryItem('Groceries', 'RM 1,245.30', primaryPurple),
            _buildCategoryItem('Transport', 'RM 540.00', primaryBlue),
            _buildCategoryItem('Entertainment', 'RM 600.00', primaryGreen),
            _buildCategoryItem('Rent & Utilities', 'RM 1,080.50', primaryOrange),
            
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }

  Widget _buildToggleItem(String label, int index) {
    bool isSelected = _reportTypeIndex == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _reportTypeIndex = index),
        child: Container(
          decoration: BoxDecoration(
            color: isSelected ? Colors.black : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: GoogleFonts.inter(
              color: isSelected ? Colors.white : Colors.black54,
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryItem(String title, String amount, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              title,
              style: GoogleFonts.inter(fontWeight: FontWeight.w600, fontSize: 15),
            ),
          ),
          Text(
            amount,
            style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 15),
          ),
        ],
      ),
    );
  }
}
