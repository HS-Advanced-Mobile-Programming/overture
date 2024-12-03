import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ExplainButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 70, // 아래로부터 70 위치
      left: MediaQuery.of(context).size.width / 2 - 50, // 화면 중심 계산
      child: FilledButton(
        style: ButtonStyle(
          backgroundColor: WidgetStatePropertyAll(
            Colors.blue.shade400,
          ),
        ),
        onPressed: () {
          // TODO: 장소 설명
        },
        child: const Text(
          "설명 듣기",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

}