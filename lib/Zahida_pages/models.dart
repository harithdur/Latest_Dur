import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Expense {
  final String id;
  final String description;
  final double amount;
  final String category;
  final DateTime date;
  final IconData? icon;
  final Color? color;

  Expense({
    required this.id,
    required this.description,
    required this.amount,
    required this.category,
    required this.date,
    this.icon,
    this.color,
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
    required this.category,
  });
}

class UserProfile {
  final String name;
  final String email;
  final double monthlyIncome;
  final String phone;
  final DateTime dob;
  final String address;

  UserProfile({
    required this.name,
    required this.email,
    required this.monthlyIncome,
    required this.phone,
    required this.dob,
    required this.address,
  });
}