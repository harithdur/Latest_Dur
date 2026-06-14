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

  FinanceProvider() {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user != null) {
        // Jika ada user login, ambil data dari Firebase
        listenToExpenses();
        listenToIncomes();
      } else {
        // PENTING: Jika user log keluar (user == null), kita KOSONGKAN data
        // supaya mode Guest atau akaun seterusnya bersih.
        _expenses = [];
        _incomes = [];
        _expenseSubscription?.cancel(); // Hentikan stream lama
        _incomeSubscription?.cancel();  // Hentikan stream lama
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
        return Expense(
          id: doc.id,
          description: doc['title'] ?? '',
          amount: (doc['amount'] as num).toDouble(),
          category: doc['category'] ?? 'General',
          date: (doc['date'] as Timestamp).toDate(),
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

  // --- KOD BARU UNTUK addExpense ---
  // Gantikan dari baris 'Future<void> addExpense...' sampai '}' penutupnya
  Future<void> addExpense(Expense expense) async {
    User? user = _auth.currentUser;
    print("DEBUG ADD: User semasa adalah: ${user?.uid ?? 'NULL (GUEST MODE)'}");

    if (user == null) {
      _expenses.insert(0, expense);
      notifyListeners();
      return;
    }

    try {
      print("DEBUG ADD: Sedang hantar data ke user: ${user.uid}");
      await _firestore.collection('users').doc(user.uid).collection('transactions').add({
        'title': expense.description,
        'amount': expense.amount,
        'category': expense.category,
        'date': Timestamp.fromDate(expense.date),
        'type': 'expense',
      });

      notifyListeners();
      print("DEBUG ADD: Success!");
    } catch (e) {
      print("DEBUG ADD: Fail! Error: $e");
    }
  }

  // --- KOD BARU UNTUK addIncome ---
  // Gantikan dari baris 'Future<void> addIncome...' sampai '}' penutupnya
  Future<void> addIncome(String title, double amount, String category) async {
    User? user = _auth.currentUser;

    if (user == null) {
      // MODE GUEST: Simpan dalam memori sahaja
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

    // MODE USER: Simpan ke Firebase
    try {
      await _firestore.collection('users').doc(user.uid).collection('transactions').add({
        'title': title,
        'amount': amount,
        'category': category,
        'date': Timestamp.now(),
        'type': 'income',
      });

      notifyListeners();
      print("Berjaya simpan income ke Firebase");
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

  // Tambah dalam lib/Dur_pages/providers.dart

  Future<void> resetAllData() async {
    User? user = _auth.currentUser;

    if (user == null) {
      // --- MODE GUEST: Reset memori sahaja ---
      _expenses = [];
      _incomes = [];
      _recurringBills = [];
      notifyListeners();
    } else {
      // --- MODE USER: Padam semua data dalam Firestore ---
      try {
        // Dapatkan rujukan koleksi transaksi
        final collectionRef = _firestore.collection('users').doc(user.uid).collection('transactions');

        // Ambil semua dokumen dalam koleksi tersebut
        final snapshot = await collectionRef.get();

        // Padam setiap dokumen satu demi satu
        for (var doc in snapshot.docs) {
          await doc.reference.delete();
        }

        // Reset list dalam aplikasi
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

