import 'package:flutter/material.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          '개인정보 처리방침',
          style: TextStyle(color: Colors.black),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
        elevation: 0,
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: RichText(
          text: const TextSpan(
            style: TextStyle(fontSize: 14.0, height: 1.5, color: Colors.black),
            children: [
              TextSpan(
                text: '1. 개인정보 처리방침\n',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              TextSpan(
                text:
                '“개인정보 처리방침”이란 이용자가 안심하고 서비스를 이용할 수 있도록 회사가 준수해야 할 지침을 의미하며, 회사는 개인정보처리자가 준수하여야 하는 대한민국의 관계 법령 및 개인정보보호 규정, 가이드라인을 준수하여 개인정보 처리방침을 제공합니다.\n\n',
              ),
              TextSpan(
                text: '2. 개인정보 수집\n',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              TextSpan(
                text:
                '서비스 제공을 위해 필요한 최소한의 개인정보를 수집합니다. 회원 가입 시 또는 서비스 이용 과정에서 홈페이지 또는 애플리케이션, 프로그램 등을 통해 서비스 제공을 위해 필요한 최소한의 개인정보를 수집하고 있습니다.\n\n',
              ),
              TextSpan(
                text: '필수 항목:\n',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              TextSpan(
                text:
                '- 이름, 이메일, 연락처, 계정 비밀번호\n- 서비스 이용 내역, 접속 로그, IP 주소\n\n',
              ),
              TextSpan(
                text: '선택 항목:\n',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              TextSpan(
                text:
                '- 생년월일, 성별, 위치 정보, 마케팅 활용 동의 여부\n\n',
              ),
              TextSpan(
                text: '3. 개인정보 수집 방법\n',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              TextSpan(
                text:
                '회사는 다음과 같은 방법으로 개인정보를 수집합니다:\n- 회원 가입 시 사용자가 직접 입력한 정보\n- 서비스 이용 과정에서 자동으로 생성되는 로그 데이터\n- 고객센터 문의를 통해 제공된 정보\n\n',
              ),
              TextSpan(
                text: '4. 개인정보 이용 목적\n',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              TextSpan(
                text:
                '회사는 수집된 개인정보를 다음과 같은 목적으로 사용합니다:\n- 서비스 제공 및 계약 이행\n- 회원 관리 및 본인 인증\n- 고객 문의 응대 및 문제 해결\n- 서비스 개선 및 통계 분석\n\n',
              ),
              TextSpan(
                text: '5. 개인정보 보관 및 파기\n',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              TextSpan(
                text:
                '- 개인정보는 수집 및 이용 목적이 달성되면 지체 없이 파기합니다.\n- 전자적 파일은 복원이 불가능한 방식으로 삭제하며, 종이 문서는 분쇄하거나 소각합니다.\n\n',
              ),
              TextSpan(
                text: '6. 개인정보 제3자 제공\n',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              TextSpan(
                text:
                '회사는 법적 의무가 없는 한 이용자의 개인정보를 제3자에게 제공하지 않습니다. 단, 아래의 경우에 한해 제공될 수 있습니다:\n- 이용자의 동의가 있는 경우\n- 법적 요구사항에 따라 필요한 경우\n\n',
              ),
              TextSpan(
                text: '7. 개인정보 안전성 확보 조치\n',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              TextSpan(
                text:
                '회사는 개인정보의 안전성을 보장하기 위해 다음과 같은 조치를 시행합니다:\n- 개인정보 암호화 및 접근 권한 제한\n- 정기적인 보안 점검\n- 개인정보 유출 사고 대응 매뉴얼 구축\n\n',
              ),
              TextSpan(
                text: '8. 이용자의 권리\n',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              TextSpan(
                text:
                '이용자는 다음과 같은 권리를 행사할 수 있습니다:\n- 개인정보 열람, 정정, 삭제 요청\n- 개인정보 처리 정지 요청\n- 동의 철회 요청\n요청은 고객센터를 통해 접수되며, 법적 요건에 따라 처리됩니다.\n\n',
              ),
              TextSpan(
                text: '9. 개인정보 처리방침 변경\n',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              TextSpan(
                text:
                '회사는 개인정보 처리방침을 변경할 수 있으며, 변경 내용은 서비스 내 공지사항을 통해 사전에 안내합니다.\n\n',
              ),
              TextSpan(
                text: '10. 문의사항\n',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              TextSpan(
                text:
                '개인정보와 관련된 문의는 아래 연락처를 통해 접수할 수 있습니다:\n- 이메일: privacy@example.com\n- 전화: 1234-5678\n\n',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
