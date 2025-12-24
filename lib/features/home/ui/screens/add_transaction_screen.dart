import 'package:ay_bay/features/common/models/transaction_type_model.dart';
import 'package:ay_bay/features/home/controllers/add_transaction_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class AddTransactionScreen extends StatelessWidget {
  AddTransactionScreen({super.key});

  final controller = Get.find<AddTransactionController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Income / Expense')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: controller.noteCtrl,
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.done,
                decoration: const InputDecoration(labelText: 'Title'),
              ),
              const SizedBox(height: 12),

              TextField(
                controller: controller.amountCtrl,
                textInputAction: TextInputAction.done,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Amount'),
              ),
              const SizedBox(height: 12),

              /// Income / Expense Toggle
              Obx(() => Row(
                children: [
                  ChoiceChip(
                    label: const Text('আয়'),
                    selected:
                    controller.type.value == TransactionType.income,
                    onSelected: (_) =>
                    controller.type.value = TransactionType.income,
                  ),
                  const SizedBox(width: 10),
                  ChoiceChip(
                    label: const Text('ব্যয়'),
                    selected:
                    controller.type.value == TransactionType.expense,
                    onSelected: (_) =>
                    controller.type.value = TransactionType.expense,
                  ),
                ],
              )),

              const SizedBox(height: 12),

              /// Date Picker
              Obx(() => ListTile(
                leading: const Icon(Icons.calendar_today),
                title: Text(
                  DateFormat('dd MMM yyyy')
                      .format(controller.selectedDate.value),
                ),
                onTap: () async {
                  final date = await showDatePicker(
                    context: context,
                    initialDate: controller.selectedDate.value,
                    firstDate: DateTime(2020),
                    lastDate: DateTime(2100),
                  );
                  if (date != null) controller.pickDate(date);
                },
              )),

              /// Monthly Switch
              Obx(() => SwitchListTile(
                title: const Text('Monthly'),
                value: controller.isMonthly.value,
                onChanged: (v) => controller.isMonthly.value = v,
              )),

              const SizedBox(height: 20),

              /// Save Button
              Obx(() => ElevatedButton(
                onPressed: controller.isLoading.value
                    ? null
                    : controller.saveTransaction,
                child: controller.isLoading.value
                    ? const CircularProgressIndicator()
                    : const Text('Save'),
              )),
            ],
          ),
        ),
      ),
    );
  }

}
