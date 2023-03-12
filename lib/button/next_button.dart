import 'package:flutter/material.dart';

class NextButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isHalf;
  const NextButton({Key? key, required this.text, required this.onPressed, required this.isHalf}) : super(key: key);

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
