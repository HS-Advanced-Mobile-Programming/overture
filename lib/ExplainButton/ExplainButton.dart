import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import '../GlobalState/global.dart';
import '../MapScreen/entity/entity.dart';

class ExplainButton extends StatelessWidget {
  final FlutterTts tts; // FlutterTts 필드 추가

  const ExplainButton({required this.tts, super.key});

  void updateInnerPlace(Place? value) {
    innerPlace.value = value; // 상태 업데이트
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Place?>(
      valueListenable: innerPlace, // innerPlace를 Place? 타입으로 사용
      builder: (context, value, child) {
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
              // 상태를 변경하여 UI 업데이트 테스트
              if (value != null) {
                tts.speak("${value.name}에 진입하였습니다."); // TTS 실행
              } else {
                tts.speak("현재 장소 정보가 없습니다."); // 값이 null일 때 처리
              }
            },
            child: const Text(
              "설명 듣기", // 현재 상태 값을 표시
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        );
      },
    );
  }
}
