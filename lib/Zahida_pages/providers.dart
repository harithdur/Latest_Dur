import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'models.dart';
import 'dart:async'; // Pastikan import ini ada

class FinanceProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Tambah baris ini untuk simpan 'langganan' stream
  StreamSubscription? _expenseSubscription;
  StreamSubscription? _incomeSubscription;

  List<Expense> _expenses = [];
  List<Map<String, dynamic>> _incomes = [];
  List<RecurringBill> _recurringBills = [];

  List<Expense> get expenses => _expenses;
  List<Map<String, dynamic>> get incomes => _incomes;
  List<RecurringBill> get recurringBills => _recurringBills;

  double get totalIncome => _incomes.fold(0.0, (sum, item) => sum + (item['amount'] as num).toDouble());
  double get totalExpenses => _expenses.fold(0.0, (sum, item) => sum + item.amount);
  double get totalBalance => totalIncome - totalExpenses;
  double get totalMonthlyCommitments => _recurringBills.fold(0.0, (sum, item) => sum + item.amount);

  // ==========================================
  // DIUBAH: Mengawal ketat pertukaran state login/logout
  // ==========================================
  FinanceProvider() {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user != null) {
        // Jika ada user login, ambil data dari Firebase
        listenToExpenses();
        listenToIncomes();
      } else {
        // Mod Guest / Log Keluar: Wajib kosongkan semua data lokal!
        _expenses = [];
        _incomes = [];
        _recurringBills = [];

        // Hentikan langganan stream lama supaya data User tidak bocor atau bertindih
        _expenseSubscription?.cancel();
        _incomeSubscription?.cancel();
        notifyListeners();
      }
    });
  }

  void listenToExpenses() {
    // 1. Batalkan stream lama jika ada supaya tidak berlaku pertindihan
    _expenseSubscription?.cancel();

    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    // 2. Simpan stream baru ke dalam _expenseSubscription
    _expenseSubscription = _firestore.collection('users').doc(user.uid).collection('transactions')
        .where('type', isEqualTo: 'expense')
        .orderBy('date', descending: true)
        .snapshots().listen((snapshot) {
      _expenses = snapshot.docs.map((doc) {
        final data = doc.data();

        // Fungsi pembantu lokal untuk memberikan ikon mengikut kategori supaya tidak null
        IconData getIcon(String cat) {
          if (cat == 'Food') return Icons.restaurant;
          if (cat == 'Transport') return Icons.directions_car;
          if (cat == 'Bills') return Icons.receipt_long;
          if (cat == 'Shopping') return Icons.shopping_bag;
          return Icons.category;
        }

        // Fungsi pembantu lokal untuk memberikan warna mengikut kategori supaya tidak null
        Color getColor(String cat) {
          if (cat == 'Food') return Colors.orange;
          if (cat == 'Transport') return Colors.blue;
          if (cat == 'Bills') return Colors.green;
          if (cat == 'Shopping') return Colors.pink;
          return Colors.purple;
        }

        return Expense(
          id: doc.id,
          description: data['title'] ?? data['description'] ?? '',
          amount: (data['amount'] as num? ?? 0.0).toDouble(),
          category: data['category'] ?? 'General',
          date: data['date'] != null ? (data['date'] as Timestamp).toDate() : DateTime.now(),
          icon: getIcon(data['category'] ?? 'General'),
          color: getColor(data['category'] ?? 'General'),
        );
      }).toList();
      notifyListeners();
    });
  }

  // Lakukan perkara yang sama untuk listenToIncomes
  void listenToIncomes() {
    _incomeSubscription?.cancel(); // Batalkan stream lama

    User? user = _auth.currentUser;
    if (user == null) return;

    _incomeSubscription = _firestore.collection('users').doc(user.uid).collection('transactions')
        .where('type', isEqualTo: 'income')
        .orderBy('date', descending: true)
        .snapshots().listen((snapshot) {
      _incomes = snapshot.docs.map((doc) {
        final data = doc.data();
        DateTime dt = data['date'] != null ? (data['date'] as Timestamp).toDate() : DateTime.now();

        return {
          'id': doc.id,
          'title': data['title'] ?? '',
          'amount': (data['amount'] as num? ?? 0.0).toDouble(),
          'category': data['category'] ?? 'General',
          'date': DateFormat('dd MMM').format(dt),
        };
      }).toList();
      notifyListeners();
    });
  }

  // ==========================================
  // DIUBAH: Sekatan ketat penulisan data Guest Mode
  // ==========================================
  Future<void> addExpense(Expense expense) async {
    User? currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser == null) {
      // MODE GUEST: Simpan dalam memori sahaja dan terus SEKAT (return) supaya tidak ke Firestore
      _expenses.insert(0, expense);
      notifyListeners();
      return;
    }

    // MODE USER: Hanya hantar ke Firestore jika currentUser terbukti ada
    try {
      await _firestore.collection('users').doc(currentUser.uid).collection('transactions').add({
        'title': expense.description,
        'amount': expense.amount,
        'category': expense.category,
        'date': Timestamp.fromDate(expense.date),
        'type': 'expense',
      });
      // Tidak perlu notifyListeners() di sini kerana diuruskan oleh stream snapshots secara real-time
    } catch (e) {
      print("Gagal simpan expense ke Firebase: $e");
    }
  }

  // ==========================================
  // DIUBAH: Sekatan ketat penulisan data Guest Mode
  // ==========================================
  Future<void> addIncome(String title, double amount, String category) async {
    User? currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser == null) {
      // MODE GUEST: Simpan dalam memori sahaja dan terus SEKAT (return) supaya tidak ke Firestore
      _incomes.insert(0, {
        'id': DateTime.now().toString(),
        'title': title,
        'amount': amount,
        'category': category,
        'date': DateFormat('dd MMM').format(DateTime.now()),
      });
      notifyListeners();
      return;
    }

    // MODE USER: Hanya hantar ke Firestore jika currentUser terbukti ada
    try {
      await _firestore.collection('users').doc(currentUser.uid).collection('transactions').add({
        'title': title,
        'amount': amount,
        'category': category,
        'date': Timestamp.now(),
        'type': 'income',
      });
      // Tidak perlu notifyListeners() di sini kerana diuruskan oleh stream snapshots secara real-time
    } catch (e) {
      print("Gagal simpan income: $e");
    }
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

  Future<void> resetAllData() async {
    User? user = _auth.currentUser;

    if (user == null) {
      _expenses = [];
      _incomes = [];
      _recurringBills = [];
      notifyListeners();
    } else {
      try {
        final collectionRef = _firestore.collection('users').doc(user.uid).collection('transactions');
        final snapshot = await collectionRef.get();

        for (var doc in snapshot.docs) {
          await doc.reference.delete();
        }

        _expenses = [];
        _incomes = [];
        _recurringBills = [];
        notifyListeners();
      } catch (e) {
        print("Gagal reset data: $e");
      }
    }
  }
}