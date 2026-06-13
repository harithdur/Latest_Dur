import 'package:flutter/material.dart';

class Expense {
  final String id;
  final String description;
  final double amount;
  final String category;
  final DateTime date;
  final IconData icon;
  final Color color;

  Expense({
    required this.id,
    required this.description,
    required this.amount,
    required this.category,
    required this.date,
    required this.icon,
    required this.color,
  });
}

class RecurringBill {
  final String id;
  final String title;
  final String schedule;
  final DateTime nextDate;
  final double amount;
  final IconData icon;
  final Color color;
  final String category;

  RecurringBill({
    required this.id,
    required this.title,
    required this.schedule,
    required this.nextDate,
    required this.amount,
    required this.icon,
    required this.color,
    this.category = "Subscription",
  });
}

class UserProfile {
  String name;
  String email;
  double monthlyIncome;
  String phone;
  DateTime dob;
  String address;

  UserProfile({
    required this.name,
    required this.email,
    required this.monthlyIncome,
    required this.phone,
    required this.dob,
    required this.address,
  });
}
