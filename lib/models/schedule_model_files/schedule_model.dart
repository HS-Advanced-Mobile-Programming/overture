import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';

class Schedule {
  final String id;
  String title;
  String content;
  String time;
  String place;
  String? x;
  String? y;

  Schedule({
    required this.id,
    required this.title,
    required this.content,
    required this.time,
    required this.place,
    this.x,
    this.y
  });

  /// time 값을 DateTime으로 변환하여 반환
  static DateTime dateTime(String time) {
    try {
      return DateFormat('yyyy-MM-dd HH:mm').parse(time);
    } catch (e) {
      debugPrint('Error parsing time: $e');
      return DateTime(0); // 오류 발생 시 null 반환
    }
  }

  /// DateTime 값을 String으로 변환
  static String dateTimeToString(DateTime dateTime) {
    try {
      return DateFormat('yyyy-MM-dd HH:mm').format(dateTime);
    } catch (e) {
      debugPrint('Error formatting DateTime: $e');
      return ''; // 오류 발생 시 빈 문자열 반환
    }
  }
}

class ScheduleModel extends ChangeNotifier {
  List<Schedule> _schedules = [];

  List<Schedule> get schedules => _schedules;

  void addSchedule(Schedule schedule) {
    _schedules.add(schedule);
    notifyListeners();
  }

  void addScheduleList(List<Schedule> scheduleList) {
    _schedules = [];
    for (Schedule schedule in scheduleList) {
      _schedules.add(schedule);
    }
    notifyListeners();
  }

  void editSchedule(Schedule schedule) {
    final index = _schedules.indexWhere((s) => s.id == schedule.id);
    if (index != -1) {
      _schedules[index] = schedule;
      notifyListeners();
    }
  }

  void deleteSchedule(String id) {
    _schedules.removeWhere((schedule) => schedule.id == id);
    notifyListeners();
  }

  static List<Schedule> schedulesForDate(DateTime selectedDate, List<Schedule> _schedules) {
    return _schedules.where((schedule) {
      try {
        final scheduleDate = DateFormat('yyyy-MM-dd HH:mm').parse(schedule.time);
        return scheduleDate.year == selectedDate.year &&
            scheduleDate.month == selectedDate.month &&
            scheduleDate.day == selectedDate.day;
      } catch (e) {
        return false;
      }
    }).toList();
  }
}
