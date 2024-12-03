library global;

import 'package:flutter/cupertino.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../MapScreen/entity/entity.dart';

// Schedule 리스트
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

// 전역 상태 관리 변수
ValueNotifier<Place?> innerPlace = ValueNotifier<Place?>(null);

LatLng myPos = LatLng(0,0);