import 'package:flutter/material.dart';
import 'auth_service.dart';

class EmailLoginScreen extends StatefulWidget {
  @override
  _EmailLoginScreenState createState() => _EmailLoginScreenState();
}

class _EmailLoginScreenState extends State<EmailLoginScreen> {
  final AuthService _authService = AuthService();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('로그인')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: '이메일'),
              keyboardType: TextInputType.emailAddress,
            ),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: '비밀번호'),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                final user = await _authService.signInWithEmail(
                  _emailController.text,
                  _passwordController.text,
                );
                if (user != null) {
                  print('로그인 성공: ${user.email}');
                  Navigator.pushReplacementNamed(context, '/home');
                } else {
                  print('로그인 실패');
                }
              },
              child: Text('로그인'),
            ),
          ],
        ),
      ),
    );
  }
}
