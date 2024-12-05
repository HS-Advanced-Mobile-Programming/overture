import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:json_annotation/json_annotation.dart';

part 'clothes_model.g.dart';

@JsonSerializable()
class ClothesContent {
  String clotheId;
  String itemName;
  String description;
  int quantity;
  bool isChecked = false;

  ClothesContent({
    required this.clotheId,
    required this.itemName,
    required this.description,
    required this.quantity,
    required this.isChecked
  });

  factory ClothesContent.fromJson(Map<String, dynamic> json)=>
      _$ClothesContentFromJson(json);

  Map<String, dynamic> toJson() => _$ClothesContentToJson(this);

}

class ClothesCheckListModel extends ChangeNotifier{
  List<ClothesContent> _clothesCheckList = [];
  final CollectionReference _collectionRef = FirebaseFirestore.instance.collection('clothechecklists');

  List<ClothesContent> get clothesCheckList => _clothesCheckList;

  void addClothe(ClothesContent newClothe) async {
    DocumentReference docRef = await _collectionRef.add(newClothe.toJson());

    await docRef.update({"clotheId": docRef.id});
    newClothe.clotheId = docRef.id;

    this._clothesCheckList.add(newClothe);
    notifyListeners();
  }

  Future<List<ClothesContent>> getAllClothes() async {

    QuerySnapshot querySnapshot = await _collectionRef.get();

    List<ClothesContent> fetchedClothes =  querySnapshot.docs.map((doc) =>
        ClothesContent.fromJson(doc.data() as Map<String, dynamic>)
    ).toList();

    if(fetchedClothes.isNotEmpty){
      this._clothesCheckList = [];
      fetchedClothes.forEach((item) => this._clothesCheckList.add(item));
    }

    notifyListeners();

    return fetchedClothes;

  }

  void deleteClothes(String id) async {

    await _collectionRef.doc(id).delete();

    this._clothesCheckList.removeWhere((item)=>item.clotheId == id);
    notifyListeners();
  }

  void updateChecked(String id) async {
    DocumentSnapshot docSnapshot = await _collectionRef.doc(id).get();

      ClothesContent fetched = ClothesContent.fromJson(
          docSnapshot.data() as Map<String, dynamic>);

      fetched.isChecked = !fetched.isChecked;

      await _collectionRef.doc(id).update(fetched.toJson());
  }
}