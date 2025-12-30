import 'package:ay_bay/app/app_colors.dart';
import 'package:ay_bay/app/app_routes.dart';
import 'package:ay_bay/features/home/controllers/home_controller.dart';
import 'package:ay_bay/features/home/widget/summary_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BalanceCard extends StatelessWidget {
  const BalanceCard({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HomeController>();

    return Obx(() {
      return Container(
        padding: const EdgeInsets.only(top: 20, bottom: 20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(16),
            bottomRight: Radius.circular(16),
          ),
          gradient: const LinearGradient(
            colors: [Color(0xFF0F2C59), Color(0xFF1E4FA1)],
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.25),
              blurRadius: 12,
              offset: const Offset(0, 6), // নিচে shadow
            ),
          ],
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    child: IconButton(
                      onPressed: () {},
                      icon: Icon(Icons.linear_scale_sharp, color: Colors.white),
                    ),
                  ),
                  IconButton(onPressed: (){}, icon: Icon(Icons.search_outlined,color: Colors.white,),),
                ],
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.monthAddButtonColor,
                padding: EdgeInsets.symmetric(horizontal: 120),
              ),
              onPressed: () {
                Get.toNamed(AppRoutes.addMonth);
              },
              child: Text('data', style: TextStyle(color: Colors.white)),
            ),
            SizedBox(height: 16),
            Row(
              children: [
                _item('মোট ব্যালেন্স', controller.balance.value),
              ],
            ),
            SizedBox(height: 28),
            SummaryCard(),
          ],
        ),
      );
    });
  }

  Widget _item(String title, double value) {
    return Expanded(
      child: Column(
        children: [
          Text(
            title,
            style: TextStyle(
              color: Colors.white,
              fontSize: 48,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '৳ ${value.toStringAsFixed(0)}',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
