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
import 'package:overture/models/check_model_files/clothes_model.dart';
import 'package:overture/models/schedule_model_files/schedule_model.dart';
import 'package:provider/provider.dart';

import 'MenuTranslationScreen/MenuTranslationScreen.dart';

import 'firebase_options.dart';
import 'models/check_model_files/essential_model.dart';

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
        ChangeNotifierProvider(create: (_) => EssentialCheckListModel()),
        ChangeNotifierProvider(create: (_) => ClothesCheckListModel())
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: HomeScreen(),
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

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const HomeScreenBody(),
    const CheckListScreen(),
    ScheduleScreen(),
    const TravelScreen(),
    const SettingScreen(),
    const MapScreen()
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Overture', style: TextStyle(fontWeight: FontWeight.bold)),
        leading: Padding(
          padding: EdgeInsets.all(5.0),
          child: Image.asset('asset/img/appicon.png')
        ),
        actions: [IconButton(onPressed: (){Navigator.push(context, MaterialPageRoute(builder: (context) => ImagePickerScreen()));}, icon: Icon(Icons.camera_alt_outlined,size: 40))],
        backgroundColor: Color(0xFFF0F4F6)
      ),
      backgroundColor: Color(0xFFF0F4F6),
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: '홈',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.check),
            label: '체크 리스트',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: '내 일정',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.airplane_ticket),
            label: '나의 여행',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: '마이 페이지',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.map),
            label: '지도'
          )
        ],
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey,
        backgroundColor: Colors.white,
      ),
    );
  }
}