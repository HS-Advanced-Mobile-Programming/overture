import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:overture/CheckListScreen/CheckListScreen.dart';
import 'package:overture/HomeScreen/HomeScreenBody.dart';
import 'package:overture/MapScreen/MapScreen.dart';
import 'package:overture/ProfileScreen/SettingScreen.dart';
import 'package:overture/ScheduleScreen.dart';
import 'package:overture/TravelScreen.dart';
import 'package:overture/auth/login_screen.dart';
import 'package:overture/auth/signup_screen.dart';
import 'package:overture/home_screen.dart';
import 'package:overture/auth/auth_screen.dart';
import 'package:overture/models/place_model_files/place_model.dart';
import 'package:overture/models/schedule_model_files/schedule_model.dart';
import 'package:provider/provider.dart';

import 'ExplainButton/ExplainButton.dart';
import 'GlobalState/global.dart';
import 'HomeScreen/HomeScreen.dart';
import 'MapScreen/entity/entity.dart';

//TODO main icon 움직이게

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Hive.openBox('placesBox');
  await Firebase.initializeApp();
  await dotenv.load(fileName: ".env");
  await initializeDateFormatting('ko_KR', null); // 로케일 데이터 초기화
  Hive.registerAdapter(PlaceAdapter());
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

        var today = DateTime.now();

        schedules.forEach((schedule) {
          // 스케줄 날짜만 추출
          final scheduleDate = DateTime(schedule.time.year, schedule.time.month, schedule.time.day);

          // 날짜 비교
          if (scheduleDate.year == today.year
              && scheduleDate.month == today.month
              && scheduleDate.day == today.day
              && calculateDistance(schedule.latLng, myPos) <= 5
          ) {
              innerPlace.value = schedule.place;
          }
        });
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
      initialRoute: '/',
      routes: {
        '/home': (context) => const HomeScreen(),
        '/signup': (context) => SignUpScreen(),
        '/login': (context) => LoginScreen(),
        '/': (context) => MainScreen()
      },
    );
  }
}

Future<void> initializeDefault() async {
  FirebaseApp app = await Firebase.initializeApp();
  print('Initialized default app $app');
}

class NoCheckCertificateHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}