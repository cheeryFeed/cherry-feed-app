import 'dart:ui';

import 'package:cherry_feed/models/calendar/check_list.dart';
import 'package:cherry_feed/models/plan/plan.dart';
import 'package:flutter/material.dart';

class Calendar {
  final int? id;
  final DateTime? alarmAt;
  final bool? allDay;
  final List<CheckList> checkList;
  final String? content;
  final DateTime? startAt;
  final DateTime? endAt;
  final int? imgId;
  final String? location;
  final Status? status;
  final String? title;
  final int? type;

  Calendar({
    required this.id,
    required this.alarmAt,
    required this.allDay,
    required this.checkList,
    required this.content,
    required this.endAt,
    required this.imgId,
    required this.location,
    required this.startAt,
    required this.status,
    required this.title,
    required this.type,
  });

  factory Calendar.fromJson(Map<String, dynamic> json) {
    List<CheckList> parsedCheckList = [];
    if (json['checkList'] != null) {
      var checkListList = json['checkList'] as List;
      parsedCheckList =
          checkListList.map((item) => CheckList.fromJson(item)).toList();
    }
    Status transferString(String status) {
      Status defaultStatus = Status.all;
      switch (status) {
        case 'scheduled':
          defaultStatus = Status.scheduled;
          break;
        case 'all':
          defaultStatus = Status.all;
          break;
        case 'inProgress':
          defaultStatus = Status.inProgress;
          break;
        case 'completed':
          defaultStatus = Status.completed;
          break;
        case 'canceled':
          defaultStatus = Status.canceled;
          break;
      }
      return defaultStatus;
    }

    return Calendar(
      id: json['id'] as int,
      alarmAt: json['alarmAt'] != null
          ? DateTime.parse(json['alarmAt'])
          : DateTime(0),
      allDay: json['allDay'] as bool?,
      checkList: parsedCheckList,
      content: json['content'] as String,
      endAt:
          json['endAt'] != null ? DateTime.parse(json['endAt']) : DateTime(0),
      imgId: json['imgId'] as int,
      location: json['location'] as String,
      startAt: json['startAt'] != null
          ? DateTime.parse(json['startAt'])
          : DateTime(0),
      status: transferString(json['status']) as Status,
      title: json['title'] as String,
      type: json['type'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = this.id;
    data['alarmAt'] = this.alarmAt?.toIso8601String();
    data['allDay'] = this.allDay;
    data['checkList'] = this.checkList.map((item) => item.toJson()).toList();
    data['content'] = this.content;
    data['endAt'] = this.endAt?.toIso8601String();
    data['imgId'] = this.imgId;
    data['location'] = this.location;
    data['startAt'] = this.startAt?.toIso8601String();
    data['status'] = this.status;
    data['title'] = this.title;
    data['type'] = this.type;
    return data;
  }

  @override
  String toString() {
    return 'CalendarResponseModel{id: $id, alarmAt: $alarmAt, allDay: $allDay, checkList: $checkList, content: $content, endAt: $endAt, imgId: $imgId, location: $location, startAt: $startAt, status: $status, title: $title, type: $type}';
  }
}


