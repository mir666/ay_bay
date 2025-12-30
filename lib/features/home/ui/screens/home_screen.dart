import 'package:ay_bay/app/app_colors.dart';
import 'package:ay_bay/features/home/controllers/home_controller.dart';
import 'package:ay_bay/features/home/widget/balance_card.dart';
import 'package:ay_bay/features/common/models/transaction_type_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final HomeController controller = Get.find<HomeController>();

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
              if (controller.transactions.isEmpty) {
                return const Center(child: Text('কোনো ট্রানজাকশন নেই'));
              }

              return ListView.builder(
                itemCount: controller.transactions.length,
                itemBuilder: (context, index) {
                  final TransactionModel trx =
                  controller.transactions[index];

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
                          const SizedBox(width: 32), // spacing
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
            color: isSelected ? AppColors.addButtonColor : AppColors.unSelectedColor,
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
        padding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 8,
        ),

        // 🔥 Shadow
        elevation: isSelected ? 6 : 6,
        pressElevation: 8,
      );
    });
  }
}



