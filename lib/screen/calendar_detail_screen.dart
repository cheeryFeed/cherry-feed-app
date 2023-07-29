import 'package:cherry_feed/appbar/custom_app_bar.dart';
import 'package:cherry_feed/button/next_button.dart';
import 'package:cherry_feed/screen/calendar_screen.dart';
import 'package:cherry_feed/utils/api_host.dart';
import 'package:cherry_feed/utils/cherry_feed_util.dart';
import 'package:cherry_feed/utils/token_provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

import '../models/anvsy/anvsy.dart';

class CalendarDetailScreen extends StatefulWidget {
  final Anvsy calendar;

  const CalendarDetailScreen({Key? key, required this.calendar})
      : super(key: key);

  @override
  State<CalendarDetailScreen> createState() => _CalendarDetailScreenState();
}

class _CalendarDetailScreenState extends State<CalendarDetailScreen> {
  @override
  void initState() {
    super.initState();
    // Initialize any necessary data or call API to fetch more data
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        isBorder: false,
        isShow: true,
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 200,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                    image: NetworkImage(ApiHost.API_HOST_DEV +
                        '/api/v1/file/file-system/${widget.calendar.imgId}'),
                    fit: BoxFit.cover,
                  )),
                ),
                const SizedBox(
                  height: 20,
                ),
                _DetailBody(),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _DetailBody() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            widget.calendar.anvsyNm ?? '',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '오늘부터',
                style: TextStyle(
                    fontSize: 18,
                    color: Color(0xff707478),
                    fontWeight: FontWeight.w400),
              ),
              Text(
                'D-${widget.calendar.anvsyAt!.difference(DateTime.now()).inDays}',
                style: TextStyle(
                  fontSize: 18,
                  color: Color(0xFFEE4545),
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Text(
              '${DateFormat('yyyy.MM.dd').format(widget.calendar.anvsyAt!)}${CherryFeedUtil.weekdayToString(widget.calendar.anvsyAt!.weekday)}',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
              textAlign: TextAlign.right,
            ),
          ),
          Container(
            height: 1,
            margin: EdgeInsets.symmetric(vertical: 20),
            decoration: BoxDecoration(
              border: Border.all(
                color: Color(0xffABAFB2).withOpacity(0.2),
                width: 1,
              ),
            ),
          ),
          SizedBox(
              height: 300,
              child: buildDDayList(context, widget.calendar.anvsyAt!)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              NextButton(
                text: '삭제',
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16.0),
                        ),
                        title: Padding(
                          padding: const EdgeInsets.only(top:16.0),
                          child: Text('기념일을 삭제할까요 ?',textAlign: TextAlign.center,style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),),
                        ),
                        content: Text('삭제된 일정은 복원이 불가능합니다. \n상대방에게 혼날 수 있으니 확인 해 주세요.',textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.grey),
                        ),
                        actions: [
                          SizedBox(height: 10,),
                          SizedBox(
                            height: 50,
                            child: Row(
                              children: [
                                Expanded(
                                  child: NextButton(
                                    isHalf: true,
                                    textColor: Colors.white,
                                    backgroundColor: Color(0xffEE4545),
                                    onPressed: () {
                                      removeCalendar(context);
                                    },
                                    text: '삭제하기',
                                  ),
                                ),
                                SizedBox(width: 15,),
                                Expanded(
                                  child: NextButton(
                                    textColor: Color(0xffEE4545),
                                    backgroundColor: Color(0xffFFFAFA),
                                    isHalf: true,
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    text: '취소',
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 10,)
                        ],
                      );
                    },
                  );
                },
                isHalf: true,
                backgroundColor: Colors.white,
                textColor: Color(0xffEE4545),
              ),
              NextButton(
                text: '수정',
                onPressed: () {},
                isHalf: true,
                backgroundColor: Color(0xffEE4545),
                textColor: Colors.white,
              ),
            ],
          ),
        ],
      ),
    );
  }
  void removeCalendar(context) async {
    final tokenProvider = TokenProvider();
    await tokenProvider.init();
    final token = await tokenProvider.getAccessToken();
    Uri uri = Uri.parse('${ApiHost.API_HOST_DEV}/api/v1/anvsy/${widget.calendar.id}');
    await http.delete(uri, headers: {
      'Authorization': 'Bearer $token',
    });
    Navigator.push(context, MaterialPageRoute(builder: (context)=>CalendarScreen()));
  }

  Widget buildDDayList(BuildContext context, DateTime targetDate) {
    List<String> dDayList = [];
    // 현재 날짜
    DateTime now = DateTime.now();
    // 날짜 차이. 689
    int diff = targetDate.difference(now).inDays;
    int roundedDiff = (diff ~/ 100) * 100; // 100 단위로 절삭

    while (roundedDiff > 0) {
      dDayList.add('D-${roundedDiff}');
      roundedDiff -= 100;
    }

    if (roundedDiff <= 0) {
      dDayList.add('D-Day');
    }
    print(roundedDiff.toString());

    return ListView.builder(
      shrinkWrap: true,
      itemCount: dDayList.length,
      itemBuilder: (context, index) {
        String dDay = dDayList[index];
        DateTime date = targetDate;
        try {
          if (dDay == 'D-day') {
            date = targetDate;
          } else {
            int daysToAdd = int.parse(dDay.split('-')[1]) + 1;
            date = targetDate.subtract(Duration(days: daysToAdd));
          }
        } catch (FormatException) {
          print('Invalid dDay format. Please provide a valid format such as "D-day" or "D-5".');
        }
        return Container(
          margin: EdgeInsets.only(bottom: 40),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${DateFormat('yyyy.MM.dd').format(date)}${CherryFeedUtil.weekdayToString(date.weekday)}',
                style: TextStyle(
                  fontSize: 18,
                  color: Color(0xff707478),
                  fontWeight: FontWeight.w400,
                ),
              ),
              Text(
                '$dDay',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
