import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:overture/models/schedule_model_files/schedule_model.dart';
import 'package:overture/screens/schedule_view.dart';
import 'package:overture/service/FirestoreScheduleService.dart';
import 'package:overture/service/ScheduleDto.dart';
import 'package:provider/provider.dart';

class ScheduleScreen extends StatefulWidget {
  const ScheduleScreen({Key? key}) : super(key: key);

  @override
  _ScheduleScreenState createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  final FirestoreScheduleService service = FirestoreScheduleService();
  List<Schedule> scheduleList = [];
  List<ScheduleDto> fetchSchedule = [];
  bool isLoading = true;

  Future<void> fetchSchedules() async {
    final scheduleModel = Provider.of<ScheduleModel>(context, listen: false);
    fetchSchedule = await service.getAllSchedules();
    scheduleList = [];
    for (ScheduleDto schedule in fetchSchedule) {
      scheduleList.add(Schedule(
        id: schedule.scheduleId,
        title: schedule.title,
        content: schedule.content,
        time: schedule.time,
        place: schedule.place,
      ));
    }
    if (scheduleList.isNotEmpty) {
      scheduleModel.addScheduleList(scheduleList);
    }
    setState(() {
      isLoading = false; // 로딩 상태 업데이트
    });
  }

  @override
  void initState() {
    super.initState();
    fetchSchedules(); // 데이터를 초기화할 때 한 번만 호출
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? const Center(child: CircularProgressIndicator()) // 로딩 중 표시
          : ScheduleView(
        startDate: DateTime.now(),
        endDate: DateTime.now().add(const Duration(days: 7)),
      ),
    );
  }
}