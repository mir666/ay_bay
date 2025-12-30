import 'package:ay_bay/features/auth/ui/screens/log_in_screen.dart';
import 'package:ay_bay/features/common/models/transaction_type_model.dart';
import 'package:ay_bay/features/home/ui/screens/add_transaction_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class HomeController extends GetxController {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// UI State
  RxList<TransactionModel> allTransactions = <TransactionModel>[].obs;
  RxList<TransactionModel> transactions = <TransactionModel>[].obs;

  RxString filterCategory = 'সব'.obs;
  RxList<Map<String, dynamic>> months = <Map<String, dynamic>>[].obs;

  /// Dashboard
  RxDouble income = 0.0.obs;
  RxDouble expense = 0.0.obs;
  RxDouble balance = 0.0.obs;
  RxDouble totalBalance = 0.0.obs;
  final RxString selectedMonth = ''.obs;

  String? get uid => _auth.currentUser?.uid;


  @override
  void onInit() {
    super.onInit();
    _listenTransactions();
    _listenMonths();
  }

  /// 🔥 Firestore Transaction Listener
  void _listenTransactions() {
    if (uid == null) return;

    _db
        .collection('users')
        .doc(uid)
        .collection('transactions')
        .orderBy('date', descending: true)
        .snapshots()
        .listen((snapshot) {
      final data = snapshot.docs
          .map((e) => TransactionModel.fromJson(e.id, e.data()))
          .toList();

      allTransactions.value = data;
      transactions.value = _applyFilter(data);
      _calculateDashboard(data);
    });
  }

  /// ✅ Filter Logic (MODEL BASED)
  List<TransactionModel> _applyFilter(List<TransactionModel> data) {
    if (filterCategory.value == 'সব') return data;

    if (filterCategory.value == 'আয়') {
      return data
          .where((e) => e.type == TransactionType.income)
          .toList();
    }

    if (filterCategory.value == 'ব্যয়') {
      return data
          .where((e) => e.type == TransactionType.expense)
          .toList();
    }

    if (filterCategory.value == 'মাসিক') {
      final key = DateFormat('yyyy-MM').format(DateTime.now());
      return data.where((e) {
        return DateFormat('yyyy-MM').format(e.date) == key;
      }).toList();
    }

    return data;
  }

  /// 🔄 Change Filter
  void setFilter(String value) {
    filterCategory.value = value;
    transactions.value = _applyFilter(allTransactions);
  }

  /// 💰 Dashboard Calculation (MODEL BASED)
  void _calculateDashboard(List<TransactionModel> data) {
    double inc = 0;
    double exp = 0;

    for (final trx in data) {
      if (trx.type == TransactionType.income) {
        inc += trx.amount;
      } else {
        exp += trx.amount;
      }
    }

    income.value = inc;
    expense.value = exp;
    balance.value = inc - exp;
  }

  /// 📅 Month Listener
  void _listenMonths() {
    if (uid == null) return;

    _db
        .collection('users')
        .doc(uid)
        .collection('months')
        .orderBy('monthKey', descending: true)
        .snapshots()
        .listen((snapshot) {
      months.value = snapshot.docs.map((e) => e.data()).toList();
    });
  }

  /// ➕ Add Month
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

      // 🔥 UI state update
      selectedMonth.value = monthName;
      totalBalance.value = openingBalance;
      balance.value = openingBalance;

      Get.back();
      Get.snackbar('Success', 'মাস যোগ হয়েছে');
    } catch (e) {
      Get.snackbar('Error', e.toString());
    }
  }


  /// ✏️ Edit Transaction
  void editTransaction(TransactionModel trx) {
    Get.to(() => AddTransactionScreen(transaction: trx));
  }

  /// 🗑️ Delete Transaction (100% Working)
  Future<void> deleteTransaction(String id) async {
    if (uid == null) return;

    try {
      await _db
          .collection('users')
          .doc(uid)
          .collection('transactions')
          .doc(id)
          .delete();

      Get.snackbar('Success', 'লেনদেন ডিলিট হয়েছে');
    } catch (e) {
      Get.snackbar('Error', e.toString());
    }
  }

  /// 🚪 Logout
  Future<void> logout() async {
    try {
      await _auth.signOut();
      Get.offAll(() => LogInScreen());
      Get.snackbar('Success', 'Successfully logged out');
    } catch (e) {
      Get.snackbar('Error', e.toString());
    }
  }
}
