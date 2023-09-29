import 'dart:convert';

import 'package:cherry_feed/models/calendar/calendar.dart';
import 'package:cherry_feed/models/plan/plan.dart';
import 'package:cherry_feed/utils/api_host.dart';
import 'package:cherry_feed/utils/token_provider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

extension DateTimeExt on DateTime {
  DateTime get dayStart => DateTime(year, month, day);

  DateTime addMonth(int count) {
    return DateTime(year, month + count, day);
  }

  bool isSameDate(DateTime date) {
    return year == date.year && month == date.month && day == date.day;
  }

  bool get isToday {
    return isSameDate(DateTime.now());
  }
}

class CustomCalendar extends StatefulWidget {
  const CustomCalendar({super.key});

  @override
  State<CustomCalendar> createState() => _CustomCalendarState();
}

class _CustomCalendarState extends State<CustomCalendar> {
  late DateTime selectedMonth;
  bool isPicture = false;
  DateTime? selectedDate;

  @override
  void initState() {
    selectedMonth = DateTime.now();
    print(selectedDate.toString());
    super.initState();
  }

  Future<List<Calendar>> _fetchCalendar() async {
    TokenProvider tokenProvider = TokenProvider();
    await tokenProvider.init();
    final token = await tokenProvider.getAccessToken();
    Uri uri = Uri.parse('${ApiHost.API_HOST_DEV}/api/v1/calender');

    http.Response response = await http.get(uri, headers: {
      'Authorization': 'Bearer $token',
    }).catchError((error) => {print(' error : ${error}')});
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(utf8.decode(response.bodyBytes));
      print(data);
      return data.map((e) => Calendar.fromJson(e)).toList();
    } else {
      print(response.body);
      throw Exception('Failed to load calendars');
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Calendar>>(
        future: _fetchCalendar(),
        builder: (BuildContext context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else if (snapshot.hasData) {
            return Padding(
              padding: const EdgeInsets.only(left: 20.0, top: 5.0, right: 20),
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12),
                      child: _Header(
                        isPicture: isPicture,
                        selectedMonth: selectedMonth,
                        selectedDate: selectedDate,
                        activeList: activeList,
                        activePicture: activePicture,
                        onChange: (value) =>
                            setState(() => selectedMonth = value),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 2),
                        child: _Body(
                          isPicture: isPicture,
                          selectedDate: selectedDate,
                          selectedMonth: selectedMonth,
                          calendars: snapshot.requireData,
                          selectDate: (DateTime value) => setState(() {
                            selectedDate = value;
                          }),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          } else {
            print('달력데이터 읽기 실패 : ${snapshot.stackTrace.toString()}');
            return CircularProgressIndicator();
          }
        });
  }

  void activeList() {
    if (isPicture) {
      setState(() {
        isPicture = false;
      });
    }
  }

  void activePicture() {
    if (!isPicture) {
      setState(() {
        isPicture = true;
      });
    }
  }
}

class _Body extends StatelessWidget {
  const _Body({
    required this.selectedMonth,
    required this.selectedDate,
    required this.selectDate,
    required this.calendars,
    required this.isPicture,
  });

  final bool isPicture;
  final List<Calendar> calendars;
  final DateTime selectedMonth;
  final DateTime? selectedDate;

  final ValueChanged<DateTime> selectDate;

  @override
  Widget build(BuildContext context) {
    print('calendars size : ${calendars.length}');
    var data = CalendarMonthData(
      year: selectedMonth.year,
      month: selectedMonth.month,
    );
    return Padding(
      padding: EdgeInsets.only(top: 10),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: const [
              Text(
                '일',
                style: TextStyle(color: Color(0xff707478), fontSize: 13),
              ),
              Text(
                '월',
                style: TextStyle(color: Color(0xff707478), fontSize: 13),
              ),
              Text(
                '화',
                style: TextStyle(color: Color(0xff707478), fontSize: 13),
              ),
              Text(
                '수',
                style: TextStyle(color: Color(0xff707478), fontSize: 13),
              ),
              Text(
                '목',
                style: TextStyle(color: Color(0xff707478), fontSize: 13),
              ),
              Text(
                '금',
                style: TextStyle(color: Color(0xff707478), fontSize: 13),
              ),
              Text(
                '토',
                style: TextStyle(color: Color(0xff707478), fontSize: 13),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (var week in data.weeks)
                Row(
                  children: week.map((d) {
                    return Expanded(
                      child: _RowItem(
                        isPicture: isPicture,
                        hasRightBorder: false,
                        date: d.date,
                        isActiveMonth: d.isActiveMonth,
                        onTap: () => selectDate(d.date),
                        isSelected: selectedDate != null &&
                            selectedDate!.isSameDate(d.date),
                        calendars: calendars
                            .where((calendar) =>
                                (calendar.startAt != null &&
                                    d.date.isSameDate(calendar.startAt!)) ||
                                calendar.endAt != null &&
                                    d.date.isSameDate(calendar.endAt!))
                            .toList(),
                      ),
                    );
                  }).toList(),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _RowItem extends StatelessWidget {
  const _RowItem({
    required this.hasRightBorder,
    required this.isActiveMonth,
    required this.isSelected,
    required this.date,
    required this.onTap,
    required this.calendars,
    required this.isPicture,
  });

  final List<Calendar> calendars;
  final bool hasRightBorder;
  final bool isActiveMonth;
  final VoidCallback onTap;
  final bool isSelected;
  final bool isPicture;

  final DateTime date;

  @override
  Widget build(BuildContext context) {
    if (calendars.length > 0) print(calendars[0].imgId);
    final int number = date.day;
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: Container(
          width: 44,
          height: 100,
          decoration: calendars.isNotEmpty && isPicture
              ? BoxDecoration(
                  borderRadius: BorderRadius.circular(4.0),
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: NetworkImage(
                      ApiHost.API_HOST_DEV +
                          '/api/v1/file/file-system/${calendars.first.imgId!}',
                    ),
                  ),
                )
              : BoxDecoration(
                  borderRadius: BorderRadius.circular(4.0),
                ),
          child: Column(
            children: [
              Container(
                alignment: Alignment.center,
                height: 44,
                width: 44,
                decoration: isSelected
                    ? BoxDecoration(
                        color: Theme.of(context).primaryColor.withOpacity(0.2),
                        shape: BoxShape.circle)
                    : null,
                child: Text(
                  number.toString(),
                  style: TextStyle(
                      fontSize: 19,
                      fontWeight:
                          isSelected ? FontWeight.w600 : FontWeight.normal,
                      color: isSelected
                          ? Theme.of(context).primaryColor
                          : isPicture &&
                                      calendars.isNotEmpty &&
                                      ((calendars.first.startAt != null &&
                                          calendars.first.startAt!.day ==
                                              number) ||
                                  (calendars.first.endAt != null &&
                                      calendars.first.endAt!.day == number))
                              ? Colors.white
                              : Colors.black),
                ),
              ),
              Column(
                children: [
                  Padding(
                      padding: const EdgeInsets.only(bottom: 3),
                      child: SizedBox(
                        height: 46,
                        child: ListView.builder(
                          itemCount: calendars.length,
                          itemBuilder: (BuildContext context, int index) {
                            return isPicture
                                ? const Padding(
                                  padding: EdgeInsets.all(2.0),
                                  child: SizedBox(
                                      height: 20,
                                      width: 44,
                                    ),
                                )
                                : Padding(
                                  padding: const EdgeInsets.all(2.0),
                                  child: Container(
                                      height: 20,
                                      width: 44,
                                      decoration: BoxDecoration(
                                          color: calendars[index].status!.toColor(),
                                          borderRadius: BorderRadius.circular(4)),
                                      child: Center(
                                        child: Text(
                                          calendars[index]
                                              .status!
                                              .toDisplayString(),
                                          style: const TextStyle(
                                              color: Colors.white, fontSize: 12),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ),
                                );
                          },
                        ),
                      ))
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({
    required this.selectedMonth,
    required this.selectedDate,
    required this.onChange,
    required this.isPicture,
    required this.activeList,
    required this.activePicture,
  });

  final VoidCallback activeList;
  final VoidCallback activePicture;
  final DateTime selectedMonth;
  final DateTime? selectedDate;
  final bool isPicture;

  final ValueChanged<DateTime> onChange;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Text(
                          '${selectedMonth.year}년 ${selectedMonth.month}월',
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              fontSize: 25, fontWeight: FontWeight.w600),
                        ),
                        IconButton(
                          onPressed: () {
                            onChange(selectedMonth.addMonth(1));
                          },
                          icon: const Icon(
                            Icons.keyboard_arrow_down_rounded,
                            size: 30,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      width: 104,
                      height: 36,
                      decoration: BoxDecoration(
                        color: const Color(0xff000000).withOpacity(0.1),
                        // Gray background color
                        borderRadius:
                            BorderRadius.circular(7.0), // Rounded corners
                      ),
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: GestureDetector(
                              onTap: activeList,
                              child: Container(
                                width: 48,
                                height: 32,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(7.0),
                                  color: !isPicture ? Colors.white : null,
                                ),
                                child: Center(
                                    child: Image.asset(
                                        !isPicture
                                            ? 'assets/images/list_active.png'
                                            : 'assets/images/list.png',
                                        width: 20,
                                        height: 20)),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(2.0),
                            child: GestureDetector(
                              onTap: activePicture,
                              child: Container(
                                width: 48,
                                height: 32,
                                decoration: BoxDecoration(
                                  color: isPicture ? Colors.white : null,
                                  borderRadius: BorderRadius.circular(7.0),
                                ),
                                child: Center(
                                    child: Image.asset(
                                  isPicture
                                      ? 'assets/images/picture_active.png'
                                      : 'assets/images/picture.png',
                                  width: 20,
                                  height: 20,
                                )),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class CalendarMonthData {
  final int year;
  final int month;

  int get daysInMonth => DateUtils.getDaysInMonth(year, month);

  int get firstDayOfWeekIndex => 1;

  int get weeksCount => ((daysInMonth + firstDayOffset) / 7).ceil();

  const CalendarMonthData({
    required this.year,
    required this.month,
  });

  int get firstDayOffset {
    final int weekdayFromMonday = DateTime(year, month, 1).weekday;
    print(DateTime(year, month, 1).toString());
    return weekdayFromMonday;
  }

  List<List<CalendarDayData>> get weeks {
    final res = <List<CalendarDayData>>[];
    var firstDayMonth = DateTime(year, month, 1);
    var firstDayOfWeek = firstDayMonth.subtract(Duration(days: firstDayOffset));

    for (var w = 0; w < weeksCount; w++) {
      final week = List<CalendarDayData>.generate(
        7,
        (index) {
          final date = firstDayOfWeek.add(Duration(days: index));

          final isActiveMonth = date.year == year && date.month == month;

          return CalendarDayData(
            date: date,
            isActiveMonth: isActiveMonth,
            isActiveDate: date.isToday,
          );
        },
      );
      res.add(week);
      firstDayOfWeek = firstDayOfWeek.add(const Duration(days: 7));
    }
    return res;
  }
}

class CalendarDayData {
  final DateTime date;
  final bool isActiveMonth;
  final bool isActiveDate;

  const CalendarDayData({
    required this.date,
    required this.isActiveMonth,
    required this.isActiveDate,
  });
}
