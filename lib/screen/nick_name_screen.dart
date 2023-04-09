import 'package:cherry_feed/appbar/custom_app_bar.dart';
import 'package:cherry_feed/button/next_button.dart';
import 'package:cherry_feed/screen/birth_day_screen.dart';
import 'package:cherry_feed/text_edit/text_edit.dart';
import 'package:flutter/material.dart';

class NickNameScreen extends StatefulWidget {
  const NickNameScreen({Key? key}) : super(key: key);

  @override
  State<NickNameScreen> createState() => _NickNameScreenState();
}

class _NickNameScreenState extends State<NickNameScreen> {
  final TextEditingController controller = TextEditingController();
  String _text = '';

  void _onTextChanged(String value) {
    setState(() {
      _text = value;
    });
    print(_text);
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
                  '새로 오신 체리님의 \n'
                  '닉네임을 설정해주세요',
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
                  '닉네임',
                  style: Theme.of(context).textTheme.bodyText1?.copyWith(
                        fontSize: 17,
                      ),
                ),
              ),
            ),
            SizedBox(
              child: TextEdit(
                enabled:true,
                textHint: '최대 12자 작성',
                controller: controller,
                onChange: _onTextChanged,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                child: _text == 'CherryFeed'
                    ? Text(
                        '이미 사용 중인 닉네임입니다.',
                        style: Theme.of(context).textTheme.bodyText1?.copyWith(
                              fontSize: 12,
                              fontWeight: FontWeight.w100,
                              color: Color(0xffEE4545),
                            ),
                      )
                    : null,
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
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (builder) => BirthDayScreen(text: _text),
      ),
    );
  }


}
