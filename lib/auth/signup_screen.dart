import 'package:flutter/material.dart';
import 'package:overture/auth/auth_service.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final AuthService _authService = AuthService();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // 배경 흰색
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black), // 뒤로가기 아이콘 색상
        title: const Text(
          '회원가입',
          style: TextStyle(
            color: Colors.black, // 제목 색상
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 40),
            const Text(
              "회원가입을 시작합니다.",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              "이메일과 비밀번호를 입력해주세요.",
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 30),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: '이메일',
                labelStyle: const TextStyle(color: Colors.grey),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue, width: 2), // 강조 색상
                  borderRadius: BorderRadius.circular(10),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(
                labelText: '비밀번호',
                labelStyle: const TextStyle(color: Colors.grey),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue, width: 2), // 강조 색상
                  borderRadius: BorderRadius.circular(10),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              obscureText: true,
            ),
            const SizedBox(height: 40),
            Center(
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    final user = await _authService.signUpWithEmail(
                      _emailController.text,
                      _passwordController.text,
                    );
                    if (user != null) {
                      print('회원가입 성공: ${user.email}');
                      Navigator.pushReplacementNamed(context, '/home');
                    } else {
                      print('회원가입 실패');
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue, // 강조 색상
                    foregroundColor: Colors.white, // 텍스트 색상
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    '회원가입',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: GestureDetector(
                onTap: () {
                  Navigator.pop(context); // 이전 화면으로 이동
                },
                child: RichText(
                  text: const TextSpan(
                    children: [
                      TextSpan(
                        text: "이미 계정이 있으신가요? ", // 흰색 텍스트
                        style: TextStyle(
                          color: Colors.black, // 흰색
                          fontSize: 14,
                        ),
                      ),
                      TextSpan(
                        text: "로그인", // 강조된 파란색 텍스트
                        style: TextStyle(
                          color: Colors.blue, // 파란색
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }
}
