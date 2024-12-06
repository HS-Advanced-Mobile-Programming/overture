import 'package:counter_button/counter_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../models/check_model_files/clothes_model.dart';
import 'ClothingChecklistItemWidget.dart';

class ClothingExpansionTile extends StatefulWidget {
  final List<ClothesContent> clothingList;
  final Function(ClothesContent newItem) onItemAdded;
  final Function(String targetid) onItemDelete;

  ClothingExpansionTile({
    required this.clothingList,
    required this.onItemAdded,
    required this.onItemDelete
  });

  @override
  _ClothingExpansionTileState createState() => _ClothingExpansionTileState();
}

class _ClothingExpansionTileState extends State<ClothingExpansionTile> {
  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      collapsedBackgroundColor: Colors.white,
      backgroundColor: Colors.white,
      title: Text("👕 의류"),
      children: [
        Column( children: widget.clothingList.map((item) =>
            ClothesCheckListItem(
            id: item.clotheId,
            itemName: item.itemName,
            description: item.description,
            quantity: item.quantity,
            checked : item.isChecked,
            onItemDelete: widget.onItemDelete,
            onDeleteItemCancel : (ClothesContent tmp){
              setState(() {
                widget.clothingList.add(tmp);
              });
            }
          )).toList()),
        Padding(
          padding: EdgeInsets.only(right: 16, left: 16, bottom: 16),
          child: Row(
            children: [
              IconButton(
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    builder: (context) {
                      int _newCounterValue = 1;
                      TextEditingController _newClothesItemName = TextEditingController();
                      TextEditingController _newCLothesItemdescription = TextEditingController();

                      return StatefulBuilder(
                        builder: (context, setState) {
                          return SingleChildScrollView(
                            child: Padding(
                              padding: EdgeInsets.only(
                                bottom: MediaQuery.of(context).viewInsets.bottom,
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.all(24),
                                    child: Row(
                                      children: [
                                        Text("의류 품목 추가", style: TextStyle(fontSize: 25)),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(24),
                                    child: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Expanded(
                                              child: TextField(
                                                controller: _newClothesItemName,
                                                decoration: InputDecoration(
                                                  labelText: '물건 이름',
                                                  hintText: "예: 셔츠",
                                                ),
                                              ),
                                            ),
                                            SizedBox(width: 16),
                                            CounterButton(
                                              loading: false,
                                              onChange: (val) {
                                                if (val < 1) return;
                                                setState(() {
                                                  _newCounterValue = val;
                                                });
                                              },
                                              count: _newCounterValue,
                                              countColor: Colors.blue,
                                              buttonColor: Colors.blue,
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 16),
                                        TextField(
                                          minLines: 8,
                                          controller: _newCLothesItemdescription,
                                          decoration: InputDecoration(
                                            labelText: '내용',
                                            hintText: "예: 설명",
                                            alignLabelWithHint: true,
                                            border: OutlineInputBorder(),
                                          ),
                                          maxLines: null,
                                          keyboardType: TextInputType.multiline,
                                        ),
                                      ],
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Expanded(
                                        child: Container(
                                          color: Colors.black,
                                          child: TextButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: Text("취소", style: TextStyle(color: Colors.white)),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Container(
                                          color: Colors.blue,
                                          child: TextButton(
                                            onPressed: () {
                                              int size = widget.clothingList.length;
                                              ClothesContent newItem = ClothesContent(
                                                  clotheId: "${++size}",
                                                  itemName: _newClothesItemName.text,
                                                  description: _newCLothesItemdescription.text,
                                                  quantity: _newCounterValue,
                                                  isChecked: false
                                                );
                                              widget.onItemAdded(newItem);
                                              Navigator.pop(context);
                                            },
                                            child: Text("추가", style: TextStyle(color: Colors.white)),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    },
                  );
                },
                icon: Icon(Icons.add_box_outlined, color: Colors.blue),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 2),
                child: Text(
                  "추가하기",
                  style: TextStyle(fontWeight: FontWeight.w800, color: Colors.blue, fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
