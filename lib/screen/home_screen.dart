import 'dart:convert';

import 'package:cherry_feed/button/connect_button.dart';
import 'package:cherry_feed/button/main_calendar_button.dart';
import 'package:cherry_feed/button/main_plan_button.dart';
import 'package:cherry_feed/models/anvsy/anvsy.dart';
import 'package:cherry_feed/screen/calendar_screen.dart';
import 'package:cherry_feed/screen/main_screen.dart';
import 'package:cherry_feed/screen/plan_screen.dart';
import 'package:cherry_feed/slider/main_recommendation_slider.dart';
import 'package:cherry_feed/text/content_header.dart';
import 'package:cherry_feed/utils/api_host.dart';
import 'package:cherry_feed/utils/token_provider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/user/user.dart';
class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  User? _user;
  late List<Anvsy> calendars;

  @override
  void initState() {
    super.initState();
    _fetchUser().then((user) {
      setState(() {
        _user = user;
      });
    }).catchError((error) {
      print('Error: $error');
      // 에러 처리를 원하는 대로 구현 가능
    });
  }

  Future<User> _fetchUser() async {
    TokenProvider tokenProvider = TokenProvider();
    await tokenProvider.init();
    final token = await tokenProvider.getAccessToken();
    Uri uri = Uri.parse('${ApiHost.API_HOST_DEV}/api/v1/users');
    http.Response response = await http.get(uri, headers: {
      'Authorization': 'Bearer $token',
    });
    return User.fromJson(json.decode(utf8.decode(response.bodyBytes)));
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        // Main Column
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (_user == null)
                Center(child: CircularProgressIndicator())
              else if (_user!.coupleId == null)
                ConnectButton()
              else
                SizedBox(),
              SizedBox(height: 20),
              ContentHeader(title: '기념일', description: '우리가 함께 하는 날', wordOnClick: CalendarScreen()),
              MainCalendarButton(),
              SizedBox(height: 52),
              ContentHeader(
                title: '계획',
                description: '우리가 함께 하는 콘텐츠',
                wordOnClick: MainScreen(user: _user!, defaultIndex: 1),
              ),
              SizedBox(height: 12),
              MainPlanButton(),
              SizedBox(height: 52),
              ContentHeader(title: '추천', description: '다른 연인들의 콘텐츠', wordOnClick: PlanScreen(),),
              SizedBox(height: 12),
              MainRecommendationSlider(),
            ],
          ),
        ),
      ),
    );
  }
}