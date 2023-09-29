import 'dart:ui';

import 'package:flutter/material.dart';

class Plan {
  String name;
  String imagePath;
  Status status;
  String startDate;
  String endDate;

  Plan(
      {required this.name,
        required this.imagePath,
        required this.status,
        required this.startDate,
        required this.endDate});


}
enum Status {
  all, // 전체
  scheduled, // 예정
  inProgress, // 진행
  completed, // 완료
  canceled, // 취소
}



extension StatusExtension on Status {
  String toDisplayString() {
    switch (this) {
      case Status.scheduled:
        return '예정';
      case Status.inProgress:
        return '진행중';
      case Status.completed:
        return '완료';
      case Status.canceled:
        return '취소';
        case Status.all:
        return '전체';
      default:
        return '';
    }
  }
  Color toColor() {
    switch (this) {
      case Status.scheduled:
        return Color(0xffF09843);
      case Status.inProgress:
        return Color(0xffEE4545);
      case Status.completed:
        return Color(0xff0D5DE6);
      case Status.canceled:
        return Color(0xff6B41E3);
      default:
        return Colors.black;
    }
  }
}