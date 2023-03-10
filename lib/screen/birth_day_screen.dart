import 'package:cherry_feed/appbar/custom_app_bar.dart';
import 'package:cherry_feed/button/next_button.dart';
import 'package:cherry_feed/date_dialog.dart';
import 'package:cherry_feed/screen/organization_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class BirthDayScreen extends StatefulWidget {
  final String text;

  const BirthDayScreen({Key? key, required this.text}) : super(key: key);

  @override
  State<BirthDayScreen> createState() => _BirthDayScreenState();
}

class _BirthDayScreenState extends State<BirthDayScreen> {
  DateTime _selectedDate = DateTime.now();
  final DateFormat formatter = DateFormat('yy년 MM월 dd일');

  Future<void> _showDatePickerDialog(BuildContext context) async {
    final pickedDate = await showDialog<DateTime>(
      context: context,
      builder: (_) => DateDialog(
        initialDate: _selectedDate,
        onDateTimeChanged: (DateTime date) {
          setState(() {
            _selectedDate = date;
          });
          Navigator.of(context).pop(date);
        },
      ),
    );
    if (pickedDate != null) {
      // 선택된 날짜가 있으면 상태를 업데이트합니다.
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffFAFAFA),
      appBar: const CustomAppBar(
        isShow: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 20.0),
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Text(
                  '${widget.text} 님의 \n'
                  '생일을 알려주세요',
                  style: Theme.of(context).textTheme.bodyText1,
                  textAlign: TextAlign.left,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Text(
                  '생년월일',
                  style: Theme.of(context).textTheme.bodyText1?.copyWith(
                        fontSize: 17,
                      ),
                ),
              ),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width - 20,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: Text(
                      '생일날짜',
                      style: Theme.of(context).textTheme.bodyText1?.copyWith(
                            fontSize: 17,
                            color: Color(0xff707478),
                          ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: Row(
                      children: [
                        Text(
                          '${formatter.format(_selectedDate)} (월요일)',
                          style:
                              Theme.of(context).textTheme.bodyText1?.copyWith(
                                    fontSize: 17,
                                    color: Theme.of(context).primaryColor,
                                    fontWeight: FontWeight.w100,
                                  ),
                        ),
                        IconButton(
                          onPressed: () => _showDatePickerDialog(context),
                          icon: Icon(
                            Icons.arrow_forward_ios,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const Expanded(
              child: SizedBox(
                height: 300,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 40),
              child: NextButton(
                isHalf: false,
                text: '다음',
                onPressed: onPressed,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void onPressed() {
    Navigator.push(context, MaterialPageRoute(builder: (context)=>OrganizationScreen()));
  }
}
