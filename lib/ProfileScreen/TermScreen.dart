import 'package:flutter/material.dart';

class TermsScreen extends StatelessWidget {
  const TermsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          '서비스 이용약관',
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
                text: '제 1 장 환영합니다!\n\n',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
              ),
              TextSpan(
                text:
                '제 1 조 (목적)\n본 약관은 회사가 제공하는 다양한 서비스를 이용함에 있어 회사와 회원 간의 권리, 의무 및 책임사항, 이용 조건과 절차를 명확히 규정함으로써 상호 신뢰를 바탕으로 한 서비스를 제공하는 데 그 목적이 있습니다.\n\n',
              ),
              TextSpan(
                text: '제 2 조 (약관의 효력 및 변경)\n\n',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
              ),
              TextSpan(
                text:
                '1. 본 약관은 서비스를 이용하고자 하는 모든 회원에게 그 효력을 미칩니다.\n'
                    '2. 회사는 관련 법령의 변경 또는 서비스 정책의 변경 등에 따라 본 약관을 변경할 수 있으며, 변경된 약관은 서비스 내 공지사항을 통해 사전 고지합니다.\n'
                    '3. 회원이 변경된 약관에 동의하지 않을 경우 서비스 이용을 중단하고 탈퇴할 수 있습니다. 변경된 약관에 대해 별도의 이의 제기가 없을 경우 동의한 것으로 간주됩니다.\n\n',
              ),
              TextSpan(
                text: '제 3 조 (약관의 준칙)\n\n',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
              ),
              TextSpan(
                text:
                '본 약관에서 명시되지 않은 사항은 관련 법령 및 상관례에 따릅니다.\n\n',
              ),
              TextSpan(
                text: '제 4 조 (회원의 의무)\n\n',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
              ),
              TextSpan(
                text:
                '1. 회원은 서비스 이용 시 관계 법령, 본 약관의 규정 및 회사가 공지한 이용 정책을 준수해야 합니다.\n'
                    '2. 회원은 타인의 권리나 명예를 침해하거나, 공공질서 및 미풍양속에 반하는 행위를 해서는 안 됩니다.\n'
                    '3. 회원은 자신의 계정 정보를 안전하게 관리할 책임이 있으며, 이를 타인에게 공유하거나 양도해서는 안 됩니다.\n\n',
              ),
              TextSpan(
                text: '제 5 조 (서비스 이용의 제한)\n\n',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
              ),
              TextSpan(
                text:
                '1. 회사는 다음과 같은 경우 서비스 이용을 제한하거나 중단할 수 있습니다:\n'
                    '- 회원이 본 약관을 위반한 경우\n'
                    '- 회원의 행위로 인해 서비스의 정상적인 운영이 방해되는 경우\n'
                    '- 법령 또는 정부 지침에 따라 서비스 제공이 불가능한 경우\n\n',
              ),
              TextSpan(
                text: '제 6 조 (책임의 제한)\n\n',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
              ),
              TextSpan(
                text:
                '1. 회사는 천재지변, 불가항력 등 회사의 합리적인 통제 범위를 벗어난 사유로 인해 서비스를 제공할 수 없는 경우 책임을 지지 않습니다.\n'
                    '2. 회사는 회원이 제공한 정보의 정확성 및 신뢰성에 대해 책임을 지지 않으며, 회원 간 또는 회원과 제3자 간 발생한 분쟁에 대해 개입하거나 책임을 지지 않습니다.\n\n',
              ),
              TextSpan(
                text: '제 7 조 (분쟁의 해결)\n\n',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
              ),
              TextSpan(
                text:
                '본 약관과 관련하여 회사와 회원 간에 발생한 분쟁에 대해서는 대한민국 법을 준거법으로 하며, 관할 법원은 회사의 본점 소재지를 관할하는 법원으로 합니다.\n',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
