import 'package:flutter/material.dart';

class TextEdit extends StatelessWidget {
  final TextEditingController controller;
  final Function(String) onChange;

  const TextEdit({Key? key, required this.controller, required this.onChange})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onChanged: (value) {
        if (onChange != null) {
          onChange(value);
        }
      },
      cursorColor: Color(0xff202020),
      decoration: InputDecoration(
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: const Color(0xff202020),
          ),
        ),
        border: UnderlineInputBorder(
          borderSide: BorderSide(
            color: const Color(0xff202020),
          ),
        ),
        hintText: '최대 12자 작성',
        hintStyle: Theme.of(context).textTheme.bodyText2?.copyWith(
              color: Color(0xffABAFB2),
            ),
      ),
    );
  }
}
