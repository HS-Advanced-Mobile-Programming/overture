import 'package:flutter/cupertino.dart';

class ClothesContent {
  final String id;
  String itemName;
  String description;
  int quantity;
  bool isChecked = false;

  ClothesContent({
    required this.id,
    required this.itemName,
    required this.description,
    required this.quantity,
    required this.isChecked
  });
}

class ClothesCheckListModel extends ChangeNotifier{
  List<ClothesContent> _clothesCheckList = [];

  List<ClothesContent> get clothesCheckList => _clothesCheckList;

  void addClothe(ClothesContent newClothe){
    this._clothesCheckList.add(newClothe);
    notifyListeners();
  }

  void deleteClothes(String id){
    this._clothesCheckList.removeWhere((item)=>item.id == id);
    notifyListeners();
  }
}