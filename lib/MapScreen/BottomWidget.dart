import 'package:flutter/material.dart';

class BottomWidget extends StatefulWidget {
  const BottomWidget({super.key});

  @override
  State<BottomWidget> createState() => _BottomWidgetState();
}

class _BottomWidgetState extends State<BottomWidget> {
  // 각 버튼의 선택 상태를 저장하는 리스트
  List<bool> isSelected = [true]; // 첫 번째 버튼이 선택된 상태로 초기화

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFF0F4F6),
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
      child: ToggleButtons(
        isSelected: isSelected,
        onPressed: (int index) {
          // 상태 업데이트: 선택 상태 토글
          setState(() {
            isSelected[index] = !isSelected[index];
          });
        },
        borderRadius: BorderRadius.circular(20.0),
        selectedColor: Colors.white,
        fillColor: Colors.black,
        color: Colors.black,
        borderColor: Colors.grey,
        children: [
          // 버튼의 너비와 높이를 설정
          ConstrainedBox(
            constraints: const BoxConstraints(
              minWidth: 100, // 버튼 너비
              minHeight: 30, // 버튼 높이 (기존에서 10 감소)
            ),
            child: const Center(
              child: Text('전체'),
            ),
          ),
        ],
      ),
    );
  }
}