import 'dart:ui';
import 'package:ay_bay/app/app_colors.dart';
import 'package:ay_bay/app/app_routes.dart';
import 'package:ay_bay/features/common/models/transaction_type_model.dart';
import 'package:ay_bay/features/home/controllers/home_controller.dart';
import 'package:ay_bay/features/home/widget/search_highlite_text.dart';
import 'package:ay_bay/features/home/widget/summary_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class BalanceCard extends StatelessWidget {
  const BalanceCard({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HomeController>();

    return Obx(() {
      return Stack(
        children: [
          /// 🔹 MAIN CARD
          Container(
            padding: const EdgeInsets.only(top: 20, bottom: 20),
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(16),
                bottomRight: Radius.circular(16),
              ),
              gradient: const LinearGradient(
                colors: [Color(0xFF0F2C59), Color(0xFF1E4FA1)],
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.bannerShadowColor,
                  blurRadius: 12,
                  offset: const Offset(4, 4),
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
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.menu_rounded,
                          color: Colors.white,
                        ),
                      ),

                      IconButton(
                        icon: Icon(
                          controller.isSearching.value
                              ? Icons.close
                              : Icons.search_outlined,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          controller.isSearching.value
                              ? controller.closeSearch()
                              : controller.isSearching.value = true;
                        },
                      ),
                    ],
                  ),
                ),

                Padding(
                  padding: EdgeInsets.only(left: 10, right: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          shape: const CircleBorder(), // 🔹 Circular shape
                          padding: const EdgeInsets.all(16), // 🔹 Button size
                          backgroundColor: AppColors.categoryTitleBgColor.withOpacity(0.2), // 🔹 Button color
                          elevation: 4, // 🔹 Shadow
                        ),
                        child: const Icon(
                          Icons.arrow_back_ios,
                          color: Colors.white,
                          size: 20, // 🔹 Icon size
                        ),
                      ),

                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.categoryTitleBgColor
                              .withOpacity(0.2),
                          padding: const EdgeInsets.symmetric(horizontal: 40),
                        ),
                        onPressed: () {
                          Get.toNamed(AppRoutes.addMonth);
                        },
                        child: Obx(() {
                          final monthText =
                              controller.selectedMonth.value.isEmpty
                              ? 'মাস'
                              : controller.selectedMonth.value;

                          final today = controller.todayDate.value;

                          return Text(
                            '$monthText (${DateFormat('dd MMM').format(today)})',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          );
                        }),
                      ),
                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          shape: const CircleBorder(), // 🔹 Circular shape
                          padding: const EdgeInsets.all(16), // 🔹 Button size
                          backgroundColor: AppColors.categoryTitleBgColor.withOpacity(0.2), // 🔹 Button color
                          elevation: 4, // 🔹 Shadow
                        ),
                        child: const Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.white,
                          size: 20, // 🔹 Icon size
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 40),
                Row(
                  children: [
                    _item('মোট বাজেট', controller.totalBalance.value),
                    _item('বর্তমান টাকা', controller.balance.value),
                  ],
                ),
                const SizedBox(height: 40),
                const SummaryCard(),
              ],
            ),
          ),

          /// 🌫️ BLUR + DIM
          if (controller.isSearching.value)
            Positioned.fill(
              child: GestureDetector(
                onTap: controller.closeSearch,
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
                  child: Container(color: Colors.black.withOpacity(0.35)),
                ),
              ),
            ),

          /// 🔍 FLOATING SEARCH PANEL
          if (controller.isSearching.value)
            Positioned(
              top: 80,
              left: 12,
              right: 12,
              child: Material(
                elevation: 12,
                borderRadius: BorderRadius.circular(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    /// Search Bar
                    Padding(
                      padding: const EdgeInsets.all(12),
                      child: TextField(
                        autofocus: true,
                        onChanged: controller.searchTransaction,
                        decoration: const InputDecoration(
                          hintText: 'মাস বা লেনদেন খুঁজুন...',
                          prefixIcon: Icon(Icons.search),
                          border: InputBorder.none,
                        ),
                      ),
                    ),

                    /// 📅 MONTH SUGGESTIONS
                    Obx(() {
                      if (controller.monthSuggestions.isEmpty) {
                        return const SizedBox();
                      }

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 4,
                            ),
                            child: Text(
                              'মাস',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: controller.monthSuggestions.length,
                            itemBuilder: (context, index) {
                              final m = controller.monthSuggestions[index];

                              return ListTile(
                                leading: const Icon(Icons.calendar_month),
                                title: searchHighlightText(
                                  m['month'],
                                  controller.searchText.value,
                                  highlightColor: Colors.deepPurple,
                                ),

                                onTap: () =>
                                    controller.selectMonthFromSearch(m),
                              );
                            },
                          ),
                          const Divider(height: 1),
                        ],
                      );
                    }),

                    /// 🔍 TRANSACTION SUGGESTIONS
                    Obx(() {
                      if (controller.suggestions.isEmpty) {
                        return const SizedBox();
                      }

                      return Container(
                        constraints: const BoxConstraints(maxHeight: 260),
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: controller.suggestions.length,
                          itemBuilder: (context, index) {
                            final trx = controller.suggestions[index];

                            return ListTile(
                              leading: Icon(
                                trx.type == TransactionType.income
                                    ? Icons.arrow_downward
                                    : Icons.arrow_upward,
                                color: trx.type == TransactionType.income
                                    ? Colors.green
                                    : Colors.red,
                              ),
                              title: searchHighlightText(
                                trx.title,
                                controller.searchText.value,
                                highlightColor:
                                    trx.type == TransactionType.income
                                    ? Colors.green
                                    : Colors.red,
                              ),

                              subtitle: Text(
                                DateFormat('dd MMM yyyy').format(trx.date),
                              ),
                              trailing: Text('৳ ${trx.amount}'),
                              onTap: () {
                                controller.selectSuggestion(trx);
                                controller.closeSearch();
                              },
                            );
                          },
                        ),
                      );
                    }),
                  ],
                ),
              ),
            ),
        ],
      );
    });
  }

  Widget _item(String title, double value) {
    return Expanded(
      child: Column(
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '৳ ${value.toStringAsFixed(0)}',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
