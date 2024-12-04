import 'package:flutter/material.dart';
import 'package:overture/models/schedule_model_files/schedule_model.dart';
import 'package:overture/screens/schedule_view.dart';
import 'package:overture/service/FirestoreScheduleService.dart';
import 'package:overture/service/ScheduleDto.dart';
import 'package:provider/provider.dart';

class ScheduleScreen extends StatelessWidget {
  final FirestoreScheduleService service = FirestoreScheduleService();
  List<Schedule> scheduleList = [];
  List<ScheduleDto> fetchSchedule = [];
  ScheduleScreen({super.key});

  Future<void> fetchSchedules(BuildContext context) async {
    final scheduleModel = Provider.of<ScheduleModel>(context);
    fetchSchedule = await service.getAllSchedules(); // 비동기 작업 결과 가져오기
    for (ScheduleDto schedule in fetchSchedule) {
      scheduleList.add(Schedule(
        id: schedule.scheduleId,
        title: schedule.title,
        content: schedule.content,
        time: schedule.time,
        place: schedule.place, // 'location'으로 수정 (place와 혼동 방지)
      ));
    }
    if(scheduleList.isNotEmpty) scheduleModel.addScheduleList(scheduleList);
  }

  @override
  Widget build(BuildContext context) {
    fetchSchedules(context);
    return Scaffold(
      body: ScheduleView(
        startDate: DateTime.now(),
        endDate: DateTime.now().add(const Duration(days: 7)),
      ),
    );
  }
}
