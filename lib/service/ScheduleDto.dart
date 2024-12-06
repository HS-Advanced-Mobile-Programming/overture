import 'package:flutter/cupertino.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:overture/models/schedule_model_files/schedule_model.dart';

class ScheduleDto {
  String scheduleId;
  final String userId;
  final String title;
  final String place;
  final String time;
  final String content;
  String? x;
  String? y;

  ScheduleDto(
      {required this.scheduleId,
      required this.userId,
      required this.title,
      required this.place,
      required this.time,
      required this.content,
      this.x,
      this.y});

  factory ScheduleDto.fromJson(Map<String, dynamic> json, String id) {
    return ScheduleDto(
      scheduleId: id,
      userId: json['userId'],
      title: json['title'],
      place: json['place'],
      time: json['time'],
      content: json['content'],
      x: json['x'] ?? '',
      y: json['y'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'scheduleId': scheduleId,
      'userId': userId,
      'title': title,
      'place': place,
      'time': time,
      'content': content,
      'x': x,
      'y': y,
    };
  }

  DateTime toDateTime() {
    return DateFormat('yyyy-MM-dd HH:mm').parse(time);
  }

  static ScheduleDto toScheduleDto(Schedule schedule, String userId) {
    return ScheduleDto(
      scheduleId: schedule.id,
      userId: userId,
      title: schedule.title,
      place: schedule.place,
      time: schedule.time,
      content: schedule.content,
      x: schedule.x ?? '',
      y: schedule.y ?? '',
    );
  }

  static Schedule toSchedule(ScheduleDto scheduleDto) {
    return Schedule(
      id: scheduleDto.scheduleId,
      title: scheduleDto.title,
      content: scheduleDto.content,
      time: scheduleDto.time,
      place: scheduleDto.place,
      x: scheduleDto.x ?? '',
      y: scheduleDto.y ?? '',
    );
  }

  static ScheduleAndMarker toScheduleAndMarker(ScheduleDto scheduleDto, BitmapDescriptor icon) {
    return ScheduleAndMarker(
      icon: icon,
      id: scheduleDto.scheduleId,
      title: scheduleDto.title,
      content: scheduleDto.content,
      time: scheduleDto.time,
      place: scheduleDto.place,
      x: scheduleDto.x ?? '',
      y: scheduleDto.y ?? '',
    );
  }

  void updateScheduleId(String id) {
    scheduleId = id;
  }
}
