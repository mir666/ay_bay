import 'package:ay_bay/app/app_colors.dart';
import 'package:ay_bay/app/app_routes.dart';
import 'package:ay_bay/features/home/controllers/home_controller.dart';
import 'package:ay_bay/features/home/widget/balance_card.dart';
import 'package:ay_bay/features/common/models/transaction_type_model.dart';
import 'package:ay_bay/features/months/ui/screens/month_transactions_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final HomeController controller = Get.find<HomeController>();
    controller.saveLastScreen(AppRoutes.home);

    return Scaffold(
      body: Column(
        children: [
          const BalanceCard(),
          const SizedBox(height: 16),

          /// Filter Buttons
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 12),
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.dateIconBgColor,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: AppColors.categoryShadowColor,
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                filterButton('সব'),
                filterButton('আয়'),
                filterButton('ব্যয়'),
                filterButton('মাসিক'),
              ],
            ),
          ),

          Expanded(
            child: Obx(() {
              // 🔹 মাসিক ফিল্টার হলে মাসের লিস্ট দেখাবে
              if (controller.filterCategory.value == 'মাসিক') {
                if (controller.months.isEmpty) {
                  return const Center(child: Text('কোনো মাস যোগ করা হয়নি'));
                }

                return ListView.builder(
                  itemCount: controller.months.length,
                  itemBuilder: (context, index) {
                    final m = controller.months[index];

                    return Slidable(
                      key: Key(m['id']),
                      endActionPane: ActionPane(
                        motion: const DrawerMotion(), // swipe motion
                        extentRatio: 0.18, // swipe মাত্রা
                        children: [
                          SlidableAction(
                            onPressed: (_) {
                              Get.defaultDialog(
                                title: 'Confirm Delete',
                                middleText:
                                    '${m['month']} মাস ডিলিট করতে চাচ্ছো?',
                                textConfirm: 'হ্যাঁ',
                                textCancel: 'না',
                                confirmTextColor: Colors.white,
                                buttonColor: Colors.red,
                                onConfirm: () {
                                  Get.back();
                                  controller.deleteMonth(m['id'], m['month']);
                                },
                              );
                            },
                            backgroundColor: Colors.red,
                            foregroundColor: Colors.white,
                            borderRadius: BorderRadius.circular(50),
                            icon: Icons.delete_outline,
                          ),
                        ],
                      ),
                      child: Card(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ListTile(
                          title: Text(
                            m['month'],
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                            ),
                          ),
                          trailing: FutureBuilder<QuerySnapshot>(
                            future: FirebaseFirestore.instance
                                .collection('users')
                                .doc(controller.uid)
                                .collection('months')
                                .doc(m['id'])
                                .collection('transactions')
                                .where('type', isEqualTo: 'expense')
                                .get(),
                            builder: (context, snapshot) {
                              if (!snapshot.hasData) {
                                return const SizedBox(width: 40); // লোডিং স্পেস
                              }
                              final totalExpense = snapshot.data!.docs
                                  .fold<double>(
                                    0,
                                    (double sum, doc) =>
                                        sum + (doc['amount']?.toDouble() ?? 0),
                                  );
                              return Text(
                                '৳${totalExpense.toStringAsFixed(2)}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  color: Colors.red,
                                ),
                              );
                            },
                          ),
                          onTap: () {
                            Get.to(
                              () => MonthTransactionsScreen(
                                monthId: m['id'],
                                monthName: m['month'],
                              ),
                            );
                          },
                        ),
                      ),
                    );
                  },
                );
              }

              // 🔹 অন্য ফিল্টার / হোম লিস্ট দেখাবে (last active month)
              if (controller.transactions.isEmpty) {
                return const Center(child: Text('কোনো ট্রানজাকশন নেই'));
              }

              return ListView.builder(
                itemCount: controller.transactions.length,
                itemBuilder: (context, index) {
                  final trx = controller.transactions[index];
                  final isIncome = trx.type == TransactionType.income;

                  return Card(
                    color: isIncome
                        ? AppColors.ayCardColor
                        : AppColors.bayCardColor,
                    elevation: 6,
                    shadowColor: Colors.black26,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    margin: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    child: ListTile(
                      title: Text(trx.title),
                      subtitle: Text(
                        DateFormat('dd MMM yyyy').format(trx.date),
                        style: const TextStyle(fontSize: 12),
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            '${isIncome ? '+' : '-'} ৳ ${trx.amount}',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              color: isIncome ? Colors.green : Colors.red,
                            ),
                          ),
                          const SizedBox(width: 32),
                          InkWell(
                            onTap: () => controller.editTransaction(trx),
                            borderRadius: BorderRadius.circular(8),
                            child: Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: Colors.blue.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Icon(
                                Icons.edit_note,
                                color: Colors.blue,
                                size: 22,
                              ),
                            ),
                          ),
                          const SizedBox(width: 14),
                          InkWell(
                            onTap: () => controller.deleteTransaction(trx.id),
                            borderRadius: BorderRadius.circular(8),
                            child: Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: Colors.red.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Icon(
                                Icons.delete_outline,
                                color: Colors.red,
                                size: 22,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget filterButton(String text) {
    final HomeController controller = Get.find<HomeController>();

    return Obx(() {
      final bool isSelected = controller.filterCategory.value == text;

      return ChoiceChip(
        label: Text(
          text,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: isSelected
                ? AppColors.addButtonColor
                : AppColors.unSelectedColor,
            fontSize: isSelected ? 16 : 14,
          ),
        ),
        selected: isSelected,
        onSelected: (_) => controller.setFilter(text),

        // 🔥 Selected & Unselected Color
        selectedColor: AppColors.categoryTitleBgColor,
        backgroundColor: Colors.white,

        // 🔥 Border
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
          side: BorderSide(
            color: isSelected ? AppColors.categoryTitleBgColor : Colors.white,
            width: 1,
          ),
        ),
        showCheckmark: false,

        // 🔥 Padding
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),

        // 🔥 Shadow
        elevation: isSelected ? 6 : 6,
        pressElevation: 8,
      );
    });
  }
}
