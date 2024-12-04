import 'package:flutter/material.dart';

class EmailSignupScreen extends StatelessWidget {
  const EmailSignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("회원가입")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              decoration: const InputDecoration(labelText: "닉네임"),
            ),
            const SizedBox(height: 20),
            TextField(
              obscureText: true,
              decoration: const InputDecoration(labelText: "비밀번호"),
            ),
            const SizedBox(height: 20),
            TextField(
              obscureText: true,
              decoration: const InputDecoration(labelText: "비밀번호 확인"),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {},
              child: const Text("회원가입"),
            ),
          ],
        ),
      ),
    );
  }
}
