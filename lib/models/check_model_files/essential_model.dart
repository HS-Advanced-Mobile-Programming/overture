

import 'package:flutter/cupertino.dart';

class EssentialContent {
  String itemName;
  String description;
  bool isChecked = false;

  EssentialContent({
    required this.itemName,
    required this.description
  });
}

class EssentialCheckListModel extends ChangeNotifier {
  List<EssentialContent> _essentialCheckList = [
      EssentialContent(itemName: "여권",description:  "해외여행 시 반드시 필요한 신분증명서입니다. 출입국 심사와 국제선 항공편 이용에 필수입니다."),
    EssentialContent(itemName: "비자발급",description:  "프랑스 여행 시 단기체류 (90일 이하)의 경우 무비자 입국 가능 장기체류 의 경우 별도의 비자신청이 필요합니다."),
    EssentialContent(itemName: "여행자 보험",description:  "여행 중 발생할 수 있는 예기치 않은 상황(질병, 사고, 짐 분실 등)에 대비하기 위해 꼭 필요한 안전장치입니다."),
    EssentialContent(itemName: "환전",description:  "여행 중 원활한 현지 결제를 위해 반드시 필요한 준비입니다. 카드 사용이 제한되거나 소액 결제가 필요한 상황에 대비할 수 있습니다."),

  ];

  List<EssentialContent> get essentialCheckList => _essentialCheckList;

}