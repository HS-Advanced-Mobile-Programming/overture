import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:overture/models/schedule_model_files/schedule_model.dart';
import 'package:provider/provider.dart';

import 'ExplainButton/ExplainButton.dart';
import 'GlobalState/global.dart';
import 'HomeScreen/HomeScreen.dart';

//TODO main icon 움직이게

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await initializeDateFormatting('ko_KR', null); // 로케일 데이터 초기화
  HttpOverrides.global = NoCheckCertificateHttpOverrides();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ScheduleModel()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<StatefulWidget> createState() => _MyApp();
}

class _MyApp extends State<MyApp> {
  FlutterTts tts = FlutterTts();

  @override
  void initState() {
    super.initState();
    _initializeLocation(); // 위치 초기화
  }

  Future<void> _initializeLocation() async {
    // 위치 권한 요청
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.whileInUse ||
        permission == LocationPermission.always) {
      // 실시간 위치 스트림 구독
      Geolocator.getPositionStream(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          distanceFilter: 10, // 최소 10미터 이동 시 업데이트
        ),
      ).listen((Position position) {
        myPos = LatLng(position.latitude, position.longitude); // 위치 업데이트
        print("현재 위치: $myPos");
      });
    } else {
      print("위치 권한이 필요합니다.");
    }
  }

  @override
  Widget build(BuildContext context) {
    tts.setLanguage('ko-KR');
    tts.setSpeechRate(0.4);

    return MaterialApp(
      home: //HomeScreen(),
      Stack(
          children: [
            const HomeScreen(),
            ExplainButton(tts: tts),
          ]
      )
    );
  }
}

class NoCheckCertificateHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}