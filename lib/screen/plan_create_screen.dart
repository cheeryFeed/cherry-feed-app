import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:cherry_feed/appbar/custom_app_bar.dart';
import 'package:cherry_feed/button/next_button.dart';
import 'package:cherry_feed/checkbox/add_button_widget.dart';
import 'package:cherry_feed/checkbox/check_box_list_item.dart';
import 'package:cherry_feed/date_dialog.dart';
import 'package:cherry_feed/image/image_container.dart';
import 'package:cherry_feed/models/calendar/calendar.dart';
import 'package:cherry_feed/models/calendar/check_list.dart';
import 'package:cherry_feed/models/plan/plan.dart';
import 'package:cherry_feed/screen/plan_screen.dart';
import 'package:http_parser/http_parser.dart';
import 'package:cherry_feed/screen/cover_img.dart';
import 'package:cherry_feed/text_edit/text_editor.dart';
import 'package:cherry_feed/text_edit/title_input.dart';
import 'package:cherry_feed/utils/api_host.dart';
import 'package:cherry_feed/utils/token_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:mime/mime.dart';

class PlanCreateScreen extends StatefulWidget {
  const PlanCreateScreen({Key? key}) : super(key: key);

  @override
  State<PlanCreateScreen> createState() => _PlanCreateScreen();
}

class _PlanCreateScreen extends State<PlanCreateScreen> {
  String? title;
  DateFormat formatter = DateFormat('yy년 MM월 dd일');
  DateFormat formatJson = DateFormat('yyyy.MM.dd');
  DateTime? startAt;
  DateTime? endAt;
  int? id;
  int imgId = 0;
  bool? isChecked;
  late String _accessToken;
  Status status = Status.scheduled;
  String location = '';
  String? checkedText;
  String content = '';
  List<File?> imgList = [];
  final TextEditingController controller = TextEditingController();
  final TextEditingController contentController = TextEditingController();
  List<CheckList> checklistItems = []; // 체크리스트 아이템을 저장할 리스트
  final TextEditingController checklistController = TextEditingController();
  File? img;
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
      imgId = 0;
      startAt = null;
      endAt = null;
      isChecked = false;
      title = null;
      location = '없음';
      print('TOKEN : : ${_accessToken}');
      status = Status.scheduled;
      checklistItems.add(new CheckList(content: '', isFinish: false));
    });
  }

  void setTitle(value) {
    setState(() {
      title = value;
    });
    print('${title} , ${imgId},${checklistItems.length}, ${content}');
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
        physics: const ClampingScrollPhysics(),
        child: SizedBox(
          height: 2000,
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: [
              const SizedBox(
                height: 20,
              ),
              CoverImg(onImageUploaded: onImageUploaded),
              const SizedBox(
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
                                      status, _showStatusModal)),
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
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            const Text(
                              '• 체크리스트',
                              style: TextStyle(
                                  fontSize: 26, fontWeight: FontWeight.bold),
                              textAlign: TextAlign.left,
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            ListView.builder(
                              shrinkWrap: true,
                              itemCount: checklistItems.length,
                              itemBuilder: (context, index) {
                                CheckList itemData = checklistItems[index];
                                return CheckBoxListItem(
                                  text: itemData.content,
                                  isChecked: itemData.isFinish,
                                  onCheckedChanged: (isChecked) {
                                    if (isChecked != null) {
                                      setState(() {
                                        itemData.isFinish = isChecked!;
                                      });
                                    }
                                  },
                                  isUnderLine: false,
                                  onTextChanged: (text) {
                                    setState(() {
                                      itemData.content = text;
                                    });
                                  },
                                  removeFunction: () =>
                                      removeChecklistItem(index),
                                );
                              },
                            ),
                            // 새로운 체크리스트 아이템 추가 기능
                            AddButtonWidget(
                                onTap: addChecklistItem, imgSoruce: 'assets/images/note.png', textHint: '목록 추가하기',),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 32,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Text(
                          '• 다이어리',
                          style: TextStyle(
                              fontSize: 26, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.left,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Theme(
                          data: ThemeData(
                            textSelectionTheme: TextSelectionThemeData(
                              cursorColor: Theme.of(context).primaryColor, // 원하는 커서 색상으로 변경
                            ),
                          ),
                          child: TextFormField(
                            maxLines: null,
                            controller: contentController,
                            onChanged: saveContents,
                            decoration: InputDecoration(
                              hintText: '오늘 있었던 일을 기록해 주세요.',
                              border: UnderlineInputBorder(
                                borderSide: BorderSide.none, // 파란색 밑줄 없애기
                              ),
                              // 나머지 필요한 설정들 추가
                            ),
                          ),
                        ),
                        ListView.builder(
                          shrinkWrap: true,
                          itemCount: imgList.length,
                          itemBuilder: (context, index) {
                            File? img = imgList[index];
                            return ImageContainer(img: img,);
                          },
                        ),
                        AddButtonWidget(
                            onTap: _getImageFromGallery, imgSoruce: 'assets/images/picture.png', textHint: '사진 추가하기',),

                      ],
                    ),
                    SizedBox(
                      height: 50,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        NextButton(
                          backgroundColor: Color(0xffFFFFFF),
                          textColor: Color(0xffEE4545),
                          isHalf: true,
                          text: '취소',
                          onPressed: onPressed,
                        ),
                        NextButton(
                          backgroundColor: Color(0xffEE4545),
                          textColor: Color(0xffFFFFFF),
                          isHalf: true,
                          text: '저장',
                          onPressed: onPressed,
                        ),
                      ],
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

  void saveContents(String contents) {
    setState(() {
      this.content = contents;
    });
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

  void onPressed() async {
    Calendar calendar = Calendar(id: null, alarmAt: null, allDay: null, checkList: checklistItems, content: content, endAt: endAt, imgId: imgId, location: location, startAt: startAt, status: status, title: title, type: null);
    String? startAtString = startAt == null ? null : DateFormat('yyyyMMdd').format(startAt!);
    String? endAtString = endAt == null ? null : DateFormat('yyyyMMdd').format(endAt!);
    final json = {...calendar.toJson(), 'startAt' : startAtString, 'endAt' : endAtString, 'status' : status.name};
    print('REUQEST JSON : : : ${json}');
    final url = ApiHost.API_HOST_DEV + '/api/v1/calender';
    final headers = {
      'Content-type': 'application/json;charset=utf-8',
      'Authorization': 'Bearer ${_accessToken}',
    };
    final response = await http.post(Uri.parse(url),
        headers: headers, body: jsonEncode(json));
    print(jsonDecode(response.body));
    // print(response.);
    if (response.statusCode == 200) {
      // 요청이 성공했을 경우
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => PlanScreen()));
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

  Future<void> _getImageFromGallery() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final response = await uploadFileToServer(File(pickedFile.path));
      if (response != null) {
        onContentsImageUploaded(response);
        setState(() {
          img = File(pickedFile.path);
          imgList.add(img);
        });
      }
    }
  }

  Future<http.MultipartFile> getMultipartFileFromImageFile(File file) async {
    final filename = file.path.split('/').last;
    final mimeType = lookupMimeType(file.path);
    final stream = StreamView<List<int>>(file.openRead());
    final length = await file.length();

    return http.MultipartFile(
      'image',
      stream,
      length,
      filename: filename,
      contentType: MediaType.parse(mimeType!),
    );
  }

  Future<int?> uploadFileToServer(File file) async {
    final url = Uri.parse('${ApiHost.API_HOST_DEV}/api/v1/file/file-system');
    final request = http.MultipartRequest('POST', url);
    final multipartFile = await getMultipartFileFromImageFile(file);
    request.files.add(multipartFile);
    final token = _accessToken;
    request.headers['Authorization'] = 'Bearer $token';

    final response = await request.send();
    if (response.statusCode == 200) {
      final jsonResponse = await response.stream.bytesToString(utf8);
      final parsedResponse = json.decode(jsonResponse);
      print(parsedResponse);
      return parsedResponse['fileId'];
    } else {
      throw Exception('Failed to upload file');
    }
  }

  // 체크리스트 추가 버튼을 누를 때 호출되는 메서드
  void addChecklistItem() {
    setState(() {
      checklistItems.add(new CheckList(
          content: '', isFinish: false)); // 새로운 체크리스트 아이템을 리스트에 추가
      if (checklistController != null) {
        checklistController.clear(); // 입력 필드를 비워줌
      }
    });
  }

  // 체크리스트 삭제 버튼을 누를 때 호출되는 메서드
  void removeChecklistItem(int index) {
    setState(() {
      checklistItems.removeAt(index); // 해당 인덱스의 체크리스트 아이템을 리스트에서 삭제
    });
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

  Widget rightTextWidget(
      Function(String updatedValue) onClick, bool isUnderLine) {
    return TextEditWidget(
      initialValue: this.location,
      onSave: onClick,
      style: Theme.of(context).textTheme.bodyText1?.copyWith(
            fontSize: 17,
            color: Colors.black,
            fontWeight: FontWeight.w100,
            decoration:
                isUnderLine ? TextDecoration.underline : TextDecoration.none,
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
                children: const [
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
                backgroundColor: const Color(0xffEE4545),
                textColor: const Color(0xffFFFFFF),
                isHalf: true,
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
                            this.status = status;
                          });
                          Navigator.pop(context);
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              status.toDisplayString(),
                              style: TextStyle(
                                color: this.status == status
                                    ? const Color(0xffEE4545)
                                    : Colors.grey,
                                fontSize: 20,
                              ),
                            ),
                            if (this.status == status)
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
  void onContentsImageUploaded(int? imgId) {
    if (imgId != null) {
      setState(() {
        this.imgId = imgId;
      });
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
