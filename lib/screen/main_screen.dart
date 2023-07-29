import 'package:cherry_feed/appbar/main_app_bar.dart';
import 'package:cherry_feed/appbar/plan_app_bar.dart';
import 'package:cherry_feed/models/user/user.dart';
import 'package:cherry_feed/screen/calendar_screen.dart';
import 'package:cherry_feed/screen/couple_screen.dart';
import 'package:cherry_feed/screen/home_screen.dart';
import 'package:cherry_feed/screen/plan_screen.dart';
import 'package:cherry_feed/screen/recommendation_screen.dart';
import 'package:flutter/material.dart';

class MainScreen extends StatefulWidget {
  final User user;
  final int defaultIndex;
  const MainScreen({Key? key, required this.user,required this.defaultIndex}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;
  final List<Widget> _children = [
    HomeScreen(),
    PlanScreen(),
    CalendarScreen(),
    RecommendationScreen(),
    CoupleScreen(),
  ];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _currentIndex = widget.defaultIndex;
  }

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffFAFAFA),
      appBar: _buildAppBar(),
      body: _children[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Color(0xffEE4545),
        unselectedItemColor: Colors.grey,
        selectedFontSize: 12.0,
        unselectedFontSize: 12.0,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.book),
            label: '홈',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.assignment),
            label: '계획',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: '달력',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.thumb_up),
            label: '추천',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite_outline),
            label: '커플',
          ),
        ],
        currentIndex: _currentIndex,
        onTap: onTabTapped,
      ),
    );
  }
  PreferredSizeWidget _buildAppBar() {
    switch (_currentIndex) {
      case 0:
        return MainAppBar();
      case 1:
        return PlanAppBar();
      case 2:
        return AppBar(
          title: Text('커플'),
          backgroundColor: Colors.pink,
          actions: [
            IconButton(
              icon: Icon(Icons.person_add),
              onPressed: () {},
            ),
          ],
        );
      default:
        return PlanAppBar();
    }
  }
}
