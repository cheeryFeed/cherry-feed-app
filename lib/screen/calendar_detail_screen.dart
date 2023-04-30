import 'package:cherry_feed/appbar/custom_app_bar.dart';
import 'package:flutter/material.dart';

class CalendarDetailScreen extends StatefulWidget {
  const CalendarDetailScreen({Key? key}) : super(key: key);

  @override
  State<CalendarDetailScreen> createState() => _CalendarDetailScreenState();
}

class _CalendarDetailScreenState extends State<CalendarDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(isBorder: false, isShow: true,),
    );
  }
}
