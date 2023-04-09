import 'package:cherry_feed/models/plan/plan.dart';
import 'package:flutter/material.dart';

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
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
                  Text('진행 상황',
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

    List<Plan> planList = [
      Plan(
        name: '동대문디자인프라자',
        imagePath: 'assets/images/dummy/ex_1.jpg',
        status: Status.inProgress,
        startDate: '23.04.01',
        endDate: '23.04.30',
      ),
      Plan(
        name: '제주 아르떼뮤지엄',
        imagePath: 'assets/images/dummy/ex_2.jpg',
        status: Status.scheduled,
        startDate: '23.03.01',
        endDate: '23.03.31',
      ),
      Plan(
        name: '서소문성지역사박물관',
        imagePath: 'assets/images/dummy/ex_3.jpg',
        status: Status.canceled,
        startDate: '23.05.01',
        endDate: '23.05.31',
      ),
      // 나머지 7개의 Plan 객체도 생성하여 planList에 추가하면 됩니다.
    ];
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
                        Icon(
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
            child: ListView.builder(
              itemCount: planList.length,
              itemBuilder: (context, index) {
                Plan plan = planList[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
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
                                image: AssetImage(plan.imagePath),
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
                                      size: 10, color: Color(0xffEE4545)),
                                  const SizedBox(width: 8),
                                  Text(
                                    plan.status.toDisplayString(),
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w400,
                                      color: Color(0xffEE4545),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Text(
                                plan.name,
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(
                                height: 12,
                              ),
                              Row(
                                children: [
                                  Icon(Icons.calendar_today,
                                      color: Colors.grey),
                                  SizedBox(width: 8),
                                  Text(
                                    '${plan.startDate} ~ ${plan.endDate}',
                                    style: TextStyle(
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
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
