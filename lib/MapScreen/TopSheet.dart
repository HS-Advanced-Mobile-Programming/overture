import 'package:flutter/material.dart';

class TopSheet extends StatelessWidget {
  const TopSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xFFF0F4F6),
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
      child: const Row(
        children: [
          Icon(Icons.arrow_back, size: 30),
          SizedBox(width: 10), // 아이콘과 텍스트 간격 추가
          Icon(Icons.map_rounded, size: 35), // TODO: 추후 색상있는 것으로 변경할 것 or 이미지
          SizedBox(width: 10), // 아이콘과 텍스트 간격 추가
          Text("지도", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
        ],
      ),
    );
  }
}
