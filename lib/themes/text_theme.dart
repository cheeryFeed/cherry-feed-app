import 'package:flutter/material.dart';

class CustomTheme extends TextTheme {

  static TextTheme getTheme() {
    return const TextTheme(
      headline1: TextStyle(
        color: Color(0xff202020),
        fontFamily: 'pretendard',
        fontSize: 34,
        fontWeight: FontWeight.w900,
      ),
      headline2: TextStyle(
        fontSize: 15.0,
        color: Color(0xff707478),
        fontWeight: FontWeight.w700,
      ),
      bodyText1: TextStyle(
        color: Color(0xff202020),
        fontSize: 22,
        fontWeight: FontWeight.bold
      ),
      bodyText2: TextStyle(
          color: Color(0xff202020),
          fontSize: 17,
          fontWeight: FontWeight.w300
      ),
      caption: TextStyle(
        color : Color(0xff707478),
        fontSize: 12,

      )
    );
  }
}
