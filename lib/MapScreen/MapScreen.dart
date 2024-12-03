import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import '../GlobalState/global.dart';
import '../SearchScreen/PlaceDetailsModal.dart';
import '../SearchScreen/SearchScreen.dart';
import 'TopWidget.dart';
import 'BottomWidget.dart';
import 'entity/entity.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late GoogleMapController _controller;
  bool _myLocationEnabled = false;
  Place? _place;
  final String _apiKey = dotenv.get("GOOGLE_PLACES_API_KEY");
  final String _openAiKey = dotenv.get("OPENAI_API_KEY");
  Map<String, dynamic> _placeDetails = {};
  DateTime? selectedDate; // 선택된 날짜
  final Set<Marker> _markers = {}; // 마커 리스트 추가
  final List<BitmapDescriptor> customIcons = []; // 사용자 정의 아이콘 리스트
  final LatLng _center = const LatLng(37.63695556, 127.0277194);

  @override
  void initState() {
    super.initState();
    _initializeLocationPermissions(); // 위치 권한 초기화
    _loadCustomIcons();
  }

  // 위치 권한 확인 및 요청 메서드
  Future<void> _initializeLocationPermissions() async {
    LocationPermission status = await Geolocator.checkPermission();
    if (status == LocationPermission.denied) {
      status = await Geolocator.requestPermission();
      if (status == LocationPermission.denied || status == LocationPermission.deniedForever) {
        // 사용자가 위치 권한을 거부했을 때 처리
        print("위치 권한이 거부되었습니다.");
        return;
      }
    }
    print("위치 권한이 허용되었습니다.");
  }

  static const List<String> colors = [
    "asset/img/marker/red/",
    "asset/img/marker/green/",
    "asset/img/marker/purple/",
  ];

  // BitmapDescriptor 아이콘을 로드하여 customIcons 리스트에 추가
  Future<void> _loadCustomIcons() async {
    // 리스트를 날짜 순으로 정렬
    schedules.sort((a, b) => a.time.compareTo(b.time));

    int count = 1;
    int colorCount = 0;

    // 아이콘 로드 및 날짜별 count 초기화
    for (int i = 0; i < schedules.length; i++) {
      if (i > 0 &&
          (schedules[i].time.year != schedules[i - 1].time.year ||
              schedules[i].time.month != schedules[i - 1].time.month ||
              schedules[i].time.day != schedules[i - 1].time.day)) {
        count = 1; // 날짜가 바뀌면 count 초기화
        colorCount++;
      }

      // BitmapDescriptor 로드
      final icon = await BitmapDescriptor.asset(
        const ImageConfiguration(size: Size(25, 25)),
        '${colors[colorCount]}marker$count.png',
      );

      schedules[i].icon = icon; // 각 Schedule에 아이콘 할당
      count++;
    }

    setState(() {}); // UI 업데이트
  }

  void _onMapCreated(GoogleMapController controller) {
    _controller = controller;
  }

  // 선택된 날짜에 해당하는 Marker 필터링
  Set<Marker> getMarkers() {
    final filteredSchedules = selectedDate == null
        ? schedules
        : schedules.where((schedule) {
      return schedule.time.year == selectedDate!.year &&
          schedule.time.month == selectedDate!.month &&
          schedule.time.day == selectedDate!.day;
    }).toList();

    return filteredSchedules
        .map((schedule) => Marker(
      markerId: MarkerId(schedule.scheduleId.toString()),
      position: schedule.latLng,
      icon: schedule.icon ?? BitmapDescriptor.defaultMarker, // 각 Schedule의 아이콘 사용
      infoWindow: InfoWindow(
        title: schedule.title,
        onTap: () {}, // TODO: 정보 수정
      ),
    ))
        .toSet();
  }

  Future<void> _getCurrentLocation() async {
    final position = await Geolocator.getCurrentPosition();
    final cameraPosition = CameraPosition(
      target: LatLng(position.latitude, position.longitude),
      zoom: 18,
    );
    _controller.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
    setState(() {
      _myLocationEnabled = true;
    });
  }

  // _place 값 변경 시 마커 추가 및 위치 이동
  void _updatePlaceMarker(Place place) {
    final marker = Marker(
      markerId: MarkerId(place.placeId),
      position: LatLng(37.5665, 126.9780), // 예제: 장소의 LatLng 설정 필요
      infoWindow: InfoWindow(
        title: place.name,
        snippet: place.address,
      ),
    );

    setState(() {
      _markers.add(marker); // 마커 추가
    });

    // 지도 카메라 이동
    _controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(37.5665, 126.9780), // 예제: 장소의 LatLng 설정 필요
          zoom: 15,
        ),
      ),
    );
    _fetchReviewsAndDetails(_place!.placeId);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TopSheet(onSearchMarker: (place) {
          _place = place;
          _updatePlaceMarker(place); // 새 마커 추가
                }),
        Expanded(
          child: Stack(
            children: [
              GoogleMap(
                mapType: MapType.normal,
                onMapCreated: _onMapCreated,
                initialCameraPosition: CameraPosition(
                  target: _center,
                  zoom: 11.0,
                ),
                myLocationEnabled: _myLocationEnabled,
                myLocationButtonEnabled: false,
                markers: _markers.union(getMarkers()), // 기존 마커와 새 마커 결합
              ),
              Positioned(
                bottom: 16,
                left: 16,
                child: FloatingActionButton(
                  onPressed: _getCurrentLocation,
                  foregroundColor: Colors.black,
                  backgroundColor: Color(0xFFF0F4F6),
                  elevation: 8, // 그림자 크기
                  child: Icon(Icons.my_location),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50), // 버튼 모서리 둥글기
                  ),
                ),
              ),
            ],
          ),
        ),
        BottomWidget(
          datas: schedules,
          onDateSelected: (DateTime? date) {
            setState(() {
              selectedDate = date;
            });
          },
        ),
      ],
    );
  }

  // 상준's 작품
  void _fetchReviewsAndDetails(String placeId) async {
    final url = Uri.parse(
        'https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&language=ko&key=$_apiKey');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final reviews = data['result']['reviews'] ?? [];

        // 타입을 한국어로 변환하여 설명 설정
        final types = data['result']['types'] as List<dynamic>?;

        final description = (types != null && types.isNotEmpty)
            ? types.map((type) => translateType(type as String)).join(', ')
            : '정보 없음';

        final details = {
          'name': data['result']['name'] ?? '정보 없음', // 장소 이름 추가
          'description': description,
          'phone': data['result']['formatted_phone_number'] ?? '정보 없음',
          'opening_hours':
          data['result']['opening_hours']?['weekday_text'] ?? [],
          'wheelchair_accessible':
          data['result']['wheelchair_accessible_entrance'] ?? false,
        };
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
            openAiKey: _openAiKey, // API 키 전달
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
}
