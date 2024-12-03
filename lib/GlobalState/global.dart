library global;

import 'package:flutter/cupertino.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../MapScreen/entity/entity.dart';

// Schedule 리스트
List<Schedule> schedules = [
  Schedule(id: 1, title: "출국", content: "인천공항에서 출국 준비", time: DateTime.parse("2024-12-01 01:00:00"), place: "인천공항", latLng: LatLng(37.63695556, 127.0277194),),
  Schedule(id: 2, title: "호텔 체크인", content: "예약한 호텔에 체크인", time: DateTime.parse("2024-12-01 03:00:00"), place: "강남 호텔", latLng: LatLng(37.68695556, 127.0277194),),
  Schedule(id: 3, title: "파이브가이즈에서 식사", content: "파이브가이즈에서 저녁 식사", time: DateTime.parse("2024-12-01 06:00:00"), place: "강남역 파이브가이즈", latLng: LatLng(37.73695556, 127.0277194),),
  Schedule(id: 4, title: "기상", content: "호텔에서 기상 후 아침 식사", time: DateTime.parse("2024-12-02 01:00:00"), place: "강남 호텔", latLng: LatLng(37.78695556, 127.0777194),),
  Schedule(id: 5, title: "셰르파 미팅", content: "셰르파와 미팅 및 등산 준비", time: DateTime.parse("2024-12-02 03:00:00"), place: "셰르파 사무소", latLng: LatLng(37.83695556, 127.0777194),),
  Schedule(id: 6, title: "에베레스트 산 등산", content: "에베레스트 산 등반 시작", time: DateTime.parse("2024-12-02 06:00:00"), place: "에베레스트 베이스캠프", latLng: LatLng(37.88695556, 127.0777194),),
  Schedule(id: 7, title: "쇼핑하기", content: "기념품 쇼핑 및 여유 시간", time: DateTime.parse("2024-12-03 01:00:00"), place: "강남 쇼핑몰", latLng: LatLng(37.93695556, 127.1277194),),
  Schedule(id: 8, title: "호텔 체크 아웃", content: "호텔 체크 아웃 및 정리", time: DateTime.parse("2024-12-03 03:00:00"), place: "강남 호텔", latLng: LatLng(37.98695556, 127.1277194),),
  Schedule(id: 9, title: "귀국", content: "인천공항으로 이동 후 귀국", time: DateTime.parse("2024-12-03 06:00:00"), place: "인천공항", latLng: LatLng(38.03695556, 127.1277194),),
];


// 전역 상태 관리 변수
ValueNotifier<String?> innerPlace = ValueNotifier<String?>(null);

LatLng myPos = LatLng(0,0);