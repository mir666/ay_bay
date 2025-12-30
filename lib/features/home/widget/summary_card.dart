import 'package:ay_bay/app/app_colors.dart';
import 'package:ay_bay/features/home/ui/screens/add_transaction_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/home_controller.dart';

class SummaryCard extends StatelessWidget {
  const SummaryCard({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HomeController>();

    return Obx(() {
      /*return Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _item('আয়', controller.income.value, Colors.green, '📈'),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.addButtonColor,
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            onPressed: () {
              Get.to(() => AddTransactionScreen());
            },
            child: const Icon(Icons.add, size: 26, color: Colors.white),
          ),
          _item('ব্যয়', controller.expense.value, Colors.red, '📉'),
        ],
      );*/
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _item(
            'আয়',
            controller.income.value,
            Colors.greenAccent,
            Icons.trending_up, // 📈 like icon
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.addButtonColor,
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            onPressed: () {
              Get.to(() => AddTransactionScreen());
            },
            child: const Icon(Icons.add, size: 26, color: Colors.white),
          ),
          _item(
            'ব্যয়',
            controller.expense.value,
            Colors.redAccent,
            Icons.trending_down, // 📉 like icon
          ),
        ],
      );

    });
  }
/*
  Widget _item(String title, double value, Color color, String emoji) {
    return Column(
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              emoji,
              style: const TextStyle(fontSize: 22),
            ),
            const SizedBox(width: 6),
            Text(
              title,
              style: TextStyle(
                color: color,
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          '৳ ${value.toStringAsFixed(0)}',
          style: TextStyle(
            color: color,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }*/

  Widget _item(
      String title,
      double value,
      Color color,
      IconData icon,
      ) {
    return Column(
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: color,
              size: 22,
            ),
            const SizedBox(width: 6),
            Text(
              title,
              style: TextStyle(
                color: color,
                fontSize: 22,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          '৳ ${value.toStringAsFixed(0)}',
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }


}
