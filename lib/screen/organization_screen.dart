import 'package:cherry_feed/appbar/custom_app_bar.dart';
import 'package:cherry_feed/button/next_button.dart';
import 'package:cherry_feed/screen/connect_feed_screen.dart';
import 'package:cherry_feed/screen/organization_example_screen.dart';
import 'package:flutter/material.dart';

class OrganizationScreen extends StatelessWidget {
  const OrganizationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffFAFAFA),
      appBar: CustomAppBar(
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
                  '권한을 허용하면 \n'
                  '다양한 기능을 이용하실 수 있어요',
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
                  '• 선택 접근 권한',
                  style: Theme.of(context).textTheme.bodyText1?.copyWith(
                        fontSize: 17,
                      ),
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: const Color(0xffFFFFFF),
                borderRadius: BorderRadius.circular(10),
              ),
              width: MediaQuery.of(context).size.width - 20,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const <RowContent>[
                    RowContent(
                      title: '위치',
                      content: '현 위치 기반으로 주변 정보 안내 및 콘텐츠 추천',
                      imgPath: 'assets/images/map.png',
                    ),
                    RowContent(
                      title: '사진',
                      content: '사용자 다이어리, 콘텐츠 및 사진 게시물 업로드',
                      imgPath: 'assets/images/folder.png',
                    ),
                    RowContent(
                      title: '알림',
                      content: '사용자의 일정, 계획 및 추천 등의 알림',
                      imgPath: 'assets/images/like.png',
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Text(
                  '선택 접근 권한을 허용하지 않아도 체리피드 서비스 이용이 가능하나,\n일부 서비스를 이용하실 수 없습니다.',
                  style: Theme.of(context).textTheme.bodyText1?.copyWith(
                      fontSize: 13,
                      color: Color(0xff707478),
                      fontWeight: FontWeight.w100),
                ),
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
                text: '다음',
                isHalf: false,
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ConnectFeedScreen()));
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class RowContent extends StatelessWidget {
  final String title;
  final String content;
  final String imgPath;

  const RowContent(
      {Key? key,
      required this.title,
      required this.content,
      required this.imgPath})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        12,
        10,
        12,
        10,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.only(right: 12.0),
              child: Image.asset(
                imgPath,
              ),
            ),
          ),
          Expanded(
            flex: 10,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  padding: const EdgeInsets.only(bottom: 4),
                  width: MediaQuery.of(context).size.width,
                  child: Text(title,
                      textAlign: TextAlign.left,
                      style: Theme.of(context).textTheme.bodyText1?.copyWith(
                            fontSize: 17,
                            //color: Color(0xff707478),
                            //fontWeight: FontWeight.w100
                          )),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Text(
                    content,
                    style: Theme.of(context).textTheme.bodyText1?.copyWith(
                        fontSize: 13,
                        color: Color(0xff707478),
                        fontWeight: FontWeight.w100),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
