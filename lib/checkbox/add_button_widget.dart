import 'package:flutter/material.dart';

class AddButtonWidget extends StatelessWidget {
  final VoidCallback onTap;
  final String imgSoruce;
  final String textHint;
  const AddButtonWidget({Key? key, required this.onTap, required this.imgSoruce, required this.textHint}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 44,
        width: 320,
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 12),
        decoration: BoxDecoration(
          color: Color.fromRGBO(70, 74, 78, 0.10),
          border: Border.all(color: Color.fromRGBO(70, 74, 78, 0.2), width: 1,),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Row(
          children: [
            Image.asset(
              imgSoruce,
              width: 24,
              height: 24,
            ),
            SizedBox(width: 12),
            Expanded(
              child: Text(
                textHint,
                style: TextStyle(fontSize: 17,color: Color.fromRGBO(70, 74, 78, 0.6)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
