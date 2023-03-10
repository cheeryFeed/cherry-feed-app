import 'package:cherry_feed/screen/logo_screen.dart';
import 'package:cherry_feed/themes/text_theme.dart';
import 'package:flutter/material.dart';

void main() {
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