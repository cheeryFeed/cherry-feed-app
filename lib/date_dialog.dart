import 'package:cherry_feed/button/next_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DateDialog extends StatefulWidget {
  const DateDialog(
      {Key? key, required this.onDateTimeChanged, required this.initialDate})
      : super(key: key);
  final DateTime initialDate;
  final Function(DateTime) onDateTimeChanged;

  @override
  State<DateDialog> createState() => _DateDialogState();
}

class _DateDialogState extends State<DateDialog> {
  DateTime _selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      actionsPadding: const EdgeInsets.all(8.0),
      content: SizedBox(
        height: MediaQuery.of(context).size.height / 4,
        width: MediaQuery.of(context).size.width,
        child: CupertinoDatePicker(
          mode: CupertinoDatePickerMode.date,
          initialDateTime: widget.initialDate,
          onDateTimeChanged: (DateTime newDateTime) {
            setState(() {
              _selectedDate = newDateTime;
            });
          },
        ),
      ),
      actions: [
        Container(
          padding: const EdgeInsets.all(12.0),
          child: NextButton(
            isHalf: false,
            text: '확인',
            onPressed: () => widget.onDateTimeChanged(
              _selectedDate,
            ),
          ),
        )
      ],
    );
  }
}
