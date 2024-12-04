import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import '../GlobalState/global.dart';
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class ExplainButton extends StatelessWidget {
  final FlutterTts tts; // FlutterTts 필드 추가

  const ExplainButton({required this.tts, super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String?>(
      valueListenable: innerPlace, // innerPlace를 Place? 타입으로 사용
      builder: (context, value, child) {
        return Positioned(
          bottom: 70, // 아래로부터 70 위치
          left: MediaQuery.of(context).size.width / 2 - 50, // 화면 중심 계산
          child: FutureBuilder<String>(
            future: _summarizeReviews(), // Future 작업
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator(); // 로딩 중 표시
              } else if (snapshot.hasError) {
                return Text('오류: ${snapshot.error}'); // 오류 발생 시 메시지 표시
              } else if (snapshot.hasData) {
                final summary = snapshot.data ?? '결과 없음';
                return FilledButton(
                  style: ButtonStyle(
                    backgroundColor: WidgetStatePropertyAll(
                      Colors.blue.shade400,
                    ),
                  ),
                  onPressed: () {
                    tts.speak(summary); // TTS 실행
                  },
                  child: const Text(
                    "설명 듣기", // 현재 상태 값을 표시
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                );
              } else {
                return const Text('결과가 없습니다.'); // 데이터가 없을 때 표시
              }
            },
          ),
        );
      },
    );
  }

  Future<String> _summarizeReviews() async {
    print(innerPlace.value);
    final String _openAiKey = dotenv.get("OPENAI_API_KEY");

    const endpoint = 'https://api.openai.com/v1/chat/completions';

    final body = {
      'model': 'gpt-4o-mini',
      'messages': [
        {
          'role': 'system',
          'content': 'You are a helpful assistant.'
        },
        {
          'role': 'user',
          'content': '다음 장소를 설명해줘 :${innerPlace.value}'
        }
      ],
      'temperature': 0.7
    };

    try {
      final response = await http.post(
        Uri.parse(endpoint),
        headers: {
          'Authorization': 'Bearer $_openAiKey',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(body),
      );

      final responseString = utf8.decode(response.bodyBytes);

      if (response.statusCode == 200) {
        final data = json.decode(responseString);
        return data['choices']?[0]?['message']?['content']?.trim() ??
            data['choices']?[0]?['text']?.trim();
      } else {
        return '요약을 가져오는 데 실패했습니다.';
      }
    } catch (e) {
      return '요약을 가져오는 도중 오류가 발생했습니다.';
    }
  }
}
