import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PlaceDetailsModal extends StatefulWidget {
  final Map<String, dynamic> placeDetails;
  final List<dynamic> reviews;
  final String openAiKey; // OpenAI API 키 추가

  const PlaceDetailsModal({
    super.key,
    required this.placeDetails,
    required this.reviews,
    required this.openAiKey, // OpenAI API 키 추가
  });

  @override
  State<PlaceDetailsModal> createState() => _PlaceDetailsModalState();
}

class _PlaceDetailsModalState extends State<PlaceDetailsModal> {
  bool _isLoading = false; // AI 요약 대기 상태
  String _summary = ''; // AI 요약 결과 로컬 상태

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.7,
      child: Column(
        children: [
          // 상단 표시
          Container(
            width: 50,
            height: 5,
            margin: const EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          Expanded(
            child: PageView.builder(
              itemCount: widget.reviews.length + 1, // 첫 페이지 + 리뷰 페이지 수
              itemBuilder: (context, index) {
                if (index == 0) {
                  // 첫 번째 페이지
                  return _buildFirstPage();
                } else {
                  // 리뷰 페이지
                  final review = widget.reviews[index - 1];
                  return _buildReviewPage(review);
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFirstPage() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (_summary.isEmpty)
              _isLoading
                  ? const Center(
                child: Column(
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 16),
                    Text("요약 중입니다..."),
                  ],
                ),
              )
                  : Center( // 버튼을 Center로 감쌈
                child: ElevatedButton(
                  onPressed: () async {
                    setState(() {
                      _isLoading = true;
                    });
                    await _summarizeReviews();
                    setState(() {
                      _isLoading = false;
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 12),
                  ),
                  child: const Text('AI로 요약'),
                ),
              ),
            const SizedBox(height: 20),
            if (_summary.isNotEmpty)
              Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  _summary,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black87,
                    fontFamily: 'Roboto', // 기본 폰트 사용
                  ),
                ),
              )
            else
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildInfoRow(
                      title: '장소 이름',
                      content: widget.placeDetails['name'] ?? '정보 없음',
                    ),
                    _buildInfoRow(
                      title: '설명',
                      content: widget.placeDetails['description'] ?? '정보 없음',
                    ),
                    _buildInfoRow(
                      title: '전화번호',
                      content: widget.placeDetails['phone'] ?? '정보 없음',
                    ),
                    _buildInfoRow(
                      title: '영업시간',
                      content: _getOpeningHours(),
                    ),
                    _buildInfoRow(
                      title: '장애인 편의시설',
                      content: widget.placeDetails['wheelchair_accessible']
                          ? '있음'
                          : '없음',
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  String _getOpeningHours() {
    final openingHours = widget.placeDetails['opening_hours'];
    if (openingHours is List && openingHours.isNotEmpty) {
      return openingHours.join('\n');
    } else {
      return '정보 없음';
    }
  }

  Widget _buildReviewPage(dynamic review) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // 리뷰 작성자 프로필 사진
          CircleAvatar(
            radius: 40,
            backgroundImage: NetworkImage(
              review['profile_photo_url'] ?? 'https://via.placeholder.com/150',
            ),
          ),
          const SizedBox(height: 10),
          // 작성자 이름
          Text(
            review['author_name'] ?? '익명',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 5),
          // 작성일
          Text(
            review['relative_time_description'] ?? '',
            style: const TextStyle(
              fontSize: 14,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 10),
          // 별점
          RatingBarIndicator(
            rating: review['rating']?.toDouble() ?? 0.0,
            itemBuilder: (context, index) => const Icon(
              Icons.star,
              color: Colors.amber,
            ),
            itemCount: 5,
            itemSize: 24.0,
          ),
          const SizedBox(height: 20),
          // 리뷰 내용
          Expanded(
            child: SingleChildScrollView(
              child: Text(
                review['text'] ?? '리뷰 내용이 없습니다.',
                style: const TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow({required String title, required String content}) {
    // 이모지 매핑 추가
    const emojiMap = {
      '장소 이름': '🏠',
      '설명': '📝',
      '전화번호': '📞',
      '영업시간': '⏰',
      '장애인 편의시설': '♿',
    };

    final emoji = emojiMap[title] ?? 'ℹ️'; // 기본 이모지

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: RichText(
        text: TextSpan(
          text: '$emoji $title: ',
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
          children: [
            TextSpan(
              text: content,
              style: const TextStyle(
                fontWeight: FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 수정된 _summarizeReviews 메서드
  Future<void> _summarizeReviews() async {
    const endpoint = 'https://api.openai.com/v1/chat/completions';

    final reviewText = widget.reviews
        .map((review) =>
    '${review['author_name'] ?? '익명'}: ${review['text'] ?? '내용 없음'}')
        .join('\n');

    final body = {
      'model': 'gpt-4o-mini',
      'messages': [
        {
          'role': 'system',
          'content': 'You are a helpful assistant.'
        },
        {
          'role': 'user',
          'content': '다음 리뷰의 내용을 요약해줘 :\n$reviewText \n\n\n'
              '장점 👍🏻, 단점 👎🏻, 주요 특징 (특징 요약) 🔎, 추천 대상 🎯, 평균 가격/비용 💰, '
              '방문 시간/혼잡도 ⏰, 서비스 품질 🏆, 위치와 접근성 📍, 사용자 경험 등을 🙋🏻'
              '이모지로 단락을 구분해서 알려줘 (리뷰어의 이름은 내용에 포함하지 마)'
        }
      ],
      'temperature': 0.7
    };

    try {
      final response = await http.post(
        Uri.parse(endpoint),
        headers: {
          'Authorization': 'Bearer ${widget.openAiKey}',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(body),
      );

      final responseString = utf8.decode(response.bodyBytes);

      if (response.statusCode == 200) {
        final data = json.decode(responseString);
        var summary = data['choices']?[0]?['message']?['content']?.trim() ??
            data['choices']?[0]?['text']?.trim();
        summary = cleanResponse(summary);
        setState(() {
          _summary = summary ?? '요약을 가져오는 데 실패했습니다.';
        });
      } else {
        setState(() {
          _summary = '요약을 가져오는 데 실패했습니다.';
        });
      }
    } catch (e) {
      setState(() {
        _summary = '요약을 가져오는 도중 오류가 발생했습니다.';
      });
    }
  }

  String cleanResponse(String response) {
    int advantageIndex = response.indexOf('장점');
    int colonIndex = response.lastIndexOf(':', advantageIndex);
    if (colonIndex != -1 && colonIndex < advantageIndex) {
      return response.substring(colonIndex + 1).trim();
    }
    return response;
  }

}