import 'package:flutter/material.dart';
import 'package:overture/ProfileScreen/AccountSettingScreen.dart';
import 'package:overture/ProfileScreen/PrivacyPolicyScreen.dart';
import 'package:overture/ProfileScreen/TermScreen.dart';
import 'package:overture/SearchScreen/SearchScreen.dart';
// import 'package:url_launcher/url_launcher.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});
  @override
  _SettingScreenState createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  bool isTravelNotificationOn = true;
  bool isAppPushNotificationOn = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text('설정'),
      ),
      backgroundColor: Colors.white,
      body: ListView(
        children: [
          const SectionTitle(title: "개인정보"),
          ListTile(
            title: const Text("계정 설정"),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AccountSettingScreen(),
                ),
              );
            },
          ),
          const SectionTitle(title: "고객지원"),
          const ListTile(
            title: Text("버전정보"),
            trailing: Text("v1.0", style: TextStyle(
              fontSize: 16.0,
              color: Colors.black,
            ),),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Divider(
              color: Colors.grey,
              thickness: 1.0,
            ),
          ),
          ListTile(
            title: const Text("이메일 문의하기"),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: (){
              Navigator.push(context,
                MaterialPageRoute(
                  builder: (context) => const PlaceSearchScreen(),
                )
              );
            },
          ),
          const SectionTitle(title: "이용 약관"),
          ListTile(
            title: const Text("서비스 약관 보기"),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const TermsScreen(),
                ),
              );
            },
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0), // 양쪽에 패딩 추가
            child: Divider(
              color: Colors.grey, // Divider 색상
              thickness: 1.0, // Divider 두께
            ),
          ),
          ListTile(
            title: const Text("개인정보 처리방침"),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const PrivacyPolicyScreen(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class SectionTitle extends StatelessWidget {
  final String title;

  const SectionTitle({required this.title, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      color: const Color(0xFFF0F4F6),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 16.0,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
      )
    );
  }
}