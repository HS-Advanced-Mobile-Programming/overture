import 'package:flutter/foundation.dart';

class Schedule {
  final String id;
  String title;
  String content;
  String time;
  String place;

  Schedule({
    required this.id,
    required this.title,
    required this.content,
    required this.time,
    required this.place,
  });
}

class ScheduleModel extends ChangeNotifier {
  List<Schedule> _schedules = [];

  List<Schedule> get schedules => _schedules;

  void addSchedule(Schedule schedule) {
    _schedules.add(schedule);
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
}
