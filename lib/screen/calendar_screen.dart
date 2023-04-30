import 'dart:convert';
import 'package:cherry_feed/appbar/custom_app_bar.dart';
import 'package:cherry_feed/button/next_button.dart';
import 'package:cherry_feed/screen/calendar_create_screen.dart';
import 'package:cherry_feed/utils/api_host.dart';
import 'package:cherry_feed/utils/cherry_feed_util.dart';
import 'package:cherry_feed/utils/token_provider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:cherry_feed/models/calendar/calendar.dart';
import 'package:intl/intl.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({Key? key}) : super(key: key);

  // API URL
  static final String apiUrl = '${ApiHost.API_HOST_DEV}/api/v1/anvsy';

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  final String _apiUrl = '${ApiHost.API_HOST_DEV}/api/v1/anvsy';
  late String _accessToken;
  int count = 0;
  List<Calendar> calendars = [];

  @override
  void initState() {
    super.initState();
    _initWidget();
  }

  void setListCount(int value) {
    setState(() {
      count = value;
    });
  }

  Future<void> _initWidget() async {
    final tokenProvider = TokenProvider();
    await tokenProvider.init();
    final token = await tokenProvider.getAccessToken();

    setState(() {
      _accessToken = token.toString();
      print('TOKEN : : ${_accessToken}');
    });
    List<Calendar> items = await _fetchCalendars();
    if (items.isNotEmpty) {
      setState(() {
        calendars = items;
        count = items.length;
      });
    }
  }

  Future<List<Calendar>> _fetchCalendars() async {
    final response = await http.get(Uri.parse(_apiUrl), headers: {
      'Authorization': 'Bearer $_accessToken',
    });
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(utf8.decode(response.bodyBytes));
      print(data.toString());
      return data.map((e) => Calendar.fromJson(e)).toList();
    } else {
      print(response.body);
      throw Exception('Failed to load calendars');
    }
  }

  Widget _buildCalendarList() {
    Future<List<Calendar>> items = _fetchCalendars();
    return FutureBuilder<List<Calendar>>(
      future: items,
      builder: (BuildContext context, AsyncSnapshot<List<Calendar>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasData) {
          final List<Calendar> calendars = snapshot.data!;
          print(snapshot.data!.toString());
          return ListView.builder(
            shrinkWrap: true,
            itemCount: calendars.length,
            itemBuilder: (BuildContext context, int index) {
              final Calendar calendar = calendars[index];
              return Padding(
                padding: EdgeInsets.symmetric(vertical: 8),
                child: Container(
                  height: 140,
                  decoration: BoxDecoration(
                    image: calendar.imgId != null
                        ? DecorationImage(
                            image: NetworkImage(ApiHost.API_HOST_DEV +
                                '/api/v1/file/file-system/${calendar.imgId}'),
                            fit: BoxFit.cover,
                          )
                        : DecorationImage(
                            image: AssetImage('assets/images/dummy/ex_8.jpg'),
                            fit: BoxFit.cover,
                          ),
                    borderRadius: BorderRadius.circular(13),
                  ),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          Column(
                            children: [
                              Image.asset(
                                'assets/images/plan_icon.png',
                                height: 60,
                                width: 60,
                              ),
                              SizedBox(
                                height: 30,
                                width: 110,
                              )
                            ],
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                height: 15,
                              ),
                              calendar.anvsyNm == null
                                  ? SizedBox.shrink()
                                  : SizedBox(
                                      width: 150,
                                      child: Text(
                                        calendar.anvsyNm!,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w300,
                                          fontSize: 19,
                                        ),
                                        textAlign: TextAlign.left,
                                      ),
                                    ),
                              SizedBox(height: 5),
                              calendar.anvsyAt == null
                                  ? SizedBox.shrink()
                                  : SizedBox(
                                      width: 150,
                                      child: Text(
                                        '${DateFormat('yyyy-MM-dd').format(calendar.anvsyAt!)}${CherryFeedUtil.weekdayToString(calendar.anvsyAt!.weekday)}',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        textAlign: TextAlign.left,
                                      ),
                                    ),
                              SizedBox(height: 20),
                              SizedBox(
                                width: 150,
                                child: calendar.anvsyAt == null
                                    ? SizedBox.shrink()
                                    : Text(
                                        '${DateFormat('yyyy-MM-dd').format(calendar.anvsyAt!)}${CherryFeedUtil.weekdayToString(calendar.anvsyAt!.weekday)}',
                                        style: TextStyle(
                                          fontSize: 15,
                                          color: Color(0xffABAFB2),
                                        ),
                                        textAlign: TextAlign.left,
                                      ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        } else if (snapshot.hasError) {
          return Text('Failed to load calendars');
        } else {
          return SizedBox.shrink();
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffFAFAFA),
      appBar: CustomAppBar(
        isShow: true,
        isBorder: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                SizedBox(
                  width: 50,
                  height: 50,
                  child: Image.asset('assets/images/calendar_icon.png'),
                ),
                SizedBox(width: 8),
                Column(
                  children: [
                    SizedBox(
                      width: 80,
                      child: Text(
                        '전체 기념일',
                        style: TextStyle(fontSize: 17),
                        textAlign: TextAlign.left,
                      ),
                    ),
                    SizedBox(height: 4),
                    SizedBox(
                      width: 80,
                      child: Text(
                        '${count}개',
                        style: TextStyle(
                          fontSize: 20,
                          color: Color(0xffEE4545),
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.left,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 36),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '목록',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                TextButton(
                  onPressed: () {},
                  child: Text(
                    '편집하기',
                    style: TextStyle(
                      color: Color(0xffEE4545),
                      fontSize: 20,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            Expanded(child: _buildCalendarList()),
            SizedBox(height: 16),
            NextButton(
              textColor: Colors.white,
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => CalendarCreateScreen(
                              status: 1,
                            )));
              },
              backgroundColor: Color(0xffEE4545),
              isHalf: false,
              text: '기념일 등록',
            ),
            SizedBox(
              height: 40,
            )
          ],
        ),
      ),
    );
  }
}
