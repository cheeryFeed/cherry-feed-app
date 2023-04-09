import 'package:cherry_feed/button/connect_button.dart';
import 'package:cherry_feed/button/main_calendar_button.dart';
import 'package:cherry_feed/button/main_plan_button.dart';
import 'package:cherry_feed/slider/main_recommendation_slider.dart';
import 'package:cherry_feed/text/content_header.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 30, 20, 20),
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        // Main Column
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              ConnectButton(),
              SizedBox(height: 20),
              ContentHeader(title: '기념일', description: '우리가 함께 하는 날'),
              SizedBox(height: 18),
              MainCalendarButton(),
              SizedBox(height: 52),
              ContentHeader(title: '계획', description: '우리가 함께 하는 콘텐츠'),
              SizedBox(height: 12),
              MainPlanButton(),
              SizedBox(height: 52),
              ContentHeader(title: '추천', description: '다른 연인들의 콘텐츠'),
              SizedBox(height: 12),
              MainRecommendationSlider(),
            ],
          ),
        ),
      ),
    );
  }
}
