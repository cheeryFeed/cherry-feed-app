import 'package:flutter/material.dart';

class TitleInput extends StatelessWidget {
  final Function(String) onValueChanged;
  final double textSize;
  final String placeholder;

  TitleInput({required this.onValueChanged, required this.textSize, required this.placeholder});

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        hintText: placeholder,
        hintStyle: TextStyle(
          color: Color(0xff707478),
          fontSize: textSize,
          fontWeight: FontWeight.w600,
        ),
        border: InputBorder.none,
      ),
      onChanged: (value) {
        onValueChanged(value);
      },
      style: TextStyle(
        color: Colors.black,
        fontSize: textSize,
        fontWeight: FontWeight.w600,
      )
    );
  }
}
