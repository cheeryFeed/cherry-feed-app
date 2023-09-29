import 'package:cherry_feed/checkbox/check_box_with_image.dart';
import 'package:cherry_feed/text_edit/text_editor.dart';
import 'package:flutter/material.dart';

// 체크리스트 아이템 위젯 (가정)
class CheckBoxListItem extends StatelessWidget {
  final String text;
  final bool isChecked;
  final bool isUnderLine;
  final ValueChanged<bool?> onCheckedChanged;
  final ValueChanged<String> onTextChanged;
  final VoidCallback removeFunction;

  CheckBoxListItem({
    required this.text,
    required this.isChecked,
    required this.onCheckedChanged,
    required this.onTextChanged, required this.isUnderLine, required this.removeFunction,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            height: 30,
            child: CheckBoxWithImage(
              isChecked: isChecked,
              onChanged: onCheckedChanged,
            ),
          ),
          SizedBox(
            height: 30,
            width: 280,
            child: TextEditWidget(
              initialValue: text,
              onSave: onTextChanged,
              style: Theme.of(context).textTheme.bodyText1?.copyWith(
                fontSize: 20,
                color: Colors.black,
                fontWeight: FontWeight.w100,
                decoration:
                isUnderLine ? TextDecoration.underline : TextDecoration.none,
              ),
            ),
          ),
          GestureDetector(
            onTap: removeFunction,
              child: Image.asset(width: 24,height:30,'assets/images/garbage.png'),
          ),
        ],
      ),
    );
  }
}