import 'package:ay_bay/features/common/models/transaction_type_model.dart';
import 'package:ay_bay/features/home/controllers/home_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class AddTransactionController extends GetxController {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final isIncome = true.obs;
  String? editingTransactionId;

  final amountCtrl = TextEditingController();
  final noteCtrl = TextEditingController();
  final selectedCategory = ''.obs;
  final selectedDate = DateTime.now().obs;

  Rx<TransactionType> type = TransactionType.expense.obs;
  RxString category = ''.obs;
  RxBool isMonthly = false.obs;
  RxBool isLoading = false.obs;

  final categoriesIncome = ['Salary', 'Gift', 'Tuition'];
  final categoriesExpense = ['Food', 'Market', 'Transport'];

  void clearForm() {
    noteCtrl.clear();
    amountCtrl.clear();
    category.value = '';
    selectedCategory.value = '';
    selectedDate.value = DateTime.now();
    type.value = TransactionType.expense;
    isMonthly.value = false;
    editingTransactionId = null;
  }

  String get formattedDate =>
      DateFormat('dd MMM yyyy').format(selectedDate.value);

  void pickDate(DateTime date) {
    selectedDate.value = date;
  }

  void checkMonthBeforeSave() {
    final hController = Get.find<HomeController>();
    if (!hController.canAddTransaction.value) {
      Get.snackbar('Error', 'এই মাসে আর লেনদেন যোগ করা যাবে না');
      return;
    }
  }

  Future<void> saveTransaction() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    final home = Get.find<HomeController>();

    if (uid == null || home.selectedMonthId.isEmpty) return;

    final data = {
      'title': noteCtrl.text.trim(),
      'amount': double.parse(amountCtrl.text),
      'type': type.value == TransactionType.income ? 'income' : 'expense',
      'category': category.value,
      'date': Timestamp.fromDate(selectedDate.value),
      'isMonthly': isMonthly.value,
    };

    final ref = _db
        .collection('users')
        .doc(uid)
        .collection('months')
        .doc(home.selectedMonthId.value)
        .collection('transactions');

    if (editingTransactionId == null) {
      // ➕ ADD
      await ref.add(data);
    } else {
      // ✏️ EDIT
      await ref.doc(editingTransactionId).update(data);
    }

    home.fetchTransactions(home.selectedMonthId.value);
    clearForm();
    Get.back();
  }

  @override
  void onClose() {
    amountCtrl.dispose();
    noteCtrl.dispose();
    super.onClose();
  }
}
