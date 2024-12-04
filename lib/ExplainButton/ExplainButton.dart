import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import '../GlobalState/global.dart';
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class ExplainButton extends StatefulWidget {
  final FlutterTts tts; // FlutterTts 필드 추가

  const ExplainButton({required this.tts, super.key});

  @override
  State<ExplainButton> createState() => _ExplainButtonState();
}

class _ExplainButtonState extends State<ExplainButton> {
  bool _isVisible = false;
  Timer? _timer;
  String? _summary; // 설명 데이터를 캐싱
  bool _isLoading = false; // 로딩 상태 관리

  @override
  void initState() {
    super.initState();

    // innerPlace 변경을 감지
    innerPlace.addListener(() {
      if (innerPlace.value != null) {
        _fetchSummary(); // 설명 데이터를 가져옴
        setState(() {
          _isVisible = true;
        });
      }
    });
  }

  Future<void> _fetchSummary() async {
    setState(() {
      _isLoading = true;
    });

    _summary = await _summarizeReviews();

    setState(() {
      _isLoading = false;
    });

    // 로딩이 끝난 후 타이머 시작
    if (_summary != null) {
      _startTimer();
    }
  }

  void _startTimer() {
    _timer?.cancel(); // 기존 타이머가 있다면 취소
    _timer = Timer(const Duration(seconds: 5), () {
      setState(() {
        _isVisible = false;
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel(); // 컴포넌트 해제 시 타이머 취소
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String?>(
      valueListenable: innerPlace,
      builder: (context, value, child) {
        return Visibility(
          visible: _isVisible,
          child: Positioned(
            bottom: 70, // 아래로부터 70 위치
            right: 16, // 화면 중심 계산
            width: 60,
            height: 60,
            child: _isLoading
                ? const CircularProgressIndicator()
                : IconButton(
              style: ButtonStyle(
                backgroundColor: WidgetStatePropertyAll(
                  Color(0xFF74AA9C),
                ),
              ),
              onPressed: () {
                // 버튼 클릭 시에도 TTS 실행
                if (_summary != null) {
                  widget.tts.speak(_summary!);
                }
              },
              icon: Image.asset(
                  'asset/img/gpt.png',
                  color: Colors.white,
              )
            ),
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
          'content': '다음 장소를 짧게 설명해줘 :${innerPlace.value}'
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
