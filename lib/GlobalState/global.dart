library global;

import 'package:flutter/cupertino.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../models/schedule_model_files/schedule_model.dart';
import '../service/FirestoreScheduleService.dart';
import '../service/ScheduleDto.dart';

// Schedule 리스트
// List<ScheduleAndMarker> globalSchedules = [
//   Schedule(id: "1", title: "출국", content: "인천공항에서 출국 준비", time: "2024-12-06 01:00:00", place: "인천공항", x: "37.63695556", y: "127.0277194"),
//   Schedule(id: "2", title: "호텔 체크인", content: "예약한 호텔에 체크인", time: "2024-12-06 03:00:00", place: "강남 호텔", x: "37.68695556", y: "127.0277194"),
//   Schedule(id: "3", title: "한성대 방문", content: "한성대학교에 방문했습니다.", time: "2024-12-06 06:00:00", place: "한성대학교", x: "37.5828", y: "127.0106"),
//   Schedule(id: "4", title: "신라 호텔 레스토랑 방문", content: "서울 시내 레스토랑에 식사", time: "2024-12-06 15:00:00", place: "서울 신라 호텔 레스토랑", x: "37.5642135", y: "127.0016985"),
//   Schedule(id: "5", title: "기상", content: "호텔에서 기상 후 아침 식사", time: "2024-12-07 01:00:00", place: "강남 호텔", x: "37.78695556", y: "127.0777194"),
//   Schedule(id: "6", title: "셰르파 미팅", content: "셰르파와 미팅 및 등산 준비", time: "2024-12-07 03:00:00", place: "셰르파 사무소", x: "37.83695556", y: "127.0777194"),
//   Schedule(id: "7", title: "에베레스트 산 등산", content: "에베레스트 산 등반 시작", time: "2024-12-07 06:00:00", place: "에베레스트 베이스캠프", x: "37.88695556", y: "127.0777194"),
//   Schedule(id: "8", title: "쇼핑하기", content: "기념품 쇼핑 및 여유 시간", time: "2024-12-08 01:00:00", place: "강남 쇼핑몰", x: "37.93695556", y: "127.1277194"),
//   Schedule(id: "9", title: "호텔 체크 아웃", content: "호텔 체크 아웃 및 정리", time: "2024-12-08 03:00:00", place: "강남 호텔", x: "37.98695556", y: "127.1277194"),
//   Schedule(id: "10", title: "귀국", content: "인천공항으로 이동 후 귀국", time: "2024-12-08 06:00:00", place: "인천공항", x: "38.03695556", y: "127.1277194"),
// ];
List<ScheduleAndMarker> globalSchedules = [];

// 전역 상태 관리 변수
ValueNotifier<String?> innerPlace = ValueNotifier<String?>(null);


const List<String> colors = [
  "asset/img/marker/red/",
  "asset/img/marker/green/",
  "asset/img/marker/purple/",
];

Future<void> loadSchedules() async {
  // Schedule 초기화
  List<ScheduleDto> scheduleDtos = await FirestoreScheduleService().getAllSchedules();

  // BitmapDescriptor 아이콘을 로드하여 customIcons 리스트에 추가
  int count = 1;
  int colorCount = 0;
  List<BitmapDescriptor> icons = [];

  scheduleDtos.sort((a, b) => a.time.compareTo(b.time));

  for (int i = 0; i < scheduleDtos.length; i++) {
    if (i > 0 && Schedule.dateTime(scheduleDtos[i].time).day != Schedule.dateTime(scheduleDtos[i - 1].time).day) {
      count = 1; // 날짜가 바뀌면 count 초기화
      colorCount = (colorCount + 1) % colors.length; // colorCount를 colors 길이로 순환
    }

    var icon = await BitmapDescriptor.fromAssetImage(
      const ImageConfiguration(size: Size(25, 25)),
      '${colors[colorCount]}marker$count.png',
    );

    icons.add(icon);
    count++;
  }

  int index = 0;
  globalSchedules = scheduleDtos.map((dto) => ScheduleDto.toScheduleAndMarker(dto, icons[index++])).toList();
}


LatLng myPos = LatLng(0,0);