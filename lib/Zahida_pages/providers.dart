import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'models.dart';

class FinanceProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  List<Expense> _expenses = [];
  List<Map<String, dynamic>> _incomes = [];
  List<RecurringBill> _recurringBills = [];

  List<Expense> get expenses => _expenses;
  List<Map<String, dynamic>> get incomes => _incomes;
  List<RecurringBill> get recurringBills => _recurringBills;

  // Base values for Guest Mode
  double _guestIncome = 15000.00;
  double _guestExpense = 4500.00;

  double get totalIncome {
    if (_incomes.isEmpty && _auth.currentUser == null) return _guestIncome;
    return _incomes.fold(0.0, (sum, item) => sum + (item['amount'] as num).toDouble());
  }

  double get totalExpenses {
    if (_expenses.isEmpty && _auth.currentUser == null) return _guestExpense;
    return _expenses.fold(0.0, (sum, item) => sum + item.amount);
  }

  double get totalBalance => totalIncome - totalExpenses;
  double get totalMonthlyCommitments => _recurringBills.fold(0.0, (sum, item) => sum + item.amount);

  FinanceProvider() {
    _init();
  }

  void _init() {
    _auth.authStateChanges().listen((user) {
      if (user != null) {
        listenToExpenses();
        listenToIncomes();
      } else {
        _expenses = [];
        _incomes = [];
        notifyListeners();
      }
    });
  }

  void listenToExpenses() {
    User? user = _auth.currentUser;
    if (user == null) return;

    _firestore.collection('users').doc(user.uid).collection('transactions')
        .where('type', isEqualTo: 'expense')
        .orderBy('date', descending: true)
        .snapshots().listen((snapshot) {
      _expenses = snapshot.docs.map((doc) {
        return Expense(
          id: doc.id,
          description: doc['title'] ?? '',
          amount: (doc['amount'] as num).toDouble(),
          category: doc['category'] ?? 'General',
          date: (doc['date'] as Timestamp).toDate(),
          color: _getColorForCategory(doc['category'] ?? ''),
          icon: _getIconForCategory(doc['category'] ?? ''),
        );
      }).toList();
      notifyListeners();
    });
  }

  void listenToIncomes() {
    User? user = _auth.currentUser;
    if (user == null) return;

    _firestore.collection('users').doc(user.uid).collection('transactions')
        .where('type', isEqualTo: 'income')
        .orderBy('date', descending: true)
        .snapshots().listen((snapshot) {
      _incomes = snapshot.docs.map((doc) {
        return {
          'id': doc.id,
          'title': doc['title'],
          'amount': doc['amount'],
          'category': doc['category'],
          'date': DateFormat('dd MMM').format((doc['date'] as Timestamp).toDate()),
        };
      }).toList();
      notifyListeners();
    });
  }

  Future<void> addExpense(Expense expense) async {
    User? user = _auth.currentUser;
    if (user == null) {
      _expenses.insert(0, expense);
      _guestExpense = 0; // Stop using base value once user adds data
      notifyListeners();
      return;
    }
    await _firestore.collection('users').doc(user.uid).collection('transactions').add({
      'title': expense.description,
      'amount': expense.amount,
      'category': expense.category,
      'date': Timestamp.fromDate(expense.date),
      'type': 'expense',
    });
  }

  Future<void> addIncome(String title, double amount, String category, DateTime date) async {
    User? user = _auth.currentUser;
    if (user == null) {
      _incomes.insert(0, {
        'id': DateTime.now().toString(),
        'title': title,
        'amount': amount,
        'category': category,
        'date': DateFormat('dd MMM').format(date),
      });
      _guestIncome = 0;
      notifyListeners();
      return;
    }
    await _firestore.collection('users').doc(user.uid).collection('transactions').add({
      'title': title,
      'amount': amount,
      'category': category,
      'date': Timestamp.fromDate(date),
      'type': 'income',
    });
  }

  Future<void> removeExpense(String id) async {
    User? user = _auth.currentUser;
    if (user == null) {
      _expenses.removeWhere((e) => e.id == id);
      notifyListeners();
      return;
    }
    await _firestore.collection('users').doc(user.uid).collection('transactions').doc(id).delete();
  }

  Future<void> removeIncome(String id) async {
    User? user = _auth.currentUser;
    if (user == null) {
      _incomes.removeWhere((i) => i['id'] == id);
      notifyListeners();
      return;
    }
    await _firestore.collection('users').doc(user.uid).collection('transactions').doc(id).delete();
  }

  void addRecurringBill(RecurringBill bill) {
    _recurringBills.insert(0, bill);
    notifyListeners();
  }

  void removeRecurringBill(String id) {
    _recurringBills.removeWhere((item) => item.id == id);
    notifyListeners();
  }

  // Helpers
  Color _getColorForCategory(String cat) {
    switch (cat) {
      case 'Food': return Colors.orange;
      case 'Transport': return Colors.blue;
      case 'Bills': return Colors.green;
      case 'Shopping': return Colors.pink;
      default: return Colors.purple;
    }
  }

  IconData _getIconForCategory(String cat) {
    switch (cat) {
      case 'Food': return Icons.restaurant;
      case 'Transport': return Icons.directions_car;
      case 'Bills': return Icons.receipt_long;
      case 'Shopping': return Icons.shopping_bag;
      default: return Icons.category;
    }
  }
}
