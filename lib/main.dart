import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
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
import 'package:overture/models/schedule_model_files/schedule_model.dart';
import 'package:provider/provider.dart';

import 'MenuTranslationScreen/MenuTranslationScreen.dart';

//TODO main icon 움직이게

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
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

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
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