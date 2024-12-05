import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hive/hive.dart';
import 'package:overture/models/place_model_files/place_model.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class PlaceRepository {
  final Box placeBox = Hive.box('placesBox');

  Future<List<Place>> fetchAndCachePlaces(String query) async {
    final url = Uri.parse('https://dapi.kakao.com/v2/local/search/keyword.json?page=1&size=6&sort=accuracy&query=$query');
    final key = dotenv.get("KAKAO_MAP_KEY");
    final response = await http.get(url, headers: {
      "Authorization": "KakaoAK $key"
    });

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      final List<dynamic> documents = jsonResponse['documents'];

      // API 응답 데이터를 Place 객체로 변환하고 저장
      List<Place> places = documents.map((doc) {
        final place = Place(
          id: doc['id'],
          placeName: doc['place_name'],
          addressName: doc['address_name'],
          roadAddressName: doc['road_address_name'],
          categoryName: doc['category_name'],
          placeUrl: doc['place_url'],
          x: doc['x'],
          y: doc['y'],
        );
        placeBox.put(place.id, place); // Hive에 저장
        return place;
      }).toList();

      return places;
    } else {
      throw Exception("Failed to fetch data");
    }
  }

  List<Place> getCachedPlaces() {
    return placeBox.values.cast<Place>().toList();
  }
}
