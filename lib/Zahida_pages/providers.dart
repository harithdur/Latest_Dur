import 'package:flutter/material.dart';
import 'models.dart';

class FinanceProvider extends ChangeNotifier {
  UserProfile _user = UserProfile(
    name: "Ahmad Bin Sulaiman",
    email: "ahmad.s@email.com",
    monthlyIncome: 5500.00,
    phone: "+60 12-345 6789",
    dob: DateTime(1995, 5, 12),
    address: "Kuala Lumpur, Malaysia",
  );

  List<Expense> _expenses = [
    Expense(
      id: '1',
      description: "Car Istallment",
      amount: 1500.00,
      category: "Car",
      date: DateTime.now(),
      icon: Icons.car_rental,
      color: Colors.purple,
    ),

    Expense(
      id: '1',
      description: "Lunch at Pavillion",
      amount: 850.00,
      category: "Food",
      date: DateTime.now(),
      icon: Icons.restaurant,
      color: Colors.purple,
    ),
  ];

  List<RecurringBill> _recurringBills = [
    RecurringBill(
      id: '1', title: "House Rent", schedule: "Monthly", nextDate: DateTime(2024, 6, 1), amount: 1200.00, icon: Icons.home, color: Colors.orange,
    ),
    RecurringBill(
      id: '2', title: "Netflix", schedule: "Monthly", nextDate: DateTime(2024, 6, 5), amount: 55.00, icon: Icons.subscriptions, color: Colors.red,
    ),
  ];

  UserProfile get user => _user;
  List<Expense> get expenses => _expenses;
  List<RecurringBill> get recurringBills => _recurringBills;

  double get totalExpenses => _expenses.fold(0, (sum, item) => sum + item.amount);
  double get totalMonthlyCommitments => _recurringBills.fold(0, (sum, item) => sum + item.amount);

  void addExpense(Expense expense) {
    _expenses.insert(0, expense);
    notifyListeners();
  }

  void removeExpense(String id) {
    _expenses.removeWhere((item) => item.id == id);
    notifyListeners();
  }

  // --- FUNGSI BARU UNTUK RECURRING BILLS ---
  void addRecurringBill(RecurringBill bill) {
    _recurringBills.insert(0, bill);
    notifyListeners();
  }

  void removeRecurringBill(String id) {
    _recurringBills.removeWhere((item) => item.id == id);
    notifyListeners();
  }

  void updateUser(UserProfile updatedUser) {
    _user = updatedUser;
    notifyListeners();
  }
}
