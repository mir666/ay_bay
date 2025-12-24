import 'package:ay_bay/app/app_colors.dart';
import 'package:ay_bay/app/app_path.dart';
import 'package:ay_bay/features/home/controllers/home_controller.dart';
import 'package:ay_bay/features/home/widget/balance_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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

          // ক্যাটাগরি ফিল্টার
          Padding(
            padding: const EdgeInsets.all(8.0),
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

          // ✅ Expanded এখন parent Column এর সরাসরি child
          Expanded(
            child: Obx(() {
              if (controller.transactions.isEmpty) {
                return const Center(child: Text('কোনো ট্রানজাকশন নেই'));
              }

              return ListView.builder(
                itemCount: controller.transactions.length,
                itemBuilder: (_, i) {
                  final trx = controller.transactions[i];
                  final date = (trx['date'] as Timestamp).toDate();

                  return ListTile(
                    title: Text(trx['title'] ?? ''),
                    subtitle: Text(DateFormat('dd MMM yyyy').format(date)),
                    trailing: Text(
                      '৳ ${trx['amount']}',
                      style: TextStyle(
                        color: trx['type'] == 'income'
                            ? Colors.green
                            : Colors.red,
                        fontWeight: FontWeight.bold,
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

  /*Widget _buildCategoryButton(String category) {
    final controller = Get.find<HomeController>();

    return Obx(() {
      final isSelected = controller.filterCategory.value == category;

      return ChoiceChip(
        label: Text(category),
        selected: isSelected,
        onSelected: (_) => controller.setFilterCategory(category),
      );
    });
  }*/

  Widget filterButton(String text) {
    final HomeController controller = Get.find<HomeController>();
    return Obx(
      () => ChoiceChip(
        label: Text(text),
        selected: controller.filterCategory.value == text,
        onSelected: (_) => controller.setFilter(text),
      ),
    );
  }
}
