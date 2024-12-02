import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'TopSheet.dart';
import 'BottomWidget.dart';

class Schedule {
  final int scheduleId;
  final int userId;
  final String title;
  final DateTime time;
  final LatLng latLng;
  BitmapDescriptor? icon; // 아이콘 추가

  Schedule({
    required this.scheduleId,
    required this.userId,
    required this.title,
    required this.time,
    required this.latLng,
    this.icon,
  });

  @override
  String toString() {
    return 'Schedule(scheduleId: $scheduleId, userId: $userId, title: "$title", time: $time, latLng: $latLng)';
  }
}

List<Schedule> schedules = [
  Schedule(scheduleId: 1, userId: 1, title: "출국", time: DateTime(2024, 12, 1, 1, 0, 0), latLng: LatLng(37.63695556, 127.0277194)),
  Schedule(scheduleId: 2, userId: 1, title: "호텔 체크인", time: DateTime(2024, 12, 1, 3, 0, 0), latLng: LatLng(37.68695556, 127.0277194)),
  Schedule(scheduleId: 3, userId: 1, title: "파이브가이즈에서 식사", time: DateTime(2024, 12, 1, 6, 0, 0), latLng: LatLng(37.73695556, 127.0277194)),
  Schedule(scheduleId: 4, userId: 1, title: "기상", time: DateTime(2024, 12, 2, 1, 0, 0), latLng: LatLng(37.78695556, 127.0777194)),
  Schedule(scheduleId: 5, userId: 1, title: "셰르파 미팅", time: DateTime(2024, 12, 2, 3, 0, 0), latLng: LatLng(37.83695556, 127.0777194)),
  Schedule(scheduleId: 6, userId: 1, title: "에베레스트 산 등산", time: DateTime(2024, 12, 2, 6, 0, 0), latLng: LatLng(37.88695556, 127.0777194)),
  Schedule(scheduleId: 7, userId: 1, title: "쇼핑하기", time: DateTime(2024, 12, 3, 1, 0, 0), latLng: LatLng(37.93695556, 127.1277194)),
  Schedule(scheduleId: 8, userId: 1, title: "호텔 체크 아웃", time: DateTime(2024, 12, 3, 3, 0, 0), latLng: LatLng(37.98695556, 127.1277194)),
  Schedule(scheduleId: 9, userId: 1, title: "귀국", time: DateTime(2024, 12, 3, 6, 0, 0), latLng: LatLng(38.03695556, 127.1277194)),
];

// TODO: schedules로 API 주입 받을 것

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late GoogleMapController _controller;
  bool _myLocationEnabled = false;

  DateTime? selectedDate; // 선택된 날짜
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

  static const List<String> colors = ["asset/img/marker/red/", "asset/img/marker/green/", "asset/img/marker/purple/",];

  // TODO: 로직 내부에서 정렬을 계속 진행하는데, 수정 필요 있음
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

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const TopSheet(),
        Expanded(
          child:
          Stack(
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
                markers: getMarkers(),
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
            ]
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
}
