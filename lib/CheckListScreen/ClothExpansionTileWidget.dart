import 'package:counter_button/counter_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'ClothingChecklistItemWidget.dart';

class ClothingExpansionTile extends StatefulWidget {
  final List<Widget> clothingList;
  final Function(ClothesCheckListItem newItem) onItemAdded;
  final Function(String targetid) onItemDelete; //TODO 삭제 안됨

  ClothingExpansionTile({required this.clothingList, required this.onItemAdded, required this.onItemDelete});

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
        Column(children: widget.clothingList),
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
                                              ClothesCheckListItem newItem = ClothesCheckListItem(
                                                  id: "${++size}",
                                                  itemName: _newClothesItemName.text,
                                                  description: _newCLothesItemdescription.text,
                                                  quantity: _newCounterValue,
                                                  onItemDelete: widget.onItemDelete,
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
