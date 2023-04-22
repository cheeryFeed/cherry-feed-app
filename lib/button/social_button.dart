import 'dart:convert';

import 'package:cherry_feed/screen/nick_name_screen.dart';
import 'package:cherry_feed/utils/api_host.dart';
import 'package:cherry_feed/utils/token_provider.dart';
import 'package:flutter/material.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'package:http/http.dart' as http;

class SocialButton extends StatelessWidget {
  final double width;
  final double height;
  final SocialType socialType;

  Future<void> _getTokenFromServer(context) async {
    OAuthToken token = await UserApi.instance.loginWithKakaoAccount();
    var url = Uri.parse(ApiHost.API_HOST_DEV+'/api/v1/kakaoToken');
    final response = await http.post(url, body: {'token': token.accessToken});
    print(response.body);

    TokenProvider tokenProvider = TokenProvider();
    await tokenProvider.init();

// access token과 refresh token 저장
    String accessToken = jsonDecode(response.body)['accessToken'];
    String refreshToken = jsonDecode(response.body)['refreshToken'];
    await tokenProvider.setAccessToken(accessToken);
    await tokenProvider.setRefreshToken(refreshToken);


    print('저장한 토큰 불러와1 : ${await tokenProvider.getAccessToken()}');
    print('저장한 토큰 불러와2 : ${await tokenProvider.getRefreshToken()}');

    if(tokenProvider.getAccessToken() != 'access_token') {
      Navigator.push(context, MaterialPageRoute(builder: (context) => NickNameScreen(),));
    }
  }

  const SocialButton({
    Key? key,
    this.width = 320,
    this.height = 56,
    required this.socialType,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Map<SocialType, SocialButtonData> data = {
      SocialType.KAKAO: SocialButtonData(
        backgroundColor: Color(0xffFEE505),
        textColor: Color(0xff202020),
        imageAsset: AssetImage('assets/images/kakao.png'),
        text: '카카오로 로그인',
      ),
      SocialType.APPLE: SocialButtonData(
        backgroundColor: Color(0xff000000),
        textColor: Color(0xffDEDEDE),
        imageAsset: AssetImage('assets/images/apple.png'),
        text: '애플로 로그인',
      ),
      SocialType.GOOGLE: SocialButtonData(
        backgroundColor: Color(0xffF4F4F4),
        textColor: Color(0xff202020),
        imageAsset: AssetImage('assets/images/google.png'),
        text: '구글로 로그인',
      ),
    };

    final buttonData = data[socialType]!;

    return ElevatedButton(
      onPressed: () async {
        await _getTokenFromServer(context);
      },
      style: ButtonStyle(
        backgroundColor:
            MaterialStateProperty.all<Color>(buttonData.backgroundColor),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
      ),
      child: SizedBox(
        width: width,
        height: height,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Image(
              image: buttonData.imageAsset,
              width: 30,
              height: 30,
            ),
            SizedBox(width: 90.0),
            Text(
              buttonData.text,
              style: TextStyle(
                color: buttonData.textColor,
                fontWeight: FontWeight.bold,
                fontSize: 16.0,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class SocialButtonData {
  final Color backgroundColor;
  final Color textColor;
  final AssetImage imageAsset;
  final String text;

  SocialButtonData({
    required this.backgroundColor,
    required this.textColor,
    required this.imageAsset,
    required this.text,
  });
}

enum SocialType { KAKAO, GOOGLE, APPLE }
