import 'package:cherry_feed/screen/nick_name_screen.dart';
import 'package:flutter/material.dart';

class SocialButton extends StatelessWidget {
  final double width;
  final double height;
  final SocialType socialType;

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
      onPressed: () {
        // 카카오 로그인 기능 구현
        Navigator.push(context, MaterialPageRoute(builder: (context)=>const NickNameScreen()));
      },
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(buttonData.backgroundColor),
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