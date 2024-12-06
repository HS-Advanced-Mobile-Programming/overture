import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:overture/CheckListScreen/CheckListScreen.dart';
import 'package:overture/HomeScreen/HomeScreenBody.dart';
import 'package:overture/MapScreen/MapScreen.dart';
import 'package:overture/MenuTranslationScreen/MenuTranslationScreen.dart';
import 'package:overture/ProfileScreen/SettingScreen.dart';
import 'package:overture/ScheduleScreen.dart';
import 'package:overture/TravelScreen.dart';

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