import 'package:intl/intl.dart';
import 'package:overture/models/schedule_model_files/schedule_model.dart';

class ScheduleDto {
  final String scheduleId;
  final String userId;
  final String title;
  final String place;
  final String time;
  final String content;

  ScheduleDto(
      {required this.scheduleId,
      required this.userId,
      required this.title,
      required this.place,
      required this.time,
      required this.content});

  factory ScheduleDto.fromJson(Map<String, dynamic> json) {
    return ScheduleDto(
        scheduleId: json['scheduleId'],
        userId: json['userId'],
        title: json['title'],
        place: json['place'],
        time: json['time'],
        content: json['content']);
  }

  Map<String, dynamic> toJson() {
    return {
      'scheduleId': scheduleId,
      'userId': userId,
      'title': title,
      'place': place,
      'time': time,
      'content': content
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
        content: schedule.content);
  }
}
