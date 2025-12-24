/*
import 'package:ay_bay/core/services/firestore_service.dart';
import 'package:ay_bay/features/common/models/transaction_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class HomeController extends GetxController {
  final totalBalance = 0.0.obs;
  final currentBalance = 0.0.obs;
  final income = 0.0.obs;
  final expense = 0.0.obs;
  final _db = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  final transactions = <QueryDocumentSnapshot>[].obs;
  RxList<Map<String, dynamic>> allTransactions = <Map<String, dynamic>>[].obs;
  RxList<Map<String, dynamic>> mTransactions = <Map<String, dynamic>>[].obs;
  RxString filterCategory = 'সব'.obs;
  RxList<DocumentSnapshot> monthList = <DocumentSnapshot>[].obs;

  String? get uid => _auth.currentUser?.uid;
  RxList<TransactionModel> tmTransactions = <TransactionModel>[].obs;


  @override
  void onInit() {
    super.onInit();
    _listenTransactions();
    fetchTransactions();
    fetchMonthDashboard();
  }

  void fetchTransactions() {
    final user = _auth.currentUser;
    if (user == null) return; // যদি লগিন না থাকে

    _db.collection('users')
        .doc(user.uid)
        .collection('transactions')
        .orderBy('date', descending: true)
        .snapshots()
        .listen((snapshot) {
      allTransactions.value = snapshot.docs.map((doc) => doc.data()).toList();
      applyFilter();
    });

  }

  void applyFilter() {
    if (filterCategory.value == 'সব') {
      transactions.value = List.from(allTransactions);
    }
    else if (filterCategory.value == 'আয়' || filterCategory.value == 'ব্যয়') {
      mTransactions.value = allTransactions
          .where((trx) => trx['type'] == filterCategory.value.toLowerCase())
          .toList();
    }
    else if (filterCategory.value == 'মাসিক') {
      final now = DateTime.now();
      final currentMonth = DateFormat('yyyy-MM').format(now);

      mTransactions.value = allTransactions.where((trx) {
        if (trx['date'] == null) return false;
        final trxDate = (trx['date'] as Timestamp).toDate();
        final trxMonth = DateFormat('yyyy-MM').format(trxDate);
        return trxMonth == currentMonth;
      }).toList();
    }
  }

  void setFilterCategory(String category) {
    filterCategory.value = category;
    applyFilter();
  }

  void _listenTransactions() {
    FirestoreService.transactionStream().listen((snapshot) {
      transactions.value = snapshot.docs;
      _calculateBalance();
    });
  }



  void _calculateBalance() {
    double totalIncome = 0;
    double totalExpense = 0;


    for (var doc in transactions) {
      final data = doc.data() as Map<String, dynamic>;
      final amount = (data['amount'] ?? 0).toDouble();

      if (data['type'] == 'income') {
        totalIncome += amount;
      } else {
        totalExpense += amount;
      }
    }

    income.value = totalIncome;
    expense.value = totalExpense;
    currentBalance.value = totalIncome - totalExpense;
  }

  void fetchMonthDashboard() {
    _db.collection('users').doc(uid).snapshots().listen((doc) {
      totalBalance.value = (doc.data()?['totalBalance'] ?? 0).toDouble();
    });

    _db
        .collection('users')
        .doc(uid)
        .collection('months')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .listen((snapshot) {
      monthList.value = snapshot.docs;
    });
  }

  Future<void> addMonth({
    required double amount,
    required String month,
    required String date,
  }) async {
    final monthRef =
    _db.collection('users').doc(uid).collection('months').doc();

    await monthRef.set({
      'amount': amount,
      'month': month,
      'date': date,
      'createdAt': Timestamp.now(),
    });

    await _db.collection('users').doc(uid).update({
      'totalBalance': FieldValue.increment(amount),
    });

    Get.back();
  }
}
*/

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class HomeController extends GetxController {
  final _db = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  /// UI State
  RxList<Map<String, dynamic>> transactions = <Map<String, dynamic>>[].obs;
  RxString filterCategory = 'সব'.obs;
  RxList<Map<String, dynamic>> months = <Map<String, dynamic>>[].obs;
  RxList<Map<String, dynamic>> allTransactions =
      <Map<String, dynamic>>[].obs;


  /// Dashboard
  RxDouble income = 0.0.obs;
  RxDouble expense = 0.0.obs;
  RxDouble balance = 0.0.obs;

  String? get uid => _auth.currentUser?.uid;

  @override
  void onInit() {
    super.onInit();
    _listenTransactions();
    _listenMonths();
  }

  /// 🔥 Firestore Stream
  void _listenTransactions() {
    if (uid == null) return;

    _db
        .collection('users')
        .doc(uid)
        .collection('transactions')
        .orderBy('date', descending: true)
        .snapshots()
        .listen((snapshot) {
      final data = snapshot.docs.map((e) => e.data()).toList();

      allTransactions.value = data;
      transactions.value = _applyFilter(data);
      _calculateDashboard(data);
    });
  }


  /// ✅ Filter Logic
  List<Map<String, dynamic>> _applyFilter(
      List<Map<String, dynamic>> data) {
    if (filterCategory.value == 'সব') return data;

    if (filterCategory.value == 'আয়') {
      return data.where((e) => e['type'] == 'income').toList();
    }

    if (filterCategory.value == 'ব্যয়') {
      return data.where((e) => e['type'] == 'expense').toList();
    }

    if (filterCategory.value == 'মাসিক') {
      final now = DateTime.now();
      final key = DateFormat('yyyy-MM').format(now);

      return data.where((e) {
        if (e['date'] == null) return false;
        final d = (e['date'] as Timestamp).toDate();
        return DateFormat('yyyy-MM').format(d) == key;
      }).toList();
    }

    return data;
  }


  /// 🔄 Change Filter
  void setFilter(String value) {
    filterCategory.value = value;
    transactions.value = _applyFilter(allTransactions);
  }


  /// 💰 Dashboard Calculation
  void _calculateDashboard(List<Map<String, dynamic>> data) {
    double inc = 0;
    double exp = 0;

    for (var e in data) {
      final amount = (e['amount'] ?? 0).toDouble();
      if (e['type'] == 'income') {
        inc += amount;
      } else {
        exp += amount;
      }
    }

    income.value = inc;
    expense.value = exp;
    balance.value = inc - exp;
  }

  void _listenMonths() {
    if (uid == null) return;

    _db
        .collection('users')
        .doc(uid)
        .collection('months')
        .orderBy('monthKey', descending: true)
        .snapshots()
        .listen((snapshot) {
      months.value =
          snapshot.docs.map((e) => e.data()).toList();
    });
  }
  Future<void> addMonth({
    required DateTime monthDate,
    required double openingBalance,
  }) async {
    if (uid == null) return;

    final monthKey = DateFormat('yyyy-MM').format(monthDate);
    final monthName = DateFormat('MMMM yyyy').format(monthDate);

    try {
      await _db
          .collection('users')
          .doc(uid)
          .collection('months')
          .add({
        'month': monthName,
        'monthKey': monthKey,
        'opening': openingBalance,
        'createdAt': Timestamp.now(),
      });

      Get.back();
      Get.snackbar('Success', 'মাস যোগ হয়েছে');
    } catch (e) {
      Get.snackbar('Error', e.toString());
    }
  }

}

