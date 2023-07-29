import 'package:flutter/material.dart';

class TextEditWidget extends StatefulWidget {
  final String initialValue;
  final void Function(String updatedValue) onSave;
  final TextStyle? style;

  const TextEditWidget({
    Key? key,
    required this.initialValue,
    required this.onSave,
    this.style,
  }) : super(key: key);

  @override
  State<TextEditWidget> createState() => _TextEditWidgetState();
}

class _TextEditWidgetState extends State<TextEditWidget> {
  late TextEditingController _textEditingController;
  late String _updatedValue;

  @override
  void initState() {
    super.initState();
    _textEditingController = TextEditingController(text: widget.initialValue);
    _updatedValue = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _showEditDialog,
      child: SizedBox(
        width: 150,
        child: Text(
          _updatedValue == '' ? '장소를 입력해 주세요.' : _updatedValue,
          overflow: TextOverflow.ellipsis,
          style: widget.style,
        ),
      ),
    );
  }

  void _showEditDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('텍스트 수정'),
          content: TextField(
            controller: _textEditingController,
            onChanged: (value) {
              setState(() {
                _updatedValue = value;
              });
            },
            decoration: InputDecoration(
              hintText: '텍스트를 입력하세요',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('취소'),
            ),
            TextButton(
              onPressed: () {
                // Save 버튼을 눌렀을 때, 변경된 텍스트를 onSave 콜백 함수에 전달합니다.
                widget.onSave(_updatedValue);
                Navigator.pop(context);
              },
              child: Text('저장'),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }
}
