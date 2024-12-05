import 'package:flutter/material.dart';

import '../models/schedule_model_files/schedule_model.dart';

class BottomWidget extends StatefulWidget {
  final List<Schedule> datas; // 외부에서 전달받을 데이터
  final ValueChanged<DateTime?> onDateSelected; // 날짜 선택 콜백

  const BottomWidget({required this.datas, required this.onDateSelected, super.key});

  @override
  State<BottomWidget> createState() => _BottomWidgetState();
}

class _BottomWidgetState extends State<BottomWidget> {
  late List<bool> isSelected;
  late List<Schedule> datas;

  @override
  void initState() {
    super.initState();
    datas = widget.datas.isNotEmpty ? widget.datas : [];
    isSelected = List<bool>.filled(datas.length + 1, false); // '전체' 버튼 포함
    isSelected[0] = true; // 전체 버튼 활성화
  }

  @override
  Widget build(BuildContext context) {
    final uniqueDates = _getUniqueDates(datas);

    return Container(
      color: const Color(0xFFF0F4F6),
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5.0),
              child: GestureDetector(
                onTap: () => _onButtonPressed(0, null),
                child: Container(
                  width: 90,
                  height: 40,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: isSelected[0] ? Colors.black : Colors.transparent,
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: Colors.grey),
                  ),
                  child: Text(
                    "전체",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: isSelected[0] ? Colors.white : Colors.black,
                      fontWeight: isSelected[0] ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                ),
              ),
            ),
            for (int i = 0; i < uniqueDates.length; i++)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5.0),
                child: _buildButton(
                  isSelected: isSelected[i + 1],
                  onTap: () => _onButtonPressed(
                    i + 1,
                    uniqueDates[i],
                  ),
                  dateTime: uniqueDates[i],
                  firstDay: uniqueDates[0],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildButton({
    required bool isSelected,
    required VoidCallback onTap,
    required DateTime dateTime,
    required DateTime firstDay,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 90,
        height: 40,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isSelected ? Colors.black : Colors.transparent,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: Colors.grey),
        ),
        child: _DateText(
            firstDay: firstDay,
            dateTime: dateTime,
            isSelected: isSelected
        ),
      ),
    );
  }

  Widget _DateText({
    required DateTime firstDay,
    required DateTime dateTime,
    required bool isSelected,
  }) {
    return Column(
      children: [
        Text(
          "${(dateTime.difference(firstDay).inDays+1).toString()}일차", // TODO: 시간 변경할 것
          textAlign: TextAlign.center,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        Text(
          "${dateTime.month}.${dateTime.day}(${getWeekdayString(dateTime.weekday)})",
          textAlign: TextAlign.center,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            fontSize: 8,
          ),
        )
      ],
    );
  }

  void _onButtonPressed(int index, DateTime? date) {
    setState(() {
      for (int i = 0; i < isSelected.length; i++) {
        isSelected[i] = false;
      }
      isSelected[index] = true;
    });
    widget.onDateSelected(date);
  }

  List<DateTime> _getUniqueDates(List<Schedule> schedules) {
    final uniqueDates = <DateTime>{};
    for (var schedule in schedules) {
      var dateTime = Schedule.dateTime(schedule.time);
      uniqueDates.add(DateTime(dateTime.year, dateTime.month, dateTime.day));
    }
    return uniqueDates.toList()..sort();
  }

  String getWeekdayString(int weekday) {
    switch (weekday) {
      case 1:
        return "월";
      case 2:
        return "화";
      case 3:
        return "수";
      case 4:
        return "목";
      case 5:
        return "금";
      case 6:
        return "토";
      case 7:
        return "일";
      default:
        return "";
    }
  }
}
