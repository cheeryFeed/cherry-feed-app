import 'package:flutter/material.dart';

class TextEdit extends StatelessWidget {
  final TextEditingController controller;
  final Function(String) onChange;
  final String textHint;
  final bool enabled;

  const TextEdit({Key? key, required this.controller, required this.onChange, required this.textHint, required this.enabled})
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
      enabled:enabled ,
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
        hintText: textHint,
        hintStyle: Theme.of(context).textTheme.bodyText2?.copyWith(
              color: Color(0xffABAFB2),
            ),
      ),
    );
  }
}
