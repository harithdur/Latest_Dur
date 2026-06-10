import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';

class BudgetPage extends StatefulWidget {
  const BudgetPage({super.key});

  @override
  State<BudgetPage> createState() => _BudgetPageState();
}

class _BudgetPageState extends State<BudgetPage> with SingleTickerProviderStateMixin {
  late AnimationController _waveController;

  @override
  void initState() {
    super.initState();
    _waveController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();
  }

  @override
  void dispose() {
    _waveController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const Color bgColor = Color(0xFFF5F5F5);
    const Color primaryPurple = Color(0xFF8B5CF6);

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('Budget Plan', 
          style: GoogleFonts.inter(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 18)),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                _buildMonthPicker(),
                const SizedBox(height: 24),
                _buildBudgetHero(primaryPurple),
                const SizedBox(height: 32),
                _buildQuickActions(),
                const SizedBox(height: 32),
                Text('Categories', 
                  style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black)),
                const SizedBox(height: 16),
                _buildCategoryGrid(), // Kotak muat 3 sebaris
                const SizedBox(height: 120),
              ],
            ),
          ),
          _buildFloatingBottomNav(),
        ],
      ),
    );
  }

  Widget _buildMonthPicker() {
    List<String> months = ["March", "April", "May", "June"];
    int selectedIndex = 1; // April
    return SizedBox(
      height: 45,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: months.length,
        itemBuilder: (context, index) {
          bool isSelected = index == selectedIndex;
          return Container(
            margin: const EdgeInsets.only(right: 12),
            padding: const EdgeInsets.symmetric(horizontal: 24),
            decoration: BoxDecoration(
              color: isSelected ? Colors.black : Colors.white,
              borderRadius: BorderRadius.circular(25),
              border: Border.all(color: isSelected ? Colors.black : Colors.black12),
            ),
            child: Center(
              child: Text(
                months[index],
                style: GoogleFonts.inter(
                  color: isSelected ? Colors.white : Colors.black38,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildBudgetHero(Color purple) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(35),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 20, offset: const Offset(0, 10))],
      ),
      child: Column(
        children: [
          Text("Monthly budget", style: GoogleFonts.inter(color: Colors.black38, fontSize: 14, fontWeight: FontWeight.w500)),
          const SizedBox(height: 8),
          Text("RM 4,000.00", style: GoogleFonts.inter(color: Colors.black, fontSize: 32, fontWeight: FontWeight.w900)),
          const SizedBox(height: 24),
          Container(
            height: 110,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25),
              color: const Color(0xFFF3F4F6),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(25),
              child: Stack(
                children: [
                  AnimatedBuilder(
                    animation: _waveController,
                    builder: (context, child) {
                      return CustomPaint(
                        painter: _LiquidPainter(_waveController.value, 0.66, purple),
                        child: Container(),
                      );
                    },
                  ),
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.9),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text("66% USED", 
                            style: GoogleFonts.inter(color: purple, fontWeight: FontWeight.bold, fontSize: 14)),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("Spent: ", style: GoogleFonts.inter(color: Colors.white70, fontSize: 11)),
                            Text("RM 2,640.00", style: GoogleFonts.inter(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
                            const SizedBox(width: 8),
                            Container(width: 1, height: 10, color: Colors.white30),
                            const SizedBox(width: 8),
                            Text("Remaining: ", style: GoogleFonts.inter(color: Colors.white70, fontSize: 11)),
                            Text("RM 1,360.00", style: GoogleFonts.inter(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 500.ms).slideY(begin: 0.1);
  }

  Widget _buildQuickActions() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _actionItem(Icons.add, "Add"),
        _actionItem(Icons.swap_horiz, "Move"),
        _actionItem(Icons.near_me_outlined, "Send"),
        _actionItem(Icons.more_horiz, "Details"),
      ],
    );
  }

  Widget _actionItem(IconData icon, String label) {
    return Column(
      children: [
        Container(
          width: 55, height: 55,
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            border: Border.all(color: Colors.black.withOpacity(0.05)),
          ),
          child: Icon(icon, color: Colors.black, size: 22),
        ),
        const SizedBox(height: 8),
        Text(label, style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w500, color: Colors.black54)),
      ],
    );
  }

  Widget _buildCategoryGrid() {
    return GridView.count(
      crossAxisCount: 3, // TUKAR KEPADA 3 SEBARIS
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: 0.9, // Menyelaraskan tinggi kotak
      children: [
        _categoryCard("🍔", "Food", const Color(0xFF8B5CF6)),
        _categoryCard("🚗", "Transport", const Color(0xFF3B82F6)),
        _categoryCard("🛒", "Shopping", const Color(0xFF10B981)),
      ],
    );
  }

  Widget _categoryCard(String emoji, String title, Color color) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(24),
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(emoji, style: const TextStyle(fontSize: 16)),
          ),
          const Spacer(),
          Text(title, 
            style: GoogleFonts.inter(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildFloatingBottomNav() {
    return Positioned(
      bottom: 25, left: 20, right: 20,
      child: Container(
        height: 70,
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(35),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.3), blurRadius: 20, offset: const Offset(0, 10))],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _navIcon(Icons.home_outlined),
            _navIcon(Icons.wallet_outlined, isSelected: true),
            Container(
              width: 50, height: 50,
              decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
              child: const Icon(Icons.add, color: Colors.black, size: 28),
            ),
            _navIcon(Icons.bar_chart_outlined),
            _navIcon(Icons.person_outline_rounded),
          ],
        ),
      ),
    ).animate().slideY(begin: 1, duration: 600.ms, curve: Curves.easeOutBack);
  }

  Widget _navIcon(IconData icon, {bool isSelected = false}) {
    return Icon(icon, color: isSelected ? Colors.white : Colors.white54, size: 24);
  }
}

class _LiquidPainter extends CustomPainter {
  final double value;
  final double percent;
  final Color color;
  _LiquidPainter(this.value, this.percent, this.color);

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()..color = color..style = PaintingStyle.fill;
    var path = Path();
    double waveHeight = 8;
    double fillLevel = size.height * (1 - percent);

    path.moveTo(0, size.height);
    path.lineTo(0, fillLevel);
    for (double i = 0; i <= size.width; i++) {
      path.lineTo(i, fillLevel + math.sin((i / size.width * 2 * math.pi) + (value * 2 * math.pi)) * waveHeight);
    }
    path.lineTo(size.width, size.height);
    path.close();
    canvas.drawPath(path, paint);
  }
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
