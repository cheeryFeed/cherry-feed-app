import 'package:flutter/material.dart';

class NextButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  const NextButton({Key? key, required this.text, required this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = 64;
    return ElevatedButton(
      onPressed: onPressed,
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(
          const Color(0xffEE4545),
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
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 16.0,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
