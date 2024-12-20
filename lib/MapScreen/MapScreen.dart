import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import '../GlobalState/global.dart';
import 'package:intl/intl.dart';
import 'package:overture/service/FirestoreScheduleService.dart';
import 'package:overture/service/ScheduleDto.dart';
import 'package:overture/widgets/schedule_edit_form.dart';
import 'package:provider/provider.dart';
import 'package:overture/models/schedule_model_files/schedule_model.dart'
    as OtherSchedule;
import '../SearchScreen/PlaceDetailsModal.dart';
import '../SearchScreen/SearchScreen.dart';
import '../models/schedule_model_files/schedule_model.dart';
import '../service/FirestoreScheduleService.dart';
import '../service/ScheduleDto.dart';
import 'TopWidget.dart';
import 'BottomWidget.dart';
import 'entity/entity.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  bool _isLoading = true;

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
    _initializeMap();
  }

  Future<void> _initializeMap() async {
    setState(() {
      _isLoading = true;
    });

    await loadSchedules(); // 마커 데이터 및 아이콘 로드

    setState(() {
      _isLoading = false;
    });
  }

  Set<Marker> getMarkers() {
    final filteredSchedules = selectedDate == null
        ? globalSchedules
        : globalSchedules.where((schedule) {
      var scheduleTime = Schedule.dateTime(schedule.time);
      return scheduleTime.year == selectedDate!.year &&
          scheduleTime.month == selectedDate!.month &&
          scheduleTime.day == selectedDate!.day;
    }).toList();

    return filteredSchedules.asMap().entries.map((entry) {
      final index = entry.key;
      final schedule = entry.value;

      return Marker(
        markerId: MarkerId(schedule.id.toString()),
        position: LatLng(double.parse(schedule.x!), double.parse(schedule.y!)),
        icon: schedule.icon,
        infoWindow: InfoWindow(
          title: schedule.title,
          onTap: () {
            final formattedSchedule = OtherSchedule.Schedule(
                id: schedule.id.toString(),
                title: schedule.title,
                content: '',
                time: schedule.time,
                place: '장소를 입력하세요' // [HS-JNYLee]: schedule에 place 속성 없어서 빈 값 정의
            );
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              backgroundColor: Colors.transparent,
              builder: (BuildContext context) {
                return SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(height: 50, color: Colors.transparent),
                      Padding(
                        padding: EdgeInsets.only(
                          bottom: MediaQuery.of(context)
                              .viewInsets
                              .bottom, // 키보드 높이만큼 패딩 추가
                        ),
                        child: ScheduleEditForm(
                          selectedDate: Schedule.dateTime(schedule.time),
                          schedule: formattedSchedule,
                          onSubmit: (newSchedule) {
                            final scheduleModel =
                            Provider.of<OtherSchedule.ScheduleModel>(
                                context,
                                listen: false);
                            _controller.hideMarkerInfoWindow(MarkerId(schedule.id.toString()));
                            final indexS = globalSchedules.indexWhere((schedule) =>
                            schedule.id.toString() ==
                                newSchedule.id);
                            if (indexS != -1) {
                              setState(() {
                                globalSchedules[indexS]
                                = ScheduleAndMarker(
                                    id: newSchedule.id,
                                    title: newSchedule.title,
                                    time: newSchedule.time,
                                    x: globalSchedules[indexS].x,
                                    y: globalSchedules[indexS].y,
                                    icon: globalSchedules[indexS].icon,
                                    content: newSchedule.content,
                                    place: newSchedule.place
                                ); // 새로운 객체로 교체
                              });
                            }
                            FirestoreScheduleService().updateSchedule(
                                newSchedule.id,
                                ScheduleDto.toScheduleDto(
                                    newSchedule, '1'));
                            scheduleModel.editSchedule(newSchedule);
                            Navigator.pop(context);
                          },
                          onDelete: (newSchedule) {
                            setState(() {
                              globalSchedules.removeWhere((schedule) =>
                              schedule.id.toString() ==
                                  newSchedule.id);
                              FirestoreScheduleService().deleteSchedule(newSchedule.id);
                            });
                            Navigator.pop(context);
                          },
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        ),
      );
    }).toSet();
  }

  void _onMapCreated(GoogleMapController controller) {
    _controller = controller;
  }

  Future<void> _getCurrentLocation() async {
    final cameraPosition = CameraPosition(
      target: myPos,
      zoom: 11,
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
          zoom: 11,
        ),
      ),
    );
    _fetchReviewsAndDetails(_place!.placeId);
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? Center(child: CircularProgressIndicator()) // 로딩 중
        : Column(
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
                  elevation: 8,
                  child: Icon(Icons.my_location),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                ),
              ),
            ],
          ),
        ),
        BottomWidget(
          datas: globalSchedules,
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
