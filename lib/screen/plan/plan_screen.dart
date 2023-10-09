import 'dart:convert';

import 'package:cherry_feed/models/calendar/calendar.dart';
import 'package:cherry_feed/models/plan/plan.dart';
import 'package:cherry_feed/screen/plan/plan_detail_screen.dart';
import 'package:cherry_feed/utils/api_host.dart';
import 'package:cherry_feed/utils/token_provider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class PlanScreen extends StatefulWidget {
  const PlanScreen({Key? key}) : super(key: key);

  @override
  State<PlanScreen> createState() => _PlanScreenState();
}

class _PlanScreenState extends State<PlanScreen> {
  late Status initStatus;
  @override
  void initState() {
    initStatus = Status.all;
    // _fetchCalendar();
    super.initState();
  }
  Future<List<Calendar>> _fetchCalendar() async {
    TokenProvider tokenProvider = TokenProvider();
    await tokenProvider.init();
    final token = await tokenProvider.getAccessToken();
    Uri uri = Uri.parse('${ApiHost.API_HOST_DEV}/api/v1/calender');
    
    http.Response response = await http.get(uri, headers: {
      'Authorization': 'Bearer $token',
    }).catchError((error) => {print(' error : $error')});
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(utf8.decode(response.bodyBytes));
      return data.map((e) => Calendar.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load calendars');
    }

  }
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // 텍스트 + 아래 펼치기 아이콘
                GestureDetector(
                  onTap: () {
                    _showModalBottomSheet(context);
                  },
                  child: SizedBox(
                    width: 72,
                    height: 44,
                    child: Row(
                      children: [
                        Text(
                          initStatus.toDisplayString(),
                          style: TextStyle(fontSize: 20),
                        ),
                        const Icon(
                          Icons.keyboard_arrow_down,
                          size: 26,
                        )
                      ],
                    ),
                  ),
                ),
                const Icon(
                  Icons.search,
                  size: 26,
                )
              ],
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: FutureBuilder<List<Calendar>>(
              future: _fetchCalendar(),
              builder: (BuildContext context, snapshot) {
                DateFormat format = new DateFormat('yyyy-MM-dd');
                if(snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if(snapshot.hasData) {
                  return ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: GestureDetector(
                        onTap:()=> Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => PlanDetailScreen(
                                    calendar: snapshot.data![index]))),
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(13),
                            side: const BorderSide(
                              color: Colors.white,
                              width: 1,
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Row(
                              children: [
                                Container(
                                  height: 110,
                                  width: 110,
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: NetworkImage('${ApiHost.API_HOST_DEV}/api/v1/file/file-system/${snapshot.data![index].imgId}'),
                                      fit: BoxFit.cover,
                                    ),
                                    borderRadius: BorderRadius.circular(13),
                                  ),
                                ),
                                SizedBox(
                                  width: 20,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Icon(Icons.circle,
                                            size: 10, color: snapshot.data![index].status!.toColor()),
                                        const SizedBox(width: 8),
                                        Text(
                                          snapshot.data![index].status!.toDisplayString(),
                                          style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.w400,
                                            color: snapshot.data![index].status!.toColor(),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 12),
                                    Text(
                                      snapshot.data![index].title == null ? '무제' : snapshot.data![index].title!,
                                      style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 12,
                                    ),
                                    Row(
                                      children: [
                                        const Icon(Icons.calendar_today,
                                            color: Colors.grey),
                                        const SizedBox(width: 8),
                                        Text(
                                          '${format.format(snapshot.data![index].startAt!)} ~ ${format.format(snapshot.data![index].startAt!)}',
                                          style: const TextStyle(
                                            fontSize: 14,
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                }
                return const CircularProgressIndicator();
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showModalBottomSheet(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30.0),
      ),
      builder: (BuildContext context) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(30.0),
          ),
          child: Padding(
            padding: const EdgeInsets.all(30.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text('진행 상황',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 24,
                        fontWeight: FontWeight.bold)),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: Status.values.map((status) {
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            initStatus = status;
                          });
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              status.toDisplayString(),
                              style: TextStyle(
                                color: initStatus == status
                                    ? const Color(0xffEE4545)
                                    : Colors.grey,
                                fontSize: 20,
                              ),
                            ),
                            if (initStatus == status)
                              const Icon(Icons.check, color: Color(0xffEE4545))
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
