import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TransactionsPage extends StatelessWidget {
  const TransactionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    const Color bgColor = Colors.white;
    const Color primaryText = Color(0xFF1A1A1A);
    const Color secondaryText = Color(0xFF8C8C8C);
    const Color accentPurple = Color(0xFF8B5CF6);
    const Color canvasGrey = Color(0xFFF3F4F6);

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: bgColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: primaryText),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Wallet details',
          style: GoogleFonts.inter(
            fontWeight: FontWeight.bold,
            color: primaryText,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.person_add_outlined, color: primaryText)),
          IconButton(onPressed: () {}, icon: const Icon(Icons.more_horiz, color: primaryText)),
        ],
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                // 1. Purple Wallet Card
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: accentPurple,
                    borderRadius: BorderRadius.circular(32),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Icon(Icons.shopping_bag, color: Colors.white, size: 28),
                      ),
                      const SizedBox(width: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Groceries',
                            style: GoogleFonts.inter(color: Colors.white70, fontSize: 14),
                          ),
                          Text(
                            '\$1,245.30',
                            style: GoogleFonts.inter(
                              color: Colors.white,
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),

                // 2. Date & Spend Selector
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'September, 2025',
                      style: GoogleFonts.inter(color: primaryText, fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                    const Row(
                      children: [
                        Icon(Icons.arrow_back_ios, size: 14, color: primaryText),
                        SizedBox(width: 16),
                        Icon(Icons.arrow_forward_ios, size: 14, color: primaryText),
                      ],
                    )
                  ],
                ),
                const SizedBox(height: 8),
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: '\$124.52 ',
                        style: GoogleFonts.inter(color: primaryText, fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      TextSpan(
                        text: 'Spent',
                        style: GoogleFonts.inter(color: secondaryText, fontSize: 14),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // 3. Line Chart
                SizedBox(
                  height: 120,
                  width: double.infinity,
                  child: Stack(
                    children: [
                      CustomPaint(
                        size: Size.infinite,
                        painter: _SpendingLinePainter(accentPurple),
                      ),
                      // Tooltip Marker (Sep 7)
                      Positioned(
                        left: MediaQuery.of(context).size.width * 0.4,
                        top: 20,
                        child: Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                              decoration: BoxDecoration(
                                color: Colors.black,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Column(
                                children: [
                                  Text('\$82.75', style: GoogleFonts.inter(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                                  Text('Sep 7, 2025', style: GoogleFonts.inter(color: Colors.white70, fontSize: 8)),
                                ],
                              ),
                            ),
                            Container(width: 1, height: 40, color: accentPurple.withValues(alpha: 0.3)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Sep 1', style: GoogleFonts.inter(color: secondaryText, fontSize: 10)),
                    Text('Sep 7', style: GoogleFonts.inter(color: secondaryText, fontSize: 10)),
                    Text('Sep 15', style: GoogleFonts.inter(color: secondaryText, fontSize: 10)),
                  ],
                ),

                const SizedBox(height: 32),

                // 4. Search Bar
                TextField(
                  decoration: InputDecoration(
                    hintText: 'Search for any transaction',
                    hintStyle: GoogleFonts.inter(color: secondaryText, fontSize: 14),
                    prefixIcon: const Icon(Icons.search, color: secondaryText),
                    filled: true,
                    fillColor: canvasGrey,
                    contentPadding: const EdgeInsets.symmetric(vertical: 0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),

                const SizedBox(height: 32),
                Text(
                  'Latest transaction',
                  style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.bold, color: primaryText),
                ),
                const SizedBox(height: 16),

                // 5. Transaction List
                _buildTransactionItem('Supermart Groceries', 'Sep 14, 2025', '52.30', 'Card .... 1234', canvasGrey, primaryText, secondaryText),
                _buildTransactionItem('Fresh Bakery', 'Sep 13, 2025', '30.45', 'Paid with Visa', canvasGrey, primaryText, secondaryText),
                _buildTransactionItem('Gas Station', 'Sep 11, 2025', '45.06', 'Card .... 1234', canvasGrey, primaryText, secondaryText),

                const SizedBox(height: 120),
              ],
            ),
          ),

          // 6. Floating Action Bar (Black Pill)
          Positioned(
            bottom: 30,
            left: 24,
            right: 24,
            child: Container(
              height: 64,
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(32),
                boxShadow: [
                  BoxShadow(color: Colors.black.withValues(alpha: 0.2), blurRadius: 15, offset: const Offset(0, 8))
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _actionItem(Icons.add, 'Add'),
                  _actionItem(Icons.swap_horiz, 'Move'),
                  _actionItem(Icons.near_me_outlined, 'Send'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionItem(String title, String date, String amount, String detail, Color bg, Color pText, Color sText) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: bg,
            radius: 20,
            child: const Icon(Icons.shopping_bag_outlined, color: Colors.black, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 15, color: pText)),
                const SizedBox(height: 2),
                Text(date, style: GoogleFonts.inter(color: sText, fontSize: 12)),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text('-\$ $amount', style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 15, color: pText)),
              const SizedBox(height: 2),
              Text(detail, style: GoogleFonts.inter(color: sText, fontSize: 10)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _actionItem(IconData icon, String label) {
    return Row(
      children: [
        Icon(icon, color: Colors.white, size: 20),
        const SizedBox(width: 6),
        Text(
          label,
          style: GoogleFonts.inter(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}

class _SpendingLinePainter extends CustomPainter {
  final Color color;
  _SpendingLinePainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final path = Path();
    path.moveTo(0, size.height * 0.7);
    path.cubicTo(
      size.width * 0.2, size.height * 0.8,
      size.width * 0.3, size.height * 0.2,
      size.width * 0.45, size.height * 0.3,
    );
    path.cubicTo(
      size.width * 0.6, size.height * 0.4,
      size.width * 0.75, size.height * 0.8,
      size.width * 0.9, size.height * 0.5,
    );
    path.lineTo(size.width, size.height * 0.4);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
