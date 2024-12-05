import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class DeepLService {
  final String apiKey = dotenv.get("DEEPL_API_KEY");

  Future<String> translateText(String text, String targetLang) async {
    final url = Uri.parse("https://api-free.deepl.com/v2/translate");

    final encodedBody = utf8.encode(Uri(queryParameters: {
      "text": text,
      "target_lang": targetLang,
    }).query);

    final response = await http.post(
      url,
      headers: {
        "Authorization": "DeepL-Auth-Key $apiKey",
        "Content-Type": "application/x-www-form-urlencoded; charset=UTF-8",
      },
      body: encodedBody,
    );

    if (response.statusCode == 200) {
      final decodedResponse = utf8.decode(response.bodyBytes);
      final data = json.decode(decodedResponse);
      return data["translations"][0]["text"];
    } else {
      throw Exception("Failed to translate text: ${response.statusCode}");
    }
  }
}
