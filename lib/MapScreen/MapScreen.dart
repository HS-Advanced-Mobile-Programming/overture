import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'TopSheet.dart';
import 'BottomWidget.dart';

class Schedule {
  final int scheduleId;
  final int userId;
  final String title;
  final DateTime time;
  final LatLng latLng;

  Schedule({
    required this.scheduleId,
    required this.userId,
    required this.title,
    required this.time,
    required this.latLng,
  });

  @override
  String toString() {
    return 'Schedule(scheduleId: $scheduleId, userId: $userId, title: "$title", time: $time, latLng: $latLng)';
  }
}

List<Schedule> sampleData = [
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

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late GoogleMapController mapController;
  DateTime? selectedDate; // 선택된 날짜

  final LatLng _center = const LatLng(37.63695556, 127.0277194);

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  // 선택된 날짜에 해당하는 Marker 필터링
  Set<Marker> getMarkers() {
    final filteredSchedules = selectedDate == null
        ? sampleData
        : sampleData.where((schedule) {
      return schedule.time.year == selectedDate!.year &&
          schedule.time.month == selectedDate!.month &&
          schedule.time.day == selectedDate!.day;
    }).toList();

    return filteredSchedules
        .map((schedule) => Marker(
      markerId: MarkerId(schedule.scheduleId.toString()),
      position: schedule.latLng,
      infoWindow: InfoWindow(
        title: schedule.title,
        onTap: () {}, // TODO: 정보 수정
      ),
    ))
        .toSet();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const TopSheet(),
        Expanded(
          child: GoogleMap(
            mapType: MapType.normal,
            onMapCreated: _onMapCreated,
            initialCameraPosition: CameraPosition(
              target: _center,
              zoom: 11.0,
            ),
            markers: getMarkers(),
          ),
        ),
        BottomWidget(
          datas: sampleData,
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
