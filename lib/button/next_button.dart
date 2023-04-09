import 'package:flutter/material.dart';

class NextButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isHalf;
  final Color backgroundColor;
  final Color textColor;
  const NextButton({Key? key, required this.text, required this.onPressed, required this.isHalf, required this.backgroundColor, required this.textColor}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    if(isHalf) {
      width = width / 2;
    }
    double height = MediaQuery.of(context).size.height / 15;
    return ElevatedButton(
      onPressed: onPressed,
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(
          backgroundColor,
        ),
        fixedSize: MaterialStateProperty.all<Size>(
          Size(width, height),
        ),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: textColor,
          fontWeight: FontWeight.bold,
          fontSize: 16.0,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
