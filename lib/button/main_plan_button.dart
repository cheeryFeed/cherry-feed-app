import 'dart:convert';

import 'package:cherry_feed/models/calendar/calendar.dart';
import 'package:cherry_feed/models/plan/plan.dart';
import 'package:cherry_feed/screen/plan/plan_detail_screen.dart';
import 'package:cherry_feed/utils/api_host.dart';
import 'package:cherry_feed/utils/token_provider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
class MainPlanButton extends StatelessWidget {
  const MainPlanButton({Key? key}) : super(key: key);

  Future<List<Calendar>> _fetchPlan() async {
    TokenProvider tokenProvider = TokenProvider();
    await tokenProvider.init();
    final token = await tokenProvider.getAccessToken();

    Uri uri = Uri.parse('${ApiHost.API_HOST_DEV}/api/v1/calender');
    final response = await http.get(uri, headers: {
      'Authorization': 'Bearer $token',
    });
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(utf8.decode(response.bodyBytes));
      print(data.toString());
      return data.map((e) => Calendar.fromJson(e)).toList();
    } else {
      print(response.body);
      throw Exception('Failed to load Plan');
    }
  }

  @override
  Widget build(BuildContext context) {
    return checkPlan(context);
  }


  //기념일을 판별하는 위젯.
  Widget checkPlan(context) {
    return FutureBuilder<List<Calendar>>(
      future: _fetchPlan(),
      builder: (BuildContext context, AsyncSnapshot<List<Calendar>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // 데이터가 로딩 중일 때 표시할 위젯
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasData) {
            // 데이터를 성공적으로 가져왔을 때 표시할 위젯
            return SizedBox(
              height: 370,
              child: existPlan(context, snapshot.data!),
            );
          } else if (snapshot.hasError) {
            // 데이터를 가져오는 도중 에러가 발생했을 때 표시할 위젯
            print('Error: ${snapshot.error}');
            return emptyPlan(context);
          } else {
            // 데이터가 없을 때 표시할 위젯
            return emptyPlan(context);
          }
        } else {
          // 그 외의 상태에 대한 처리
          return emptyPlan(context);
        }
      },
    );
  }

  //기념일이 채워져 있을때 그려줄 위젯
  Widget existPlan(BuildContext context, List<Calendar> data) {
    DateFormat formatJson = DateFormat('yyyy-MM-dd');
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(
          data.length,
              (index) => Row(
            children: [
              GestureDetector(
                onTap:()=> Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => PlanDetailScreen(
                            calendar: data[index]))),
                child: Container(
                    width: 340,
                    height: 350,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
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
                                '${data[index].title}',
                                style: TextStyle(
                                  fontSize: 22,
                                ),
                              ),
                              Text(
                                '${data[index].status?.toDisplayString()}',
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
                                    ' ${formatJson.format(data[index].startAt!)} ~ ${formatJson.format(data[index].endAt!)}',
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
              ),
              SizedBox(width: 20),
            ],
          ),
        ),
      ),
    );
  }

  /**
   * 기념일이 존재 하지 않을 때 그려줄 화면
   */
  Widget emptyPlan(BuildContext context) {
    return Container(
      height: 104,
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
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: SizedBox(
              width: 80,
              height: 80,
              child: Image.asset('assets/images/plan_icon.png'),
            ),
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: 14,),
                const Text(
                  '함께 세운 여행 계획이 있나요 ?',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w400
                  ),
                  textAlign: TextAlign.left,
                ),
                Row(
                  children: [
                    const Text(
                      '계획 세우기',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFEE4545),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    IconButton(
                      icon: const Icon(Icons.arrow_forward_ios, color: Color(0xFFEE4545)),
                      onPressed: () {},
                    )
                  ],
                ),
              ],
            ),
          ),

        ],
      ),
    );
  }


}
