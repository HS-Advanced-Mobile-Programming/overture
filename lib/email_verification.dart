import 'package:flutter/material.dart';
import 'email_signup.dart';

class EmailVerificationScreen extends StatefulWidget {
  const EmailVerificationScreen({super.key});

  @override
  State<EmailVerificationScreen> createState() => _EmailVerificationScreenState();
}

class _EmailVerificationScreenState extends State<EmailVerificationScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController codeController = TextEditingController();
  int countdown = 300; // 5분 타이머 (초 단위)
  bool isCodeSent = false;

  @override
  void dispose() {
    emailController.dispose();
    codeController.dispose();
    super.dispose();
  }

  void startCountdown() {
    setState(() => isCodeSent = true);
    Future.delayed(const Duration(seconds: 1), () {
      if (countdown > 0) {
        setState(() => countdown--);
        startCountdown();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("이메일 인증")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: emailController,
              decoration: const InputDecoration(
                labelText: "이메일 주소",
                suffixIcon: Icon(Icons.email),
              ),
            ),
            const SizedBox(height: 20),
            if (isCodeSent)
              TextField(
                controller: codeController,
                decoration: InputDecoration(
                  labelText: "인증코드",
                  suffixText: "${(countdown ~/ 60)}:${countdown % 60}",
                ),
              ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (!isCodeSent) startCountdown();
              },
              child: const Text("이메일 인증"),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const EmailSignupScreen()),
                );
              },
              child: const Text("다음"),
            ),
          ],
        ),
      ),
    );
  }
}
