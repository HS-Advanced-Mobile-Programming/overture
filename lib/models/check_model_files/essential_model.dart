

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
    EssentialContent(itemName: "비자발급",description:  "프랑스 여행 시 단기체류(90일 이하)의 경우 무비자 입국 가능 장기체류의 경우 별도의 비자신청이 필요합니다."),

  ];

  List<EssentialContent> get essentialCheckList => _essentialCheckList;




}