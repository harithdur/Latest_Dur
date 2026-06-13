import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'dart:ui';

class BudgetPage extends StatefulWidget {
  final VoidCallback? onBack;
  const BudgetPage({super.key, this.onBack});

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
    const Color primaryPurple = Color(0xFF8B5CF6);
    const Color bgColor = Color(0xFFF9FAFB);

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
        title: Text('Budget Plan', 
          style: GoogleFonts.inter(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 18)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20), // Padding dikurangkan sikit
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            _buildMonthPicker().animate().fadeIn(duration: 300.ms),
            const SizedBox(height: 32),
            
            _buildBudgetGlassHero(primaryPurple),
            
            const SizedBox(height: 32),
            _buildQuickStats().animate().fadeIn(delay: 150.ms, duration: 300.ms).slideY(begin: 0.1),
            
            const SizedBox(height: 32),
            Text('Budget Allocation (100%)', 
              style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87)),
            const SizedBox(height: 16),
            
            _buildCategoryGrid(),
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }

  Widget _buildBudgetGlassHero(Color themeColor) {
    return Container(
      width: double.infinity,
      height: 200,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(32),
        gradient: LinearGradient(
          colors: [themeColor.withOpacity(0.9), themeColor.withOpacity(0.7)],
          begin: Alignment.topLeft, end: Alignment.bottomRight,
        ),
        boxShadow: [BoxShadow(color: themeColor.withOpacity(0.3), blurRadius: 20, offset: const Offset(0, 10))],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(32),
        child: Stack(
          children: [
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.transparent, Colors.white.withOpacity(0.1), Colors.transparent],
                    stops: const [0.3, 0.5, 0.7],
                    begin: const Alignment(-1.5, -1.0), end: const Alignment(1.5, 1.0),
                  ),
                ),
              ).animate(onPlay: (c) => c.repeat()).shimmer(duration: 1800.ms, color: Colors.white.withOpacity(0.1)),
            ),
            AnimatedBuilder(
              animation: _waveController,
              builder: (context, child) {
                return CustomPaint(
                  painter: _LiquidPainter(_waveController.value, 0.66, Colors.white.withOpacity(0.15)),
                  child: Container(),
                );
              },
            ),
            BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.white.withOpacity(0.1), Colors.white.withOpacity(0.02)],
                  ),
                  border: Border.all(color: Colors.white.withOpacity(0.2), width: 1.5),
                  borderRadius: BorderRadius.circular(32),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Monthly budget", style: GoogleFonts.inter(color: Colors.white.withOpacity(0.8), fontSize: 13, fontWeight: FontWeight.w500)),
                  const SizedBox(height: 4),
                  FittedBox( // DIBETULKAN
                    fit: BoxFit.scaleDown,
                    child: Text("RM 3,000.00", style: GoogleFonts.inter(color: Colors.white, fontSize: 36, fontWeight: FontWeight.w900)),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text("66% USED", style: GoogleFonts.inter(color: themeColor, fontWeight: FontWeight.bold, fontSize: 13)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ).animate().fadeIn(duration: 400.ms).scale(begin: const Offset(0.95, 0.95));
  }

  Widget _buildQuickStats() {
    return Row(
      children: [
        Expanded(child: _miniStatCard("Spent", "RM 1,800", Colors.redAccent)),
        const SizedBox(width: 12),
        Expanded(child: _miniStatCard("Remaining", "RM 1,200", Colors.green)),
      ],
    );
  }

  Widget _miniStatCard(String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: GoogleFonts.inter(color: Colors.black38, fontSize: 11, fontWeight: FontWeight.w500)),
          const SizedBox(height: 2),
          FittedBox( // DIBETULKAN
            fit: BoxFit.scaleDown,
            child: Text(value, style: GoogleFonts.inter(color: color, fontSize: 16, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  Widget _buildMonthPicker() {
    List<String> months = ["March", "April", "May", "June"];
    int selected = 1;
    return SizedBox(
      height: 40,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: months.length,
        itemBuilder: (context, index) {
          bool isSelected = index == selected;
          return MouseRegion(
            cursor: SystemMouseCursors.click,
            child: Container(
              margin: const EdgeInsets.only(right: 10),
              padding: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: isSelected ? Colors.black : Colors.white,
                borderRadius: BorderRadius.circular(25),
                border: Border.all(color: isSelected ? Colors.black : Colors.black12),
              ),
              child: Center(
                child: Text(months[index],
                  style: GoogleFonts.inter(color: isSelected ? Colors.white : Colors.black38, fontWeight: FontWeight.w600, fontSize: 13)),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildCategoryGrid() {
    return GridView.count(
      crossAxisCount: 3,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      childAspectRatio: 0.7, 
      children: AnimateList(
        interval: 30.ms,
        effects: [FadeEffect(duration: 200.ms), ScaleEffect(begin: const Offset(0.9, 0.9))],
        children: [
          _categoryCard('Food', '40%', const Color(0xFF8B5CF6), 'https://img.icons8.com/color/96/hamburger.png'),
          _categoryCard('Trans', '20%', const Color(0xFF3B82F6), 'https://img.icons8.com/color/96/car--v1.png'),
          _categoryCard('Shop', '15%', const Color(0xFF10B981), 'https://img.icons8.com/color/96/shopping-cart.png'),
          _categoryCard('Bills', '15%', const Color(0xFFF59E0B), 'https://img.icons8.com/color/96/bill.png'),
          _categoryCard('Ent.', '10%', const Color(0xFFEC4899), 'https://img.icons8.com/color/96/controller.png'),
          _addCategoryCard(),
        ],
      ),
    );
  }

  Widget _categoryCard(String title, String percentage, Color color, String imageUrl) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: Container(
        decoration: BoxDecoration(
          color: color.withOpacity(0.08),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: color.withOpacity(0.15)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Flexible(child: Image.network(imageUrl, width: 36, height: 32)),
            const SizedBox(height: 6),
            Text(title, style: GoogleFonts.inter(color: color, fontSize: 10, fontWeight: FontWeight.bold), overflow: TextOverflow.ellipsis),
            const SizedBox(height: 4),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: color.withOpacity(0.2), 
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                percentage,
                style: GoogleFonts.inter(color: color, fontSize: 9, fontWeight: FontWeight.w800),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _addCategoryCard() {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: Colors.black12, style: BorderStyle.solid),
        ),
        child: const Icon(Icons.add, color: Colors.black26, size: 24),
      ),
    );
  }
}

class _LiquidPainter extends CustomPainter {
  final double value;
  final double percent;
  final Color color;
  _LiquidPainter(this.value, this.percent, this.color);
  @override
  void paint(Canvas canvas, Size size) {
    var fillPaint = Paint()..color = color..style = PaintingStyle.fill;
    var wavePath = Path();
    double waveHeight = 10;
    double fillLevel = size.height * (1 - percent);
    wavePath.moveTo(0, size.height);
    wavePath.lineTo(0, fillLevel);
    for (double i = 0; i <= size.width; i++) {
      wavePath.lineTo(i, fillLevel + math.sin((i / size.width * 2 * math.pi) + (value * 2 * math.pi)) * waveHeight);
    }
    wavePath.lineTo(size.width, size.height);
    wavePath.close();
    canvas.drawPath(wavePath, fillPaint);
    var neonPath = Path();
    neonPath.moveTo(0, fillLevel + math.sin((value * 2 * math.pi)) * waveHeight);
    for (double i = 0; i <= size.width; i++) {
      neonPath.lineTo(i, fillLevel + math.sin((i / size.width * 2 * math.pi) + (value * 2 * math.pi)) * waveHeight);
    }
    var sharpNeonPaint = Paint()..color = Colors.white.withOpacity(0.9)..style = PaintingStyle.stroke..strokeWidth = 2.5..strokeCap = StrokeCap.round;
    canvas.drawPath(neonPath, sharpNeonPaint);
  }
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
