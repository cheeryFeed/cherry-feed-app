import 'package:flutter/material.dart';

class CheckBoxWithImage extends StatefulWidget {
  final bool isChecked;
  final ValueChanged<bool> onChanged;

  const CheckBoxWithImage({
    Key? key,
    required this.isChecked,
    required this.onChanged,
  }) : super(key: key);

  @override
  _CheckBoxWithImageState createState() => _CheckBoxWithImageState();
}

class _CheckBoxWithImageState extends State<CheckBoxWithImage> {
  bool isTapped = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // 클릭 시 isChecked 값 반전
        setState(() {
          isTapped = true;
        });
        Future.delayed(Duration(milliseconds: 100), () {
          setState(() {
            isTapped = false;
          });
        });
        widget.onChanged(!widget.isChecked);
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AnimatedContainer(
            duration: Duration(milliseconds: 100),
            width: isTapped ? 28 : 30,
            height: isTapped ? 28 : 30,
            child: Image.asset(
              widget.isChecked
                  ? 'assets/images/check_true.png'
                  : 'assets/images/check_false.png',
              width: 30,
              height: 30,
            ),
          ),
        ],
      ),
    );
  }
}
