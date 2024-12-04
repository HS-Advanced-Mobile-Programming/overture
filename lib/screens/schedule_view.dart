import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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
  DateTime? _selectedDate = DateTime.now();
  String selectedFilter = 'Date';
  late ScheduleModel filteredScheduleModel = ScheduleModel();
  late ScheduleModel originScheduleModel;

  void _sortItems(String filter) {
    setState(() {
      selectedFilter = filter;
      if (filter == 'Date') {
        filteredScheduleModel.schedules.sort((a, b) =>
            (DateFormat('yyyy-MM-dd HH:mm').parse(a.time)).compareTo(
                (DateFormat('yyyy-MM-dd HH:mm').parse(b.time)))); // 최신순
      } else if (filter == 'Name') {
        filteredScheduleModel.schedules
            .sort((a, b) => a.title.compareTo(b.title)); // 최신순
      }
    });
  }

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
                _selectedDate ??=
                    widget.startDate.add(Duration(days: _selectedDay - 1));
                final filteredSchedules =
                    originScheduleModel.schedulesForDate(_selectedDate!);
                filteredScheduleModel.addScheduleList(filteredSchedules);
              });
            },
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              PopupMenuButton<String>(
                onSelected: (value) {
                  _sortItems(value); // 정렬 함수 호출
                },
                itemBuilder: (BuildContext context) => [
                  PopupMenuItem(
                    value: 'Date',
                    child: Text('시간 순'),
                  ),
                  PopupMenuItem(
                    value: 'Name',
                    child: Text('이름 순'),
                  ),
                ],
                icon: Icon(Icons.filter_alt_sharp),
              ),
              SizedBox(width: 20),
            ],
          ),
          Expanded(
            child: Consumer<ScheduleModel>(
              builder: (context, scheduleModel, child) {
                originScheduleModel = scheduleModel;
                return filteredScheduleModel.schedules.isEmpty
                    ? const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "이 날짜에 예정된 일정이 없습니다.",
                            style: TextStyle(color: Color(0xff5F5F5F)),
                          )
                        ],
                      )
                    : ListView.builder(
                        itemCount: filteredScheduleModel.schedules.length,
                        itemBuilder: (context, index) {
                          final schedule =
                              filteredScheduleModel.schedules[index];
                          return Padding(
                            padding: const EdgeInsets.all(15),
                            child: Container(
                                child: ScheduleItem(
                              schedule: schedule,
                              onEdit: () {
                                _showScheduleForm(context, schedule: schedule);
                              },
                              onDelete: () {
                                filteredScheduleModel
                                    .deleteSchedule(schedule.id);
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
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(height: 50, color: Colors.transparent),
              Padding(
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context)
                      .viewInsets
                      .bottom, // 키보드 높이만큼 패딩 추가
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
              ),
            ],
          ),
        );
      },
    );
  }
}
