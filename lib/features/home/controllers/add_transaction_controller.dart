import 'package:ay_bay/features/common/models/transaction_type_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class AddTransactionController extends GetxController {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final isIncome = true.obs;

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

  String get formattedDate =>
      DateFormat('dd MMM yyyy').format(selectedDate.value);

  void pickDate(DateTime date) {
    selectedDate.value = date;
  }

  Future<void> saveTransaction() async {
    if (noteCtrl.text.isEmpty || amountCtrl.text.isEmpty) {
      Get.snackbar('Error', 'সব ফিল্ড পূরণ করুন');
      return;
    }

    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) {
      Get.snackbar('Error', 'User not logged in');
      return;
    }

    isLoading.value = true;

    try {
      await _db
          .collection('users')
          .doc(uid)
          .collection('transactions')
          .add({
        'title': noteCtrl.text.trim(),
        'amount': double.parse(amountCtrl.text),
        'type': type.value == TransactionType.income ? 'income' : 'expense',
        'category': category.value,
        'date': Timestamp.fromDate(selectedDate.value),
        'isMonthly': isMonthly.value,
        'createdAt': Timestamp.now(),
      });

      Get.back();
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }


  @override
  void onClose() {
    amountCtrl.dispose();
    noteCtrl.dispose();
    super.onClose();
  }
}



