import 'package:counter_button/counter_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../models/check_model_files/clothes_model.dart';

class ClothesCheckListItem extends StatefulWidget {
  String id;
  String itemName;
  String description;
  int quantity;
  bool checked;
  final Function(String newItem) onItemDelete;
  final Function(ClothesContent tmp) onDeleteItemCancel;

  ClothesCheckListItem({
    required this.id,
    required this.itemName,
    required this.description,
    required this.quantity,
    required this.onItemDelete,
    required this.checked,
    required this.onDeleteItemCancel,
    Key? key,
  }) : super(key: key);

  @override
  State<ClothesCheckListItem> createState() => _ClothesCheckListItemState();
}

class _ClothesCheckListItemState extends State<ClothesCheckListItem> {
  ClothesCheckListModel CCLM = ClothesCheckListModel();

  @override
  void initState() {
    super.initState();
  }

  void showEditDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("옵션 선택"),
          content: Text("수정 또는 삭제를 선택하세요."),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                showEditDialog();
              },
              child: Text("수정"),
            ),
            TextButton(
              onPressed: () {
                // 삭제 동작 실행
                widget.onItemDelete(widget.id);

                ClothesContent tmp = ClothesContent(
                  clotheId : widget.id,
                  itemName : widget.itemName,
                  description : widget.description,
                  quantity: widget.quantity,
                  isChecked : widget.checked
                );

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('삭제되었습니다.'),
                    duration: Duration(seconds: 2),
                    action: SnackBarAction(
                      label: '취소',
                      onPressed: () {
                        CCLM.addClothe(tmp);
                        widget.onDeleteItemCancel(tmp);
                      },
                    ),
                  ),
                );

                Navigator.pop(context);
              },
              child: Text("삭제"),
            ),
          ],
        );
      },
    );
  }

  void showEditDialog() {
    TextEditingController nameController = TextEditingController(text: widget.itemName);
    TextEditingController descriptionController = TextEditingController(text: widget.description);
    int newQuantity = widget.quantity;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setStateDialog) {
            return AlertDialog(
              title: Text("아이템 수정"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: nameController,
                    decoration: InputDecoration(labelText: "아이템 이름"),
                  ),
                  TextField(
                    controller: descriptionController,
                    decoration: InputDecoration(labelText: "설명"),
                  ),
                  Row(
                    children: [
                      Text("수량: "),
                      Spacer(),
                      CounterButton(
                        count: newQuantity,
                        onChange: (value) {
                          if (value < 1) return;
                          setStateDialog(() {
                            newQuantity = value;
                          });
                        },
                        loading: false,
                        countColor: Colors.blue,
                        buttonColor: Colors.blue,
                      ),
                    ],
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    CCLM.updateClothe(
                      ClothesContent(
                        clotheId: widget.id,
                        itemName: nameController.text,
                        description: descriptionController.text,
                        quantity: newQuantity,
                        isChecked: widget.checked,
                      ),
                    );
                    setState(() {
                      widget.itemName = nameController.text;
                      widget.description = descriptionController.text;
                      widget.quantity = newQuantity;
                    });
                    Navigator.pop(context);
                  },
                  child: Text("저장"),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text("취소"),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget target = ExpansionTile(
      title: Row(
        children: [
          Checkbox(
            value: widget.checked,
            onChanged: (value) {
              setState(() {
                widget.checked = value ?? false;
                CCLM.updateChecked(widget.id);
              });
            },
          ),
          Text(
            "${widget.itemName}",
            style: TextStyle(fontWeight: FontWeight.w800),
          ),
          Spacer(),
          Text("${widget.quantity}개"),
        ],
      ),
      backgroundColor: Colors.white,
      children: [
        Padding(
          padding: EdgeInsets.only(right: 32, left: 32, bottom: 16),
          child: Row(children: [
            Text(widget.description),
          ]), // CheckList Item 설명 부분
        ),
      ],
    );

    return GestureDetector(
      onLongPress: () => showEditDeleteDialog(context),
      child: target,
    );
  }
}
