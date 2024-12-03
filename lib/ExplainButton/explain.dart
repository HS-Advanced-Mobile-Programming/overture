// // 수정된 _summarizeReviews 메서드
// import 'dart:convert';
//
// import 'package:flutter_dotenv/flutter_dotenv.dart';
//
// Future<void> _summarizeReviews() async {
//   final String _apiKey = dotenv.get("GOOGLE_PLACES_API_KEY");
//   final String _openAiKey = dotenv.get("OPENAI_API_KEY");
//
//   const endpoint = 'https://api.openai.com/v1/chat/completions';
//
//   final body = {
//     'model': 'gpt-4o-mini',
//     'messages': [
//       {
//         'role': 'system',
//         'content': 'You are a helpful assistant.'
//       },
//       {
//         'role': 'user',
//         'content': '다음 리뷰의 내용을 요약해줘 :\n$reviewText \n\n\n'
//       }
//     ],
//     'temperature': 0.7
//   };
//
//   try {
//     final response = await http.post(
//       Uri.parse(endpoint),
//       headers: {
//         'Authorization': 'Bearer ${widget.openAiKey}',
//         'Content-Type': 'application/json',
//       },
//       body: jsonEncode(body),
//     );
//
//     final responseString = utf8.decode(response.bodyBytes);
//
//     if (response.statusCode == 200) {
//       final data = json.decode(responseString);
//       var summary = data['choices']?[0]?['message']?['content']?.trim() ??
//           data['choices']?[0]?['text']?.trim();
//       summary = cleanResponse(summary);
//       setState(() {
//         _summary = summary ?? '요약을 가져오는 데 실패했습니다.';
//       });
//     } else {
//       setState(() {
//         _summary = '요약을 가져오는 데 실패했습니다.';
//       });
//     }
//   } catch (e) {
//     setState(() {
//       _summary = '요약을 가져오는 도중 오류가 발생했습니다.';
//     });
//   }
// }