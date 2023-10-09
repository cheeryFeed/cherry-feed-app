import 'dart:convert';

import 'package:cherry_feed/appbar/custom_app_bar.dart';
import 'package:cherry_feed/button/next_button.dart';
import 'package:cherry_feed/models/user/user.dart';
import 'package:cherry_feed/screen/join/birth_day_screen.dart';
import 'package:cherry_feed/text_edit/text_edit.dart';
import 'package:cherry_feed/utils/api_host.dart';
import 'package:cherry_feed/utils/token_provider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class NickNameScreen extends StatefulWidget {
  const NickNameScreen({Key? key}) : super(key: key);

  @override
  State<NickNameScreen> createState() => _NickNameScreenState();

}

class _NickNameScreenState extends State<NickNameScreen> {
  User user = User();
  final TextEditingController controller = TextEditingController();
  String _text = '';
  TokenProvider tokenProvider =  TokenProvider();
  Future<http.Response> nickNameCheck() async {
    Uri uri = Uri.parse('${ApiHost.API_HOST_DEV}/api/v1/users/duplicationcheck/nickname?nickname=$_text');
    final headers = {
      'Content-Type': 'application/json; charset=utf-8',
    };
    http.Response response = await http.get(uri, headers: headers);
    return response;
  }

  Future<http.Response> updateUserData() async {
    await tokenProvider.init();
    String? _accessToken = await tokenProvider.getAccessToken();
    Uri uri = Uri.parse(ApiHost.API_HOST_DEV +
        '/api/v1/users');
    final headers = {
      'Content-Type': 'application/json; charset=utf-8',
      'Authorization': 'Bearer $_accessToken',
    };
    http.Response response = await http.put(uri, headers: headers,body: jsonEncode({'nickname':user.nickname}));
    return response;
  }

  void _onTextChanged(String value) {
    setState(() {
      _text = value;
      nickNameCheck();
      user.setNickname(value);
    });
    print('username : ${user.toString()}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffFAFAFA),
      appBar: const CustomAppBar(
        isShow: true,
        isBorder: false,
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
                enabled: true,
                textHint: '최대 12자 작성',
                controller: controller,
                onChange: _onTextChanged,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                child: FutureBuilder<http.Response>(
                  future: nickNameCheck(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      final response = snapshot.data!;
                      if (response.statusCode != 200) {
                        return Text(
                          '이미 사용 중인 닉네임입니다.',
                          style:
                              Theme.of(context).textTheme.bodyText1?.copyWith(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w100,
                                    color: Color(0xffEE4545),
                                  ),
                        );
                      }
                    }
                    return const SizedBox.shrink();
                  },
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
    updateUserData();
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (builder) => BirthDayScreen(user: user,),
      ),
    );
  }
}
