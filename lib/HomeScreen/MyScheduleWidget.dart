import 'package:flutter/material.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:intl/intl.dart';

import '../service/FirestoreScheduleService.dart';
import '../service/ScheduleDto.dart';

class MyScheduleWidget extends StatefulWidget {

  @override
  State<MyScheduleWidget> createState() => _MyScheduleWidgetState();
}

class _MyScheduleWidgetState extends State<MyScheduleWidget> {
  List<ScheduleDto> schedules = [];

  FirestoreScheduleService scheduleService = FirestoreScheduleService();

  void getAllSchedules() async {
    schedules = await scheduleService.getAllSchedules();

    setState(() {
      schedules;
    });
  }

  @override
  void initState() {
    super.initState();

    getAllSchedules();
  }

  @override
  Widget build(BuildContext context) {

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 32.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15.0),
        child: Container(
          color: Colors.white,
          padding: EdgeInsets.all(32.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "나의 여정",
                style: Theme.of(context)
                    .textTheme
                    .headlineLarge
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 32),
              DottedLine(
                direction: Axis.horizontal,
                lineThickness: 3.0,
                dashColor: Colors.grey,
              ),
              SizedBox(height: 32),
              ..._buildScheduleList(),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildScheduleList() {
    List<Widget> widgets = [];
    String? currentYear;

    for (var schedule in schedules) {
      // 연도가 변경되었을 경우 표시
      DateTime scheduleDate = schedule.toDateTime();

      String scheduleYear = scheduleDate.year.toString();
      String formattedDate = DateFormat('yyyy-MM-dd HH:mm').format(scheduleDate);

      String title = schedule.title;
      String place = schedule.place;
      String content = schedule.content;

      if (scheduleYear != currentYear) {
        currentYear = scheduleYear;
        widgets.add(
          Padding(
            padding: EdgeInsets.only(top: 16.0, bottom: 8.0),
            child: Text(
              currentYear!,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
        );
      }

      // 여행 일정 표시
      widgets.add(
        Padding(
          padding: EdgeInsets.only(bottom: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${title} - ${place}",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                    SizedBox(height: 4),
                    Text(
                      formattedDate,
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }

    return widgets;
  }
}
