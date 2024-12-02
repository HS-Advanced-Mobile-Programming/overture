import 'package:flutter/material.dart';

class AccountSettingScreen extends StatefulWidget {
  const AccountSettingScreen({super.key});

  @override
  _AccountSettingScreenState createState() => _AccountSettingScreenState();
}

class _AccountSettingScreenState extends State<AccountSettingScreen> {
  String nickname = "jeongshanghwa";
  String avatar = "https://via.placeholder.com/150"; // 기본 프로필 이미지 URL

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          '계정 설정',
          style: TextStyle(color: Colors.black),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
        elevation: 0,
      ),
      backgroundColor: Colors.white,
      body: Column(
        children: [
          const SizedBox(height: 20),
          GestureDetector(
            onTap: () {
              // 사진 변경
              _changeAvatar();
            },
            child: CircleAvatar(
              radius: 50,
              backgroundImage: NetworkImage(avatar),
              child: const Icon(
                Icons.camera_alt,
                size: 32,
                color: Colors.white70,
              ),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            nickname,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          GestureDetector(
            onTap: () {
              // 닉네임 수정
              _editNickname();
            },
            child: const Text(
              '수정',
              style: TextStyle(
                fontSize: 14,
                color: Colors.blue,
              ),
            ),
          ),
          const SizedBox(height: 40),
          ListTile(
            title: const Text(
              "로그아웃",
              style: TextStyle(fontSize: 16),
            ),
            onTap: () {
              // 로그아웃 로직 추가 가능
            },
          ),
          const Divider(),
          ListTile(
            title: const Text(
              "회원탈퇴",
              style: TextStyle(fontSize: 16, color: Colors.red),
            ),
            onTap: () {
              // 회원탈퇴 모달 띄우기
              _showDeleteAccountModal();
            },
          ),
        ],
      ),
    );
  }

  void _changeAvatar() async {
    // 사진 변경 로직 (예: 이미지 선택기 활용)
    // 아래는 기본 구현
    setState(() {
      avatar = "https://via.placeholder.com/150/FF0000"; // 새로운 이미지 URL로 업데이트
    });
  }

  void _editNickname() {
    showDialog(
      context: context,
      builder: (context) {
        String tempNickname = nickname;
        String? errorText; // 오류 메시지

        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text("닉네임 수정"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    onChanged: (value) {
                      // 입력값 검증
                      if (!_isValidNickname(value)) {
                        setState(() {
                          errorText = "닉네임은 공백과 특수문자를 포함할 수 없으며, 첫 글자는 영어로 시작해야 합니다.";
                        });
                      } else {
                        setState(() {
                          errorText = null; // 오류 메시지 초기화
                        });
                      }
                      tempNickname = value;
                    },
                    decoration: InputDecoration(
                      hintText: "새 닉네임 입력",
                      errorText: errorText, // 오류 메시지 표시
                    ),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text("취소"),
                ),
                TextButton(
                  onPressed: () {
                    // 닉네임이 유효한 경우에만 저장
                    if (_isValidNickname(tempNickname)) {
                      setState(() {
                        nickname = tempNickname;
                      });
                      Navigator.pop(context);
                    }
                  },
                  child: const Text("확인"),
                ),
              ],
            );
          },
        );
      },
    );
  }

  bool _isValidNickname(String value) {
    // 첫 글자는 영어, 이후는 영어, 숫자, 한글 허용 (공백 및 특수문자 불가)
    final regex = RegExp(r'^[a-zA-Z][a-zA-Z0-9가-힣]*$');
    return regex.hasMatch(value);
  }

  void _showDeleteAccountModal() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("회원탈퇴"),
          content: const Text("정말로 회원탈퇴를 하시겠습니까?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("취소"),
            ),
            TextButton(
              onPressed: () {
                // 회원탈퇴 로직 추가 가능
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("회원탈퇴가 완료되었습니다.")),
                );
              },
              child: const Text(
                "탈퇴",
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }
}
