import 'package:flutter/material.dart';

class TitleInput extends StatefulWidget {
  final String? defaultValue;
  final Function(String) onValueChanged;
  final double textSize;
  final String placeholder;

  TitleInput({required this.onValueChanged, required this.textSize, required this.placeholder, this.defaultValue});

  @override
  _TitleInputState createState() => _TitleInputState();
}

class _TitleInputState extends State<TitleInput> {
  late TextEditingController _controller;
  late String _value;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.defaultValue ?? '');
    _value = widget.defaultValue ?? '';
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      decoration: InputDecoration(
        hintText: widget.placeholder,
        hintStyle: TextStyle(
          color: Color(0xff707478),
          fontSize: widget.textSize,
          fontWeight: FontWeight.w600,
        ),
        border: InputBorder.none,
      ),
      onChanged: (value) {
        setState(() {
          _value = value;
        });
        widget.onValueChanged(value);
      },
      style: TextStyle(
        color: Colors.black,
        fontSize: widget.textSize,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}
