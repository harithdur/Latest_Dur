import 'package:flutter/material.dart';
import 'dart:math';

class InsightItem {
  final IconData icon;
  final Color color;
  final String text;

  InsightItem({required this.icon, required this.color, required this.text});
}

class InsightsPage extends StatefulWidget {
  const InsightsPage({super.key});

  @override
  State<InsightsPage> createState() => _InsightsPageState();
}

class _InsightsPageState extends State<InsightsPage> {
  final List<InsightItem> allInsights = [
    InsightItem(
      icon: Icons.trending_up,
      color: Colors.red,
      text: "National inflation has been rising for the past few months. Consider reviewing your spending habits and prioritizing essential expenses.",
    ),
    InsightItem(
      icon: Icons.shopping_cart,
      color: Colors.orange,
      text: "Consumer prices are trending upward. Planning your purchases ahead may help you manage costs more effectively.",
    ),
    InsightItem(
      icon: Icons.local_gas_station,
      color: Colors.brown,
      text: "Fuel prices have increased recently. Monitoring transportation expenses could help keep your budget on track.",
    ),
    InsightItem(
      icon: Icons.percent,
      color: Colors.blueGrey,
      text: "Interest rates remain elevated. Consider limiting unnecessary debt and credit usage where possible.",
    ),
    InsightItem(
      icon: Icons.monetization_on,
      color: Colors.green,
      text: "Inflation can reduce the purchasing power of your savings. Regular saving habits can help offset its impact.",
    ),
    InsightItem(
      icon: Icons.warning_amber_rounded,
      color: Colors.amber,
      text: "Economic uncertainty may affect household expenses. Maintaining an emergency fund is recommended.",
    ),
    InsightItem(
      icon: Icons.query_stats,
      color: Colors.indigo,
      text: "Cost-of-living pressures continue to impact consumers nationwide. Reviewing your monthly budget can help identify savings opportunities.",
    ),
    InsightItem(
      icon: Icons.track_changes,
      color: Colors.teal,
      text: "Small spending adjustments today can make a significant difference to your long-term financial goals.",
    ),
    InsightItem(
      icon: Icons.account_balance,
      color: Colors.blue,
      text: "Financial experts recommend maintaining at least 3–6 months of emergency savings for greater financial resilience.",
    ),
    InsightItem(
      icon: Icons.eco,
      color: Colors.green,
      text: "Consistent saving, even in small amounts, can help build long-term financial security.",
    ),
    InsightItem(
      icon: Icons.trending_up,
      color: Colors.red,
      text: "Rising inflation may impact your purchasing power. Consider reviewing your monthly budget to stay on track.",
    ),
    InsightItem(
      icon: Icons.savings,
      color: Colors.green,
      text: "Building an emergency fund can help protect your finances during periods of economic uncertainty.",
    ),
    InsightItem(
      icon: Icons.compare_arrows,
      color: Colors.blue,
      text: "Prices of everyday essentials can change over time. Comparing options before purchasing may help reduce expenses.",
    ),
    InsightItem(
      icon: Icons.assignment,
      color: Colors.indigo,
      text: "Consistent expense tracking is one of the most effective ways to improve financial awareness and control spending.",
    ),
    InsightItem(
      icon: Icons.credit_card,
      color: Colors.red,
      text: "Making only minimum credit card payments may increase the total interest paid over time.",
    ),
    InsightItem(
      icon: Icons.subscriptions,
      color: Colors.purple,
      text: "Reviewing recurring subscriptions periodically may help identify services you no longer use or need.",
    ),
  ];

  late List<InsightItem> displayedInsights;

  @override
  void initState() {
    super.initState();
    _refreshInsights();
  }

  void _refreshInsights() {
    final random = Random();
    List<InsightItem> shuffled = List.from(allInsights)..shuffle(random);
    displayedInsights = shuffled.take(8).toList();
  }

  @override
  Widget build(BuildContext context) {
    // We return just the body content because main.dart handles the Scaffold/AppBar
    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
      itemCount: displayedInsights.length,
      separatorBuilder: (context, index) => const SizedBox(height: 15),
      itemBuilder: (context, index) {
        final item = displayedInsights[index];
        return _buildInsightCard(
          icon: item.icon,
          iconColor: item.color,
          text: item.text,
        );
      },
    );
  }

  Widget _buildInsightCard({required IconData icon, required Color iconColor, required String text}) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: Colors.black12, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(icon, color: iconColor, size: 35),
          const SizedBox(width: 20),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
