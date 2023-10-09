import 'package:cherry_feed/screen/join/logo_screen.dart';
import 'package:cherry_feed/themes/text_theme.dart';
import 'package:cherry_feed/utils/token_provider.dart';
import 'package:flutter/material.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  KakaoSdk.init(nativeAppKey: '9a9838ce946ea91ba84901f7bd145a4a');
  runApp(
    MaterialApp(
      home: LogoScreen(),
      theme: ThemeData(
        fontFamily:  'pretendard',
        textTheme: CustomTheme.getTheme(),
        backgroundColor: Colors.white,
        primaryColor: const Color(0xffEE4545),
      ),
    )
  );
}