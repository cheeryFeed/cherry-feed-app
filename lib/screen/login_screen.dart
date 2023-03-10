import 'package:cherry_feed/appbar/customAppBar.dart';
import 'package:cherry_feed/button/social_button.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const CustomAppBar(
        isShow: false,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Service Slogan\nType Something.',
              style: Theme.of(context).textTheme.headline1,
              textAlign: TextAlign.left,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20.0),
              child: Text(
                'Cherry Feed',
                style: Theme.of(context).textTheme.headline2,
              ),
            ),
            SizedBox(height: 400),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SocialButton(socialType: SocialType.GOOGLE),
                SizedBox(height: 16.0),
                SocialButton(socialType: SocialType.APPLE),
                SizedBox(height: 16.0),
                SocialButton(socialType: SocialType.KAKAO),
                SizedBox(height: 16.0),
              ],
            ),
            SizedBox(height: 10),
            Text(
              '로그인함으로써 Bazzi Inc의 정책 및 약관에 동의합니다.',
              style:
                  Theme.of(context).textTheme.headline2?.copyWith(fontSize: 12),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '이용약관',
                  style: Theme.of(context).textTheme.headline2?.copyWith(
                        color: Color(0xff202020),
                        fontSize: 12,
                        decoration: TextDecoration.underline,
                        decorationThickness: 1,
                      ),
                ),
                SizedBox(width: 10),
                Text(
                  '개인정보 취급 방침',
                  style: Theme.of(context).textTheme.headline2?.copyWith(
                        color: Color(0xff202020),
                        fontSize: 12,
                        decoration: TextDecoration.underline,
                        decorationThickness: 1,
                      ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
