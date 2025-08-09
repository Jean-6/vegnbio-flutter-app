



import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DatePickerService {
  // Display date selector
  static Future<DateTime?> selectorDate({required BuildContext context, DateTime? initialDate, DateTime? firstDate, DateTime? lastDate}) async {
    return await showDatePicker(
        context: context,
        initialDate: initialDate ?? DateTime.now().add(Duration(days: 1)),
        firstDate: firstDate ?? DateTime(2025),
        lastDate: lastDate ?? DateTime(2030)
    );
  }

  static Future<DateTime?> pickDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2025),
      lastDate: DateTime(2030),
      locale: const Locale('fr','FR'),
    );
    return picked;
  }

  static Future<DateTime?> showCustomDatePicker(BuildContext context, {DateTime? initialDate}) async {
    DateTime tempPickedDate = initialDate ?? DateTime.now();
    DateTime? selectedDate = await showModalBottomSheet<DateTime>(
      context: context,
      builder: (_) {
        return Container(
          height: 250,
          child: Column(
            children: [
              Expanded(
                child: CupertinoDatePicker(
                  mode: CupertinoDatePickerMode.date,
                  initialDateTime: tempPickedDate,
                  onDateTimeChanged: (newDate) {
                    tempPickedDate = newDate;
                  },
                ),
              ),
              ElevatedButton(
                child: Text("Valider"),
                onPressed: () {
                  Navigator.of(context).pop(tempPickedDate);
                },
              )
            ],
          ),
        );
      },
    );

    return selectedDate;
  }

}




