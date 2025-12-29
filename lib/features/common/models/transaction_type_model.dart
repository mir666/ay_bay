import 'package:cloud_firestore/cloud_firestore.dart';

enum TransactionType { income, expense }

class TransactionModel {
  final String id;
  final String title;
  final double amount;
  final TransactionType type;
  final String category;
  final DateTime date;
  final bool isMonthly;

  TransactionModel({
    required this.id,
    required this.title,
    required this.amount,
    required this.type,
    required this.category,
    required this.date,
    this.isMonthly = false,
  });

  /// 🔁 Firestore → Model
  factory TransactionModel.fromJson(
      String id,
      Map<String, dynamic> json,
      ) {
    return TransactionModel(
      id: id,
      title: json['title'] ?? '',
      amount: (json['amount'] ?? 0).toDouble(),
      type: json['type'] == 'income'
          ? TransactionType.income
          : TransactionType.expense,
      category: json['category'] ?? '',
      date: json['date'] is Timestamp
          ? (json['date'] as Timestamp).toDate()
          : DateTime.now(),
      isMonthly: json['isMonthly'] ?? false,
    );
  }

  /// 🔁 Model → Firestore
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'amount': amount,
      'type': type == TransactionType.income ? 'income' : 'expense',
      'category': category,
      'date': Timestamp.fromDate(date),
      'isMonthly': isMonthly,
    };
  }
}
