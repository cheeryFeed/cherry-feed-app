import 'package:flutter/material.dart';

class TitleInput extends StatelessWidget {
  final Function(String) onValueChanged;

  TitleInput({required this.onValueChanged});

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        hintText: '제목을 입력해주세요.',
        hintStyle: TextStyle(
          color: Color(0xff707478),
          fontSize: 19,
          fontWeight: FontWeight.w600,
        ),
        border: InputBorder.none,
      ),
      onChanged: (value) {
        onValueChanged(value);
      },
      style: TextStyle(
        color: Colors.black,
        fontSize: 19,
        fontWeight: FontWeight.w600,
      )
    );
  }
}
