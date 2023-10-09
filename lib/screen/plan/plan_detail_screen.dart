import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:cherry_feed/appbar/custom_app_bar.dart';
import 'package:cherry_feed/button/next_button.dart';
import 'package:cherry_feed/checkbox/check_box_list_item.dart';
import 'package:cherry_feed/image/image_container.dart';
import 'package:cherry_feed/models/calendar/calendar.dart';
import 'package:cherry_feed/models/calendar/check_list.dart';
import 'package:cherry_feed/models/plan/plan.dart';
import 'package:cherry_feed/screen/cover_img.dart';
import 'package:cherry_feed/utils/api_host.dart';
import 'package:cherry_feed/utils/token_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:intl/intl.dart';
import 'package:mime/mime.dart';

class PlanDetailScreen extends StatefulWidget {
  final Calendar calendar;

  const PlanDetailScreen({Key? key, required this.calendar}) : super(key: key);

  @override
  State<PlanDetailScreen> createState() => _PlanCreateScreen();
}

class _PlanCreateScreen extends State<PlanDetailScreen> {
  DateFormat formatJson = DateFormat('yyyy.MM.dd');
  DateFormat formatter = DateFormat('yy년 MM월 dd일');
  bool? isChecked;
  late String _accessToken;
  Status status = Status.scheduled;
  String location = '';
  String? checkedText;
  List<File?> imgList = [];
  List<CheckList> checklistItems = []; // 체크리스트 아이템을 저장할 리스트

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
      isChecked = false;
      location = '없음';
      print('TOKEN : : $_accessToken');
      status = Status.scheduled;
      checklistItems = widget.calendar.checkList;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffFAFAFA),
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
              CoverImg(onImageUploaded: onImageUploaded, defaultImg: widget.calendar.imgId,isActive: false,),
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: Text(
                        widget.calendar.title ?? '제목',
                        style: const TextStyle(
                            fontSize: 34, fontWeight: FontWeight.w600),
                        textAlign: TextAlign.left,
                      ),
                    ),
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
                                  rightStatusWidget(status)),
                              imageAndTextWidget(
                                  'assets/images/calendar.png',
                                  '진행 날짜',
                                  Text('${formatJson.format(widget.calendar.startAt!)} ~ ${formatJson.format(widget.calendar.endAt!)}')
                              ),
                              imageAndTextWidget(
                                'assets/images/foldMap.png',
                                '진행 장소',
                                rightTextWidget(true),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 28,
                        ),
                        Container(
                          decoration: BoxDecoration(
                            border:
                                Border.all(color: const Color(0xffE8ECF2), width: 1),
                            borderRadius: BorderRadius.circular(
                                12.0), // 선택사항: 원하는 경우 꼭지점을 둥글게 만들기 위해 추가
                          ),
                        ),
                        const SizedBox(
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
                                        itemData.isFinish = isChecked;
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
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(
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
                        const SizedBox(
                          height: 10,
                        ),
                        Theme(
                          data: ThemeData(
                            textSelectionTheme: TextSelectionThemeData(
                              cursorColor: Theme.of(context)
                                  .primaryColor, // 원하는 커서 색상으로 변경
                            ),
                          ),
                          child: Text(
                            widget.calendar.content ?? '오늘 있었던 일을 기록해 주세요.',
                            // 나머지 필요한 설정들 추가
                          ),
                        ),
                        ListView.builder(
                          shrinkWrap: true,
                          itemCount: imgList.length,
                          itemBuilder: (context, index) {
                            File? img = imgList[index];
                            return ImageContainer(
                              img: img,
                            );
                          },
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        NextButton(
                          backgroundColor: const Color(0xffFFFFFF),
                          textColor: const Color(0xffEE4545),
                          isHalf: true,
                          text: '삭제',
                          onPressed: () {},
                        ),
                        NextButton(
                          backgroundColor: const Color(0xffEE4545),
                          textColor: const Color(0xffFFFFFF),
                          isHalf: true,
                          text: '수정',
                          onPressed: () {},
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

  Widget buildTab(String text, bool isActive) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          color: isActive ? const Color(0xffEE4545) : Colors.white,
        ),
        child: Center(
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: isActive ? Colors.white : const Color(0xff707478),
            ),
          ),
        ),
      ),
    );
  }

  void onContentsImageUploaded(int? imgId) {
    if (imgId != null) {
      setState(() {
        // this.imgId = imgId;
      });
    }
  }

  void onImageUploaded(int? imgId) {
    if (imgId != null) {
      setState(() {
        // this.imgId = imgId;
      });
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

  Widget rightStatusWidget(Status status) {
    return Text(
      status.toDisplayString(),
      style: Theme.of(context).textTheme.bodyText1?.copyWith(
            fontSize: 20,
            color: Theme.of(context).primaryColor,
            fontWeight: FontWeight.w100,
          ),
    );
  }

  Widget rightTextWidget(bool isUnderLine) {
    return Text(
      widget.calendar.location ?? '없음',
      style: Theme.of(context).textTheme.bodyText1?.copyWith(
            fontSize: 17,
            color: Colors.black,
            fontWeight: FontWeight.w100,
            decoration:
                isUnderLine ? TextDecoration.underline : TextDecoration.none,
          ),
    );
  }
  Widget dateContentWidget({required bool isStartAt}) {
    final DateTime? selectedDate =
        isStartAt ? widget.calendar.startAt : widget.calendar.endAt;
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
        Row(
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
                    formatter.format(selectedDate),
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontSize: 20,
                    ),
                  ),
            const SizedBox(
              width: 10,
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: Theme.of(context).primaryColor,
            ),
          ],
        )
      ],
    );
  }
}
