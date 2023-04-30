import 'package:cherry_feed/appbar/custom_app_bar.dart';
import 'package:cherry_feed/button/next_button.dart';
import 'package:cherry_feed/utils/api_host.dart';
import 'package:cherry_feed/utils/cherry_feed_util.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/calendar/calendar.dart';

class CalendarDetailScreen extends StatefulWidget {
  final Calendar calendar;

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
                onPressed: () {},
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
