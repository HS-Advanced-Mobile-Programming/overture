import 'package:flutter/material.dart';
import 'package:overture/models/schedule_model_files/schedule_model.dart';
import 'package:provider/provider.dart';
import '../widgets/day_selector.dart';
import '../widgets/schedule_item.dart';
import '../widgets/schedule_form.dart';

class ScheduleView extends StatefulWidget {
  final DateTime startDate;
  final DateTime endDate;

  const ScheduleView(
      {super.key, required this.startDate, required this.endDate});

  @override
  _ScheduleViewState createState() => _ScheduleViewState();
}

class _ScheduleViewState extends State<ScheduleView> {
  int _selectedDay = 1;
  DateTime? _selectedDate;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text('📆 일정 관리',
            style: TextStyle(fontWeight: FontWeight.w700)),
      ),
      body: Column(
        children: [
          DaySelector(
            startDate: widget.startDate,
            endDate: widget.endDate,
            selectedDay: _selectedDay,
            onSelectDay: (day) {
              setState(() {
                _selectedDay = day;
                _selectedDate = DateTime(
                  widget.startDate.year,
                  widget.startDate.month,
                  widget.startDate.day + _selectedDay - 1,
                );
              });
            },
          ),
          Expanded(
            child: Consumer<ScheduleModel>(
              builder: (context, scheduleModel, child) {
                _selectedDate ??=
                    widget.startDate.add(Duration(days: _selectedDay - 1));
                final filteredSchedules =
                    scheduleModel.schedulesForDate(_selectedDate!);
                final filteredScheduleModel = ScheduleModel();
                filteredScheduleModel.addScheduleList(filteredSchedules);
                return ListView.builder(
                  itemCount: filteredScheduleModel.schedules.length,
                  itemBuilder: (context, index) {
                    final schedule = filteredScheduleModel.schedules[index];
                    return Padding(
                      padding: const EdgeInsets.all(15),
                      child: Container(
                          child: ScheduleItem(
                            schedule: schedule,
                            onEdit: () {
                              _showScheduleForm(context, schedule: schedule);
                            },
                            onDelete: () {
                              filteredScheduleModel.deleteSchedule(schedule.id);
                              scheduleModel.deleteSchedule(schedule.id);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: const Text('일정이 삭제되었습니다.'),
                                  action: SnackBarAction(
                                    label: '되돌리기',
                                    onPressed: () {
                                      filteredScheduleModel
                                          .addSchedule(schedule);
                                      scheduleModel.addSchedule(schedule);
                                    },
                                  ),
                                ),
                              );
                            },
                          )),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: SizedBox(
        width: 160,
        height: 50,
        child: FloatingActionButton(
            onPressed: () => _showScheduleForm(context),
            backgroundColor: const Color(0xff383838),
            child: Container(
              padding: const EdgeInsets.all(10),
              child: const Text(
                "일정 추가",
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                    fontSize: 16),
              ),
            )),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  void _showScheduleForm(BuildContext context, {Schedule? schedule}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom, // 키보드 높이만큼 패딩 추가
          ),
          child: ScheduleForm(
            selectedDate: _selectedDate!,
            schedule: schedule,
            onSubmit: (newSchedule) {
              final scheduleModel =
                  Provider.of<ScheduleModel>(context, listen: false);
              if (schedule == null) {
                scheduleModel.addSchedule(newSchedule);
              } else {
                scheduleModel.editSchedule(newSchedule);
              }
              Navigator.pop(context);
            },
          ),
        );
      },
    );
  }
}
