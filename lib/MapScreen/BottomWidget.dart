import 'package:flutter/material.dart';
import 'package:overture/MapScreen/MapScreen.dart';

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
    isSelected[0] = true; // 첫 번째 버튼 활성화
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
              child: _buildButton(
                isSelected: isSelected[0],
                onTap: () => _onButtonPressed(0, null),
                label: "전체",
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
                  label:
                  "${uniqueDates[i].month}.${uniqueDates[i].day}(${getWeekdayString(uniqueDates[i].weekday)})",
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
    required String label,
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
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
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
      uniqueDates.add(DateTime(schedule.time.year, schedule.time.month, schedule.time.day));
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
