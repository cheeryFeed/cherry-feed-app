import 'package:cherry_feed/appbar/custom_app_bar.dart';
import 'package:cherry_feed/button/next_button.dart';
import 'package:cherry_feed/textEdit/text_edit.dart';
import 'package:flutter/material.dart';

class ConnectFeedScreen extends StatelessWidget {
  const ConnectFeedScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffFAFAFA),
      appBar: CustomAppBar(isShow: true,),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 20.0),
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Text(
                  '체리피드를 함께 관리할 \n'
                      '상대방과 연결해주세요',
                  style: Theme.of(context).textTheme.bodyText1,
                  textAlign: TextAlign.left,
                ),
              ),
            ),
            SizedBox(
              height: 300,
              child: Image.asset('assets/images/heart_asset.png'),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Text(
                  '내 연결 코드',
                  style: Theme.of(context).textTheme.bodyText1?.copyWith(
                    fontSize: 17,
                  ),
                ),
              ),
            ),
            SizedBox(
              child: TextEdit(
                enabled: false,
                textHint: 'Type Something',
                controller: TextEditingController(),
                onChange: (String){},
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 32),
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Text(
                  '상대방 연결 코드',
                  style: Theme.of(context).textTheme.bodyText1?.copyWith(
                    fontSize: 17,
                  ),
                ),
              ),
            ),
            SizedBox(
              child: TextEdit(
                enabled: true,
                textHint: '코드 입력',
                controller: TextEditingController(),
                onChange: (String){},
              ),
            ),

            SizedBox(
              width: 500,
              child: Row(
                children: [
                  NextButton(
                    isHalf: true,
                    text: '공유하기',
                    onPressed: (){},
                  ),
                  NextButton(
                    isHalf: true,
                    text: '나중에 하기',
                    onPressed: (){},
                  ),
                ],
              ),
            ),
          ],
        ),
      ),

    );
  }
}
