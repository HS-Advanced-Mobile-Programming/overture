import 'package:flutter/material.dart';
import 'package:overture/models/schedule_model_files/schedule_model.dart';
import 'package:provider/provider.dart';
import '../widgets/day_selector.dart';
import '../widgets/schedule_item.dart';
import '../widgets/schedule_form.dart';

class ScheduleView extends StatefulWidget {
  final DateTime startDate;
  final DateTime endDate;

  ScheduleView({required this.startDate, required this.endDate});

  @override
  _ScheduleViewState createState() => _ScheduleViewState();
}

class _ScheduleViewState extends State<ScheduleView> {
  int _selectedDay = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('📆 일정 관리', style: TextStyle(fontWeight: FontWeight.w700),),
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
              });
            },
          ),
          Expanded(
            child: Consumer<ScheduleModel>(
              builder: (context, scheduleModel, child) {
                return ListView.builder(
                  itemCount: scheduleModel.schedules.length,
                  itemBuilder: (context, index) {
                    final schedule = scheduleModel.schedules[index];
                    return ScheduleItem(
                      schedule: schedule,
                      onEdit: () {
                        _showScheduleForm(context, schedule: schedule);
                      },
                      onDelete: () {
                        scheduleModel.deleteSchedule(schedule.id);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('일정이 삭제되었습니다.'),
                            action: SnackBarAction(
                              label: '되돌리기',
                              onPressed: () {
                                scheduleModel.addSchedule(schedule);
                              },
                            ),
                          ),
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showScheduleForm(context),
        child: Icon(Icons.add),
      ),
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
            schedule: schedule,
            onSubmit: (newSchedule) {
              final scheduleModel = Provider.of<ScheduleModel>(context, listen: false);
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

