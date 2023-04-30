import 'dart:convert';

import 'package:cherry_feed/appbar/custom_app_bar.dart';
import 'package:cherry_feed/button/next_button.dart';
import 'package:cherry_feed/date_dialog.dart';
import 'package:cherry_feed/screen/calendar_screen.dart';
import 'package:cherry_feed/screen/cover_img.dart';
import 'package:cherry_feed/text_edit/title_input.dart';
import 'package:cherry_feed/utils/api_host.dart';
import 'package:cherry_feed/utils/cherry_feed_util.dart';
import 'package:cherry_feed/utils/token_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import '../models/calendar/calendar.dart';

class CalendarCreateScreen extends StatefulWidget {
  final int status;

  const CalendarCreateScreen({Key? key, required this.status})
      : super(key: key);

  @override
  State<CalendarCreateScreen> createState() => _CalendarCreateScreenState();
}

class _CalendarCreateScreenState extends State<CalendarCreateScreen> {
  DateTime anvsyAt = DateTime.now();
  DateFormat formatter = DateFormat('yy년 MM월 dd일');
  DateFormat formatJson = DateFormat('yyyy-MM-dd');
  int? id;
  String? anvsyNm;
  int? imgId;
  int? status;
  late String _accessToken;

  @override
  void initState() {
    super.initState();
    _initWidget();
  }

  Future<void> _initWidget() async {
    final tokenProvider = TokenProvider();
    await tokenProvider.init();
    final token = await tokenProvider.getAccessToken();
    setState(() {
      _accessToken = token.toString();
      id = null;
      anvsyNm = null;
      imgId = 0;
      status = widget.status;
      print('TOKEN : : ${_accessToken}');
    });
  }

  void setTitle(value) {
    setState(() {
      anvsyNm = value;
    });
    print('${anvsyNm} , ${imgId}');
  }

  Future<void> _showDatePickerDialog(BuildContext context) async {
    final pickedDate = await showDialog<DateTime>(
      context: context,
      builder: (_) => DateDialog(
        initialDate: anvsyAt,
        onDateTimeChanged: (DateTime date) {
          setState(() {
            anvsyAt = date;
          });
          Navigator.of(context).pop(date);
        },
      ),
    );
    if (pickedDate != null) {
      // 선택된 날짜가 있으면 상태를 업데이트합니다.
      setState(() {
        anvsyAt = pickedDate;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffFAFAFA),
      appBar: const CustomAppBar(
        isShow: true,
        isBorder: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        '반복(기념일)',
                        style: Theme.of(context).textTheme.bodyText1?.copyWith(
                              fontSize: 20,
                            ),
                        textAlign: TextAlign.left,
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      Text(
                        '커플, 생일, 결혼기념일, 월급같은 기념일에 적합합니다.',
                        style: TextStyle(
                          fontSize: 16,
                          color: Color(0xff707478),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            CoverImg(onImageUploaded: onImageUploaded),
            SizedBox(
              height: 20,
            ),
            TitleInput(onValueChanged: setTitle),
            SizedBox(
              width: MediaQuery.of(context).size.width - 20,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: Text(
                      '기념 날짜',
                      style: Theme.of(context).textTheme.bodyText1?.copyWith(
                          fontSize: 17,
                          color: Color(0xff707478),
                          fontWeight: FontWeight.w100),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: Row(
                      children: [
                        Text(
                          '${formatter.format(anvsyAt)} ${CherryFeedUtil.weekdayToString(anvsyAt.weekday)}',
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
                backgroundColor: Color(0xffEE4545),
                textColor: Color(0xffFFFFFF),
                isHalf: false,
                text: '저장',
                onPressed: onPressed,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void onPressed() async {
    // state를 json 형태로 변환
    Calendar calendar = Calendar(
      anvsyAt: anvsyAt,
      anvsyNm: anvsyNm.toString(),
      imgId: imgId,
      status: status,
      id: null,
    );
    String anvsyAtString = DateFormat('yyyyMMdd').format(anvsyAt);
    final json = {...calendar.toJson(), 'anvsyAt': anvsyAtString.toString()};
    print('쏜다 : : ${json}');
    //http://218.53.23.14:8090/api/v1/anvsy
    final url = ApiHost.API_HOST_DEV + '/api/v1/anvsy';
    final headers = {
      'Content-type': 'application/json;charset=utf-8',
      'Authorization': 'Bearer ${_accessToken}',
    };
    final response = await http.post(Uri.parse(url),
        headers: headers, body: jsonEncode(json));
    print(response.body);
    // print(response.);
    if (response.statusCode == 200) {
      // 요청이 성공했을 경우
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => CalendarScreen()));
    } else {
      // 요청이 실패했을 경우
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('서버와 연결할 수 없습니다.'),
          content: Text('자원을 찾을 수 없습니다.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('확인'),
            ),
          ],
        ),
      );
    }
  }

  void onImageUploaded(int? imgId) {
    if (imgId != null) {
      setState(() {
        this.imgId = imgId;
      });
    }
  }
}
