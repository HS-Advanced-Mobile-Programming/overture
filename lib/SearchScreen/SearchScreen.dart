import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../MapScreen/entity/entity.dart';
import 'PlaceDetailsModal.dart';

class PlaceSearchScreen extends StatefulWidget {
  const PlaceSearchScreen({super.key});

  @override
  _PlaceSearchScreenState createState() => _PlaceSearchScreenState();
}

class _PlaceSearchScreenState extends State<PlaceSearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<dynamic> _searchResults = [];
  final String _apiKey = dotenv.get("GOOGLE_PLACES_API_KEY");
  final String _openAiKey = dotenv.get("OPENAI_API_KEY");
  Map<String, dynamic> _placeDetails = {};

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _searchPlaces(String query) async {
    if (query.isEmpty) return;

    final url = Uri.parse(
        'https://maps.googleapis.com/maps/api/place/textsearch/json?query=$query&language=ko&key=$_apiKey');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final results = data['results'];

        setState(() {
          _searchResults = results;
        });

        // 첫 번째 결과가 음식점인 경우 즉시 추천 메뉴 요청
        if (results.isNotEmpty) {
          final topResult = results[0];
          final types = topResult['types'] as List<dynamic>?;
          if (types != null && types.contains('restaurant')) {
            fetchRecommendedMenuForPlace(topResult['place_id']);
          }
        }
      } else {
        throw Exception('Failed to load places');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  void fetchRecommendedMenuForPlace(String placeId) async {
    final url = Uri.parse(
        'https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&language=ko&key=$_apiKey');

    try {
      final response = await http.get(url);

      final responseString = utf8.decode(response.bodyBytes);
      if (response.statusCode == 200) {
        final data = json.decode(responseString);
        final restaurantName = data['result']['name'] ?? '음식점';

        // GPT-4o로 추천 메뉴 가져오기
        final recommendedMenu = await fetchRecommendedMenu(restaurantName);

        setState(() {
          _placeDetails['recommendedMenu_$placeId'] = recommendedMenu;
        });
      } else {
        throw Exception('Failed to fetch place details');
      }
    } catch (e) {
      print('Error fetching details: $e');
    }
  }

  Future<List<String>> fetchRecommendedMenu(String restaurantName) async {
    const endpoint = 'https://api.openai.com/v1/chat/completions';

    final body = {
      'model': 'gpt-4o-mini',
      'messages': [
        {
          'role': 'system',
          'content':
          'You are a helpful assistant who provides menu recommendations.'
        },
        {
          'role': 'user',
          'content': '다음 음식점의 추천 메뉴를 알려줘: $restaurantName.'
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
        final content = data['choices'][0]['message']['content'] as String;
        return content
            .split('\n')
            .map((line) => line.trim())
            .where((line) => line.isNotEmpty)
            .toList();
      } else {
        throw Exception('Failed to fetch recommended menu');
      }
    } catch (e) {
      print('Error fetching menu: $e');
      return [];
    }
  }

  void _fetchReviewsAndDetails(String placeId) async {
    final url = Uri.parse(
        'https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&language=ko&key=$_apiKey');

    try {
      final response = await http.get(url);

      final responseString = utf8.decode(response.bodyBytes);
      if (response.statusCode == 200) {
        final data = json.decode(responseString);
        final reviews = data['result']['reviews'] ?? [];

        // 타입을 한국어로 변환하여 설명 설정
        final types = data['result']['types'] as List<dynamic>?;

        final description = (types != null && types.isNotEmpty)
            ? types.map((type) => translateType(type as String)).join(', ')
            : '정보 없음';

        final isRestaurant = types != null && types.contains('restaurant');

        final details = {
          'placeId': placeId,
          'name': data['result']['name'] ?? '정보 없음',
          'description': description,
          'phone': data['result']['formatted_phone_number'] ?? '정보 없음',
          'opening_hours':
          data['result']['opening_hours']?['weekday_text'] ?? [],
          'wheelchair_accessible':
          data['result']['wheelchair_accessible_entrance'] ?? false,
          'isRestaurant': isRestaurant,
        };

        if (isRestaurant) {
          // 이미 추천 메뉴를 가져왔는지 확인
          List<String>? recommendedMenu =
          _placeDetails['recommendedMenu_$placeId'];

          if (recommendedMenu == null) {
            // 추천 메뉴를 가져오지 않은 경우, 가져오기
            recommendedMenu =
            await fetchRecommendedMenu(details['name'] ?? '음식점');
            _placeDetails['recommendedMenu_$placeId'] = recommendedMenu;
          }

          details['recommendedMenu'] = recommendedMenu;
        }

        setState(() {
          _placeDetails = details;
        });

        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          builder: (context) => PlaceDetailsModal(
            placeDetails: _placeDetails,
            reviews: reviews,
            openAiKey: _openAiKey,
          ),
        );
      } else {
        print('API 오류: ${response.statusCode}');
        throw Exception('Failed to load details and reviews');
      }
    } catch (e) {
      print('Error fetching details: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('검색'),
        backgroundColor: Colors.white,
      ),
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: const InputDecoration(
                      labelText: '장소',
                      border: OutlineInputBorder(),
                    ),
                    onSubmitted: _searchPlaces,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () {
                    _searchPlaces(_searchController.text);
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _searchResults.length,
              itemBuilder: (context, index) {
                final place = _searchResults[index];
                final String name = place['name'] ?? '이름 없음';
                final double rating = place['rating']?.toDouble() ?? 0.0;
                final String address = place['formatted_address'] ?? '주소 없음';
                return GestureDetector(
                  onTap: () {
                    Navigator.pop(
                      context,
                      Place(
                        name: name,
                        address: address,
                        rating: rating,
                        placeId: place['place_id'],
                      ),
                    );
                  },
                  onLongPress: () =>
                      _fetchReviewsAndDetails(place['place_id']),
                  child: ListTile(
                    title: Text(name),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(address),
                        Row(
                          children: [
                            RatingBarIndicator(
                              rating: rating,
                              itemBuilder: (context, index) => const Icon(
                                Icons.star,
                                color: Colors.amber,
                              ),
                              itemCount: 5,
                              itemSize: 16.0,
                            ),
                            const SizedBox(width: 8),
                            Text('$rating'),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}



// 영어 타입을 한국어로 변환하는 메서드
String translateType(String type) {
  const typeMap = {
    // 기존 매핑
    'university': '대학',
    'point_of_interest': '관광지',
    'restaurant': '음식점',
    'cafe': '카페',
    'hotel': '호텔',
    'park': '공원',
    'museum': '박물관',
    'library': '도서관',
    'shopping_mall': '쇼핑몰',
    'accounting': '회계',
    'airport': '공항',
    'amusement_park': '놀이공원',
    'aquarium': '수족관',
    'art_gallery': '미술관',
    'atm': 'ATM',
    'bakery': '베이커리',
    'bank': '은행',
    'bar': '바',
    'beauty_salon': '미용실',
    'bicycle_store': '자전거 상점',
    'book_store': '서점',
    'bowling_alley': '볼링장',
    'bus_station': '버스 정류장',
    'campground': '캠핑장',
    'car_dealer': '자동차 대리점',
    'car_rental': '렌터카',
    'car_repair': '자동차 수리점',
    'car_wash': '세차장',
    'casino': '카지노',
    'cemetery': '묘지',
    'church': '교회',
    'city_hall': '시청',
    'clothing_store': '의류 상점',
    'convenience_store': '편의점',
    'courthouse': '법원',
    'dentist': '치과',
    'department_store': '백화점',
    'doctor': '의사',
    'drugstore': '약국',
    'electrician': '전기공',
    'electronics_store': '전자상점',
    'embassy': '대사관',
    'fire_station': '소방서',
    'florist': '꽃집',
    'funeral_home': '장례식장',
    'furniture_store': '가구점',
    'gas_station': '주유소',
    'gym': '체육관',
    'hair_care': '헤어살롱',
    'hardware_store': '철물점',
    'hindu_temple': '힌두 사원',
    'home_goods_store': '생활용품점',
    'hospital': '병원',
    'insurance_agency': '보험 대행점',
    'jewelry_store': '보석상',
    'laundry': '세탁소',
    'lawyer': '변호사 사무소',
    'light_rail_station': '경전철 역',
    'liquor_store': '주류 판매점',
    'local_government_office': '지방 정부 사무소',
    'locksmith': '자물쇠 수리공',
    'lodging': '숙박시설',
    'meal_delivery': '음식 배달',
    'meal_takeaway': '음식 테이크아웃',
    'mosque': '모스크',
    'movie_rental': '영화 대여점',
    'movie_theater': '영화관',
    'moving_company': '이사 업체',
    'night_club': '나이트클럽',
    'painter': '화가',
    'parking': '주차장',
    'pet_store': '애완동물 가게',
    'physiotherapist': '물리치료사',
    'plumber': '배관공',
    'police': '경찰서',
    'post_office': '우체국',
    'primary_school': '초등학교',
    'real_estate_agency': '부동산 중개업소',
    'roofing_contractor': '지붕 시공업체',
    'rv_park': 'RV 공원',
    'school': '학교',
    'secondary_school': '중학교',
    'shoe_store': '신발가게',
    'spa': '스파',
    'stadium': '스타디움',
    'storage': '보관소',
    'store': '상점',
    'subway_station': '지하철역',
    'supermarket': '슈퍼마켓',
    'synagogue': '회당',
    'taxi_stand': '택시 승차장',
    'tourist_attraction': '관광명소',
    'train_station': '기차역',
    'transit_station': '환승역',
    'travel_agency': '여행사',
    'veterinary_care': '수의사',
    'zoo': '동물원',
    'administrative_area_level_1': '행정구역 1단계',
    'administrative_area_level_2': '행정구역 2단계',
    'administrative_area_level_3': '행정구역 3단계',
    'administrative_area_level_4': '행정구역 4단계',
    'administrative_area_level_5': '행정구역 5단계',
    'administrative_area_level_6': '행정구역 6단계',
    'administrative_area_level_7': '행정구역 7단계',
    'archipelago': '군도',
    'colloquial_area': '일상 용어 지역',
    'continent': '대륙',
    'country': '국가',
    'establishment': '설립',
    'finance': '금융',
    'floor': '층',
    'food': '음식',
    'general_contractor': '일반 계약자',
    'geocode': '지오코드',
    'health': '건강',
    'intersection': '교차로',
    'landmark': '랜드마크',
    'locality': '지역',
    'natural_feature': '자연경관',
    'neighborhood': '이웃',
    'place_of_worship': '예배 장소',
    'plus_code': '플러스 코드',
    'post_box': '사서함',
    'postal_code': '우편번호',
    'postal_code_prefix': '우편번호 접두사',
    'postal_code_suffix': '우편번호 접미사',
    'postal_town': '우편도시',
    'premise': '건물',
    'room': '방',
    'route': '경로',
    'street_address': '도로명 주소',
    'street_number': '도로 번호',
    'sublocality': '하위 지역',
    'sublocality_level_1': '하위 지역 1단계',
    'sublocality_level_2': '하위 지역 2단계',
    'sublocality_level_3': '하위 지역 3단계',
    'sublocality_level_4': '하위 지역 4단계',
    'sublocality_level_5': '하위 지역 5단계',
    'subpremise': '부속 건물',
    'town_square': '타운 스퀘어',
  };
  return typeMap[type] ?? type;
}