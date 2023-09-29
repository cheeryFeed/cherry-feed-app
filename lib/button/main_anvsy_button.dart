import 'dart:convert';

import 'package:cherry_feed/models/anvsy/anvsy.dart';
import 'package:cherry_feed/screen/anvsy_create_screen.dart';
import 'package:cherry_feed/utils/api_host.dart';
import 'package:cherry_feed/utils/token_provider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class MainAnvsyButton extends StatelessWidget {
  const MainAnvsyButton({Key? key}) : super(key: key);

  Future<List<Anvsy>> _fetchCalendars() async {
    TokenProvider tokenProvider = TokenProvider();
    await tokenProvider.init();
    final token = await tokenProvider.getAccessToken();

    Uri uri = Uri.parse('${ApiHost.API_HOST_DEV}/api/v1/anvsy');
    final response = await http.get(uri, headers: {
      'Authorization': 'Bearer $token',
    });
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(utf8.decode(response.bodyBytes));
      print(data.toString());
      return data.map((e) => Anvsy.fromJson(e)).toList();
    } else {
      print(response.body);
      throw Exception('Failed to load calendars');
    }
  }

  @override
  Widget build(BuildContext context) {
    return checkCalendar(context);
  }

// 기념일이 비었을때 보여줄 화면
  Widget emptyCalendar(context) {
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => AnvsyCreateScreen(status: 0)));
      },
      child: Container(
        height: 320,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFFF4F4F4),
              Color(0xFFFAFAFA),
            ],
            stops: [0, 1],
          ),
          boxShadow: [
            BoxShadow(
              color: Color(0x29000000),
              offset: Offset(4, 4),
              blurRadius: 8,
            ),
          ],
          border: Border.all(
            color: Colors.white,
            width: 1,
          ),
          borderRadius: BorderRadius.circular(13),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              width: 180,
              height: 180,
              child: Image.asset('assets/images/calendar_icon.png'),
            ),
            const Text(
              '기념하고 싶은\n 하루가 언제인가요 ?',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            Container(
              padding: EdgeInsets.only(top: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.only(left: 20),
                    child: const Text(
                      '기념일 등록',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFEE4545),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.add,
                      color: Color(0xFFEE4545),
                      size: 28,
                    ),
                    onPressed: () {},
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  //기념일이 반별하는 위젯.
  Widget checkCalendar(context) {
    return FutureBuilder<List<Anvsy>>(
      future: _fetchCalendars(),
      builder: (BuildContext context, AsyncSnapshot<List<Anvsy>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // 데이터가 로딩 중일 때 표시할 위젯
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasData) {
            // 데이터를 성공적으로 가져왔을 때 표시할 위젯
            return SizedBox(
              height: 370,
              child: existCalendar(context, snapshot.data!),
            );
          } else if (snapshot.hasError) {
            // 데이터를 가져오는 도중 에러가 발생했을 때 표시할 위젯
            print('Error: ${snapshot.error}');
            return emptyCalendar(context);
          } else {
            // 데이터가 없을 때 표시할 위젯
            return emptyCalendar(context);
          }
        } else {
          // 그 외의 상태에 대한 처리
          return emptyCalendar(context);
        }
      },
    );
  }

  //기념일이 채워져 있을때 그려줄 위젯
  Widget existCalendar(BuildContext context, List<Anvsy> data) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(
          data.length,
          (index) => Row(
            children: [
              Container(
                  width: 340,
                  height: 350,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color(0xFFF4F4F4),
                        Color(0xFFFAFAFA),
                      ],
                      stops: [0, 1],
                    ),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x29000000),
                        offset: Offset(4, 4),
                        blurRadius: 8,
                      ),
                    ],
                    border: Border.all(
                      color: Colors.white,
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(13),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Container(
                        height: 240,
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(13),
                            topRight: Radius.circular(13),
                          ),
                          image: data[index].imgId != null
                              ? DecorationImage(
                                  image: NetworkImage('${ApiHost.API_HOST_DEV}/api/v1/file/file-system/${data[index].imgId}'),
                                  fit: BoxFit.cover,
                                )
                              : const DecorationImage(
                                  image: AssetImage(
                                      'assets/images/dummy/ex_8.jpg'),
                                  fit: BoxFit.cover,
                                ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 16, left: 20, right: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              '${data[index].anvsyNm}',
                              style: TextStyle(
                                fontSize: 22,
                              ),
                            ),
                            Text(
                              '${getDday(data[index].anvsyAt)}',
                              style: TextStyle(
                                fontSize: 19,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Row(
                              children: [
                                Icon(Icons.calendar_month_outlined, color: Colors.grey[500],),
                                Text(
                                    '  ${DateFormat('yyyy-MM-dd').format(data[index].anvsyAt!)}',
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.grey[500],
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      )
                    ],
                  )),
              SizedBox(width: 20),
            ],
          ),
        ),
      ),
    );
  }

  String getDday(DateTime? anvsyAt) {
    DateTime now = DateTime.now();
    Duration difference = anvsyAt!.difference(now);
    int days = difference.inDays; // 차이 일수

    String dDay = '';
    if (days > 0) {
      dDay = 'D-${days}';
    } else if (days == 0) {
      dDay = 'D-day';
    } else {
      dDay = 'D+${days.abs()}';
    }
    return dDay;
  }
}
