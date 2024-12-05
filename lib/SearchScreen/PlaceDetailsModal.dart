import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class PlaceDetailsModal extends StatefulWidget {
  final Map<String, dynamic> placeDetails;
  final List<dynamic> reviews;
  final String openAiKey;

  const PlaceDetailsModal({
    super.key,
    required this.placeDetails,
    required this.reviews,
    required this.openAiKey,
  });

  @override
  State<PlaceDetailsModal> createState() => _PlaceDetailsModalState();
}

class _PlaceDetailsModalState extends State<PlaceDetailsModal> {
  bool _isLoadingMenu = false;
  bool _isLoadingSummary = false;
  String _summary = '';
  List<String>? _recommendedMenu;

  @override
  void initState() {
    super.initState();
    // 메뉴 추천은 음식점인 경우에만 가져옵니다.
    if (widget.placeDetails['isRestaurant'] == true) {
      _fetchRecommendedMenu(
        widget.placeDetails['name'] ?? '음식점',
        widget.reviews,
      );
    }
  }

  /// 메뉴 추천을 가져오는 함수
  void _fetchRecommendedMenu(String restaurantName, List<dynamic> reviews) async {
    setState(() {
      _isLoadingMenu = true;
    });

    const endpoint = 'https://api.openai.com/v1/chat/completions';
    final address = widget.placeDetails['address'] ?? '주소 없음';

    // 리뷰 텍스트를 하나의 문자열로 결합
    final reviewText = reviews
        .map((review) =>
    '${review['author_name'] ?? '익명'}: ${review['text'] ?? '내용 없음'}')
        .join('\n');

    final body = {
      'model': 'gpt-4', // 올바른 모델 이름으로 수정 (예: 'gpt-4')
      'messages': [
        {
          'role': 'system',
          'content':
          'You are a helpful assistant who provides menu recommendations based on restaurant details and customer reviews.'
        },
        {
          'role': 'user',
          'content':
          '다음 음식점의 추천 메뉴를 알려줘. 상호명은 "$restaurantName"이고, 주소는 "$address" 이야. 또한, 아래의 리뷰를 참고해서 추천 메뉴를 제안해줘. 각 단락에는 이모지를 사용해줘.\n\n리뷰:\n$reviewText'
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

      // UTF-8로 디코딩
      final responseString = utf8.decode(response.bodyBytes);

      if (response.statusCode == 200) {
        final data = json.decode(responseString);
        final content = data['choices'][0]['message']['content'] as String;

        setState(() {
          _recommendedMenu = content
              .split('\n')
              .map((line) => line.trim())
              .where((line) => line.isNotEmpty)
              .toList();
          _isLoadingMenu = false;
        });
      } else {
        print('Failed to fetch recommended menu: ${response.statusCode}');
        setState(() {
          _isLoadingMenu = false;
        });
      }
    } catch (e) {
      print('Error fetching menu: $e');
      setState(() {
        _isLoadingMenu = false;
      });
    }
  }

  /// 리뷰를 요약하는 함수
  Future<void> _summarizeReviews() async {
    setState(() {
      _isLoadingSummary = true;
    });

    const endpoint = 'https://api.openai.com/v1/chat/completions';

    final reviewText = widget.reviews
        .map((review) =>
    '${review['author_name'] ?? '익명'}: ${review['text'] ?? '내용 없음'}')
        .join('\n');

    final body = {
      'model': 'gpt-4o-mini',
      'messages': [
        {'role': 'system', 'content': 'You are a helpful assistant.'},
        {
          'role': 'user',
          'content':
          '다음 리뷰의 내용을 요약해줘:\n$reviewText\n\n'
              '장점 👍🏻, 단점 👎🏻, 주요 특징 (특징 요약) 🔎, 추천 대상 🎯, 평균 가격/비용 💰, '
              '방문 시간/혼잡도 ⏰, 서비스 품질 🏆, 위치와 접근성 📍, 사용자 경험 등을 🙋🏻 '
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

      // UTF-8로 디코딩
      final responseString = utf8.decode(response.bodyBytes);

      if (response.statusCode == 200) {
        final data = json.decode(responseString);
        var summary = data['choices']?[0]?['message']?['content']?.trim() ??
            data['choices']?[0]?['text']?.trim();
        summary = cleanResponse(summary);
        setState(() {
          _summary = summary ?? '요약을 가져오는 데 실패했습니다.';
          _isLoadingSummary = false;
        });
      } else {
        setState(() {
          _summary = '요약을 가져오는 데 실패했습니다.';
          _isLoadingSummary = false;
        });
      }
    } catch (e) {
      setState(() {
        _summary = '요약을 가져오는 도중 오류가 발생했습니다.';
        _isLoadingSummary = false;
      });
    }
  }

  /// 응답을 정리하는 함수
  String cleanResponse(String response) {
    int advantageIndex = response.indexOf('장점');
    int colonIndex = response.lastIndexOf(':', advantageIndex);
    if (colonIndex != -1 && colonIndex < advantageIndex) {
      return response.substring(colonIndex + 1).trim();
    }
    return response;
  }

  @override
  Widget build(BuildContext context) {
    final bool isRestaurant = widget.placeDetails['isRestaurant'] ?? false;

    // 페이지 수 계산
    int pageCount = widget.reviews.length + 1; // 첫 번째 페이지 + 리뷰들
    if (isRestaurant) {
      pageCount += 1; // 음식점인 경우 추천 메뉴 페이지 추가
    }

    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.7,
      child: Column(
        children: [
          // 상단 표시 (드래그 핸들)
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
              itemCount: pageCount,
              itemBuilder: (context, index) {
                if (index == 0) {
                  // 첫 번째 페이지: 장소 상세 정보 및 요약
                  return _buildFirstPage();
                } else if (isRestaurant && index == 1) {
                  // 추천 메뉴 페이지
                  return _buildRecommendedMenuPage();
                } else {
                  // 리뷰 페이지
                  final reviewIndex = isRestaurant ? index - 2 : index - 1;
                  if (reviewIndex >= 0 && reviewIndex < widget.reviews.length) {
                    final review = widget.reviews[reviewIndex];
                    return _buildReviewPage(review);
                  } else {
                    return const Center(child: Text('리뷰가 없습니다.'));
                  }
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  /// 첫 번째 페이지 빌드
  Widget _buildFirstPage() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (_summary.isEmpty)
              _isLoadingSummary
                  ? const Center(
                child: Column(
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 16),
                    Text("요약 중입니다..."),
                  ],
                ),
              )
                  : Center(
                child: ElevatedButton(
                  onPressed: () async {
                    setState(() {
                      _isLoadingSummary = true;
                    });
                    await _summarizeReviews();
                    setState(() {
                      _isLoadingSummary = false;
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
                      content:
                      widget.placeDetails['wheelchair_accessible'] == true
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

  /// 영업시간을 문자열로 반환
  String _getOpeningHours() {
    final openingHours = widget.placeDetails['opening_hours'];
    if (openingHours is List && openingHours.isNotEmpty) {
      return openingHours.join('\n');
    } else {
      return '정보 없음';
    }
  }

  /// 정보 행을 빌드하는 함수
  Widget _buildInfoRow({required String title, required String content}) {
    const emojiMap = {
      '장소 이름': '🏠',
      '설명': '📝',
      '전화번호': '📞',
      '영업시간': '⏰',
      '장애인 편의시설': '♿',
    };

    final emoji = emojiMap[title] ?? 'ℹ️';

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

  /// 추천 메뉴 페이지를 빌드하는 함수
  Widget _buildRecommendedMenuPage() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: _isLoadingMenu
          ? const Center(
        child: CircularProgressIndicator(),
      )
          : (_recommendedMenu == null || _recommendedMenu!.isEmpty)
          ? const Center(
        child: Text(
          '추천 메뉴가 없습니다.',
          style: TextStyle(fontSize: 16),
        ),
      )
          : ListView.builder(
        itemCount: _recommendedMenu!.length,
        itemBuilder: (context, index) {
          final line = _recommendedMenu![index];
          // 이모지와 텍스트 스타일링 적용
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: RichText(
              text: TextSpan(
                style:
                const TextStyle(fontSize: 16, color: Colors.black),
                children: _parseLineWithStyles(line),
              ),
            ),
          );
        },
      ),
    );
  }

  /// 라인을 파싱하여 이모지와 스타일을 적용하는 함수
  List<TextSpan> _parseLineWithStyles(String line) {
    final List<TextSpan> spans = [];
    final boldRegex = RegExp(r'\*\*(.*?)\*\*');
    final emojiRegex =
    RegExp(r'([\u2600-\u27BF\uD83C-\uDBFF\uDC00-\uDFFF]+)');
    int lastIndex = 0;

    final matches = boldRegex.allMatches(line);
    for (final match in matches) {
      if (match.start > lastIndex) {
        spans.add(TextSpan(text: line.substring(lastIndex, match.start)));
      }
      spans.add(TextSpan(
          text: match.group(1),
          style: const TextStyle(fontWeight: FontWeight.bold)));
      lastIndex = match.end;
    }
    if (lastIndex < line.length) {
      spans.add(TextSpan(text: line.substring(lastIndex)));
    }

    // 이모지 처리
    return spans.expand((span) {
      final text = span.text!;
      final matches = emojiRegex.allMatches(text);
      if (matches.isEmpty) {
        return [span];
      } else {
        final List<TextSpan> emojiSpans = [];
        int lastIndex = 0;
        for (final match in matches) {
          if (match.start > lastIndex) {
            emojiSpans.add(TextSpan(
                text: text.substring(lastIndex, match.start),
                style: span.style));
          }
          emojiSpans.add(TextSpan(
              text: match.group(0),
              style: span.style?.copyWith(fontSize: 20)));
          lastIndex = match.end;
        }
        if (lastIndex < text.length) {
          emojiSpans.add(
              TextSpan(text: text.substring(lastIndex), style: span.style));
        }
        return emojiSpans;
      }
    }).toList();
  }

  /// 리뷰 페이지를 빌드하는 함수
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
}
