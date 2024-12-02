import 'package:flutter/material.dart';
import 'package:overture/MapScreen/MapScreen.dart';

class BottomWidget extends StatefulWidget {
  final List<Schedule> datas; // 외부에서 전달받을 데이터

  const BottomWidget({required this.datas, super.key});

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
    // 날짜별로 버튼 생성 (중복 제거)
    final uniqueDates = _getUniqueDates(datas);

    return Container(
      color: const Color(0xFFF0F4F6),
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal, // 가로 스크롤 활성화
        child: Row(
          children: [
            // '전체' 버튼
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5.0),
              child: _buildButton(
                isSelected: isSelected[0],
                onTap: () => _onButtonPressed(0),
                label: "전체",
              ),
            ),
            // 고유 날짜 버튼
            for (int i = 0; i < uniqueDates.length; i++)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5.0),
                child: _buildButton(
                  isSelected: isSelected[i + 1],
                  onTap: () => _onButtonPressed(i + 1),
                  label: uniqueDates[i],
                ),
              ),
          ],
        ),
      ),
    );
  }

  // 개별 버튼 생성 메서드
  Widget _buildButton({
    required bool isSelected,
    required VoidCallback onTap,
    required String label,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 90, // 버튼 너비 조정
        height: 40, // 버튼 높이 조정
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
          ),
        ),
      ),
    );
  }

  // 버튼 클릭 이벤트 처리
  void _onButtonPressed(int index) {
    setState(() {
      for (int i = 0; i < isSelected.length; i++) {
        isSelected[i] = false;
      }
      isSelected[index] = true;
    });
  }

  void updateData(List<Schedule> newDatas) {
    setState(() {
      datas = newDatas;
      isSelected = List<bool>.filled(datas.length + 1, false);
      isSelected[0] = true;
    });
  }

  // 날짜별 고유 값 추출 메서드
  List<String> _getUniqueDates(List<Schedule> schedules) {
    final uniqueDates = <String>{}; // Set으로 중복 제거
    for (var schedule in schedules) {
      final dateString =
          "${schedule.time.month}.${schedule.time.day}(${getWeekdayString(schedule.time.weekday)})";
      uniqueDates.add(dateString);
    }
    return uniqueDates.toList();
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
