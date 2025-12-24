import 'package:ay_bay/features/home/controllers/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class AddMonthScreen extends StatefulWidget {
  const AddMonthScreen({super.key});

  @override
  State<AddMonthScreen> createState() => _AddMonthScreenState();
}

class _AddMonthScreenState extends State<AddMonthScreen> {
  final controller = Get.find<HomeController>();
  final amountCtrl = TextEditingController();
  DateTime? selectedDate;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('যোগ করুন'),centerTitle: true,),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('মাসের খরচের মোট টাকা',style: TextStyle(fontSize: 28,fontWeight: FontWeight.w600),),
            Text('যোগ করুন',style: TextStyle(fontSize: 24,fontWeight: FontWeight.w600),),
            SizedBox(height: 40),
            TextField(
              controller: amountCtrl,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'মোট টাকা'),
            ),
            const SizedBox(height: 10),
            InkWell(
              onTap: () async {
                selectedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2020),
                  lastDate: DateTime(2100),
                );
                setState(() {});
              },
              child: InputDecorator(
                decoration: const InputDecoration(
                  labelText: 'মাস ও তারিখ',
                  suffixIcon: Icon(Icons.calendar_today),
                ),
                child: Text(
                  selectedDate == null
                      ? 'তারিখ নির্বাচন করুন'
                      : DateFormat('MMMM yyyy').format(selectedDate!),
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                controller.addMonth(
                  monthDate: DateTime(2025, 1),
                  openingBalance: 5000,
                );

              },
              child: const Text('যোগ করুন'),
            )
          ],
        ),
      ),
    );
  }
}
