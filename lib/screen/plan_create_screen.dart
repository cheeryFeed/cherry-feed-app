import 'dart:convert';

import 'package:cherry_feed/appbar/custom_app_bar.dart';
import 'package:cherry_feed/button/next_button.dart';
import 'package:cherry_feed/checkbox/check_box_with_image.dart';
import 'package:cherry_feed/date_dialog.dart';
import 'package:cherry_feed/models/plan/plan.dart';
import 'package:cherry_feed/screen/calendar_screen.dart';
import 'package:cherry_feed/screen/cover_img.dart';
import 'package:cherry_feed/text_edit/text_edit.dart';
import 'package:cherry_feed/text_edit/text_editor.dart';
import 'package:cherry_feed/text_edit/title_input.dart';
import 'package:cherry_feed/utils/api_host.dart';
import 'package:cherry_feed/utils/token_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import '../models/anvsy/anvsy.dart';

class PlanCreateScreen extends StatefulWidget {
  const PlanCreateScreen({Key? key}) : super(key: key);

  @override
  State<PlanCreateScreen> createState() => _PlanCreateScreen();
}

class _PlanCreateScreen extends State<PlanCreateScreen> {
  DateTime anvsyAt = DateTime.now();
  DateFormat formatter = DateFormat('yy년 MM월 dd일');
  DateFormat formatJson = DateFormat('yyyy.MM.dd');
  DateTime? startAt;
  DateTime? endAt;
  int? id;
  String? anvsyNm;
  int? imgId;
  bool? isChecked;
  late String _accessToken;
  Status initStatus = Status.scheduled;
  String location = '';
  String? checkedText;
  final TextEditingController controller = TextEditingController();

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
      startAt = null;
      endAt = null;
      isChecked = false;
      location = '없음';
      print('TOKEN : : ${_accessToken}');
      initStatus = Status.scheduled;
    });
  }

  void setTitle(value) {
    setState(() {
      anvsyNm = value;
    });
    print('${anvsyNm} , ${imgId}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffFAFAFA),
      appBar: const CustomAppBar(
        isShow: true,
        isBorder: false,
      ),
      body: SingleChildScrollView(
        child: SizedBox(
          height: 2000,
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: [
              SizedBox(
                height: 20,
              ),
              CoverImg(onImageUploaded: onImageUploaded),
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  children: [
                    TitleInput(
                        onValueChanged: setTitle,
                        textSize: 34,
                        placeholder: '제목'),
                    const SizedBox(
                      height: 28,
                    ),
                    Column(
                      children: [
                        SizedBox(
                          height: 120,
                          // 진행상황,날짜,진행장소
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              imageAndTextWidget(
                                  'assets/images/flag.png',
                                  '진행 상황',
                                  rightStatusWidget(
                                      initStatus, _showStatusModal)),
                              imageAndTextWidget(
                                  'assets/images/calendar.png',
                                  '진행 날짜',
                                  rightCalendarWidget(
                                      startAt, endAt, _showCalendarModal)),
                              imageAndTextWidget(
                                'assets/images/foldMap.png',
                                '진행 장소',
                                rightTextWidget(onChangeText, true),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 28,
                        ),
                        Container(
                          decoration: BoxDecoration(
                            border:
                                Border.all(color: Color(0xffE8ECF2), width: 1),
                            borderRadius: BorderRadius.circular(
                                12.0), // 선택사항: 원하는 경우 꼭지점을 둥글게 만들기 위해 추가
                          ),
                        ),
                        SizedBox(
                          height: 28,
                        ),
                        SizedBox(
                          height: 150,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                '• 체크리스트',
                                style: TextStyle(
                                    fontSize: 26, fontWeight: FontWeight.bold),
                                textAlign: TextAlign.left,
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Row(
                                children: [
                                  SizedBox(
                                    height: 30,
                                    child: CheckBoxWithImage(
                                      isChecked: isChecked == null
                                          ? false
                                          : isChecked!,
                                      onChanged: _isCheckedFunction,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 16,
                                  ),
                                  SizedBox(
                                    height: 30,
                                    width: 280,
                                    child: rightTextWidget(_onCheckedTextChange, false),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 300,
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
            ],
          ),
        ),
      ),
    );
  }

  Widget buildTab(String text, bool isActive) {
    return Expanded(
      child: Container(
        margin: EdgeInsets.all(2),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          color: isActive ? Color(0xffEE4545) : Colors.white,
        ),
        child: Center(
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: isActive ? Colors.white : Color(0xff707478),
            ),
          ),
        ),
      ),
    );
  }

  void _onCheckedTextChange(String checkedText) {
    setState(() {
      this.checkedText = checkedText;
    });
  }

  void _isCheckedFunction(bool? isChecked) {
    if (isChecked != null) {
      setState(() {
        this.isChecked = isChecked;
      });
    }
  }

  void onPressed() async {
    // state를 json 형태로 변환
    Anvsy calendar = Anvsy(
      anvsyAt: anvsyAt,
      anvsyNm: anvsyNm.toString(),
      imgId: imgId,
      status: 1,
      id: null,
    );
    String anvsyAtString = DateFormat('yyyyMMdd').format(anvsyAt);
    final json = {...calendar.toJson(), 'anvsyAt': anvsyAtString.toString()};
    print('쏜다 : : ${json}');
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

  Widget imageAndTextWidget(String imgSource, String text, Widget rightWidget) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Image.asset(
          imgSource,
          width: 20,
          height: 20,
        ),
        const SizedBox(
          width: 4,
          height: 20,
        ),
        SizedBox(
          width: 120,
          child: Text(
            text,
            style: Theme.of(context).textTheme.bodyText1?.copyWith(
                fontSize: 20,
                color: const Color(0xff707478),
                fontWeight: FontWeight.w100),
          ),
        ),
        SizedBox(
          width: 50,
          height: 20,
        ),
        rightWidget
      ],
    );
  }

  Widget rightStatusWidget(Status status, VoidCallback onClick) {
    return GestureDetector(
      onTap: onClick,
      child: Text(
        status.toDisplayString(),
        style: Theme.of(context).textTheme.bodyText1?.copyWith(
              fontSize: 20,
              color: Theme.of(context).primaryColor,
              fontWeight: FontWeight.w100,
            ),
      ),
    );
  }

  Widget rightTextWidget(Function(String updatedValue) onClick,bool isUnderLine) {
    return TextEditWidget(
      initialValue: this.location,
      onSave: onClick,
      style: Theme.of(context).textTheme.bodyText1?.copyWith(
            fontSize: 20,
            color: Colors.black,
            fontWeight: FontWeight.w100,
            decoration: isUnderLine? TextDecoration.underline : TextDecoration.none,
          ),
    );
  }

  Widget rightCalendarWidget(
      DateTime? startAt, DateTime? endAt, VoidCallback onClick) {
    String displayText = '';
    TextStyle textStyle = TextStyle(color: Colors.black);
    if (startAt != null) {
      displayText = formatJson.format(startAt).toString();

      if (endAt != null) {
        displayText += ' ~ ${formatJson.format(endAt).toString()}';
      }
    } else {
      displayText = 'YY.MM.DD';
      textStyle = TextStyle(color: Colors.grey);
    }

    return GestureDetector(
      onTap: onClick,
      child: Text(displayText, style: textStyle),
    );
  }

  void _showCalendarModal() {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        // 바텀시트의 윗부분을 둥글게 만들기 위해 shape 속성 사용
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          // 모달의 내용을 구현하는 컨테이너
          height: MediaQuery.of(context).size.height * 2.3 / 5.0,
          padding: EdgeInsets.symmetric(vertical: 35, horizontal: 25),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    '진행 날짜',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    '하루 일정이라면 시작 날짜만 설정해도 괜찮아요.',
                    style: TextStyle(color: Colors.grey, fontSize: 18),
                  ),
                ],
              ),
              dateContentWidget(isStartAt: true),
              dateContentWidget(isStartAt: false),
              NextButton(
                backgroundColor: Color(0xffEE4545),
                textColor: Color(0xffFFFFFF),
                isHalf: false,
                text: '저장',
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget dateContentWidget({required bool isStartAt}) {
    final DateTime? selectedDate = isStartAt ? startAt : endAt;
    final String text = isStartAt ? '시작 날짜' : '종료 날짜';

    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          text,
          style: TextStyle(
            color: Colors.grey,
            fontSize: 20,
          ),
        ),
        GestureDetector(
          onTap: () => _showDatePickerDialog(isStartAt: isStartAt),
          child: Row(
            children: [
              selectedDate == null
                  ? Text(
                      '선택',
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontSize: 20,
                      ),
                    )
                  : Text(
                      '${formatter.format(selectedDate)}',
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontSize: 20,
                      ),
                    ),
              SizedBox(
                width: 10,
              ),
              Icon(
                Icons.arrow_forward_ios,
                color: Theme.of(context).primaryColor,
              ),
            ],
          ),
        )
      ],
    );
  }

  Future<void> _showDatePickerDialog({required bool isStartAt}) async {
    await showDialog<DateTime>(
      context: context,
      builder: (_) => DateDialog(
        initialDate:
            isStartAt ? startAt ?? DateTime.now() : endAt ?? DateTime.now(),
        onDateTimeChanged: (DateTime date) {
          setState(() {
            if (isStartAt) {
              startAt = date;
            } else {
              endAt = date;
            }
          });
          Navigator.of(context).pop(date);
        },
      ),
    );
  }

  void onChangeText(String location) {
    setState(() {
      this.location = location;
    });
  }

  void _showStatusModal() {
    showModalBottomSheet<void>(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30.0),
      ),
      builder: (BuildContext context) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(30.0),
          ),
          child: Padding(
            padding: const EdgeInsets.all(30.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text('진행 상황',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 24,
                        fontWeight: FontWeight.bold)),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: Status.values.map((status) {
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            initStatus = status;
                          });
                          Navigator.pop(context);
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              status.toDisplayString(),
                              style: TextStyle(
                                color: initStatus == status
                                    ? const Color(0xffEE4545)
                                    : Colors.grey,
                                fontSize: 20,
                              ),
                            ),
                            if (initStatus == status)
                              const Icon(Icons.check, color: Color(0xffEE4545))
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void onImageUploaded(int? imgId) {
    if (imgId != null) {
      setState(() {
        this.imgId = imgId;
      });
    }
  }
}
