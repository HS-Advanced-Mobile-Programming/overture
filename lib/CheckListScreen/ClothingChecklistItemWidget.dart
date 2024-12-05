import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../models/check_model_files/clothes_model.dart';

class ClothesCheckListItem extends StatefulWidget{
  final String id;
  final String itemName;
  final String description;
  final int quantity;
  bool checked;
  final Function(String newItem) onItemDelete;

  ClothesCheckListItem({
    required this.id,
    required this.itemName,
    required this.description,
    required this.quantity,
    required this.onItemDelete,
    required this.checked,
    Key? key
  }) : super(key: key);

  @override
  State<ClothesCheckListItem> createState() => _ClothesCheckListItemState();
}

class _ClothesCheckListItemState extends State<ClothesCheckListItem> {
  ClothesCheckListModel CCLM = ClothesCheckListModel();

  @override
  Widget build(BuildContext context) {

    Widget target = ExpansionTile(
      title: Row(
        children: [
          Checkbox(value: widget.checked, onChanged: (value){
            setState(() {
              widget.checked = value ?? false;
              CCLM.updateChecked(widget.id);
            });
          }),
          Text("${widget.itemName}", style: TextStyle(fontWeight: FontWeight.w800)),
          Spacer(),
          Text("${widget.quantity}개"),
        ],
      ),
      backgroundColor: Colors.white,
      children: [
        Padding(
          padding: EdgeInsets.only(right: 32, left: 32, bottom: 16),
          child: Row(children: [Text(widget.description), ]) // CheckList Item 설명 부분
        ),
      ],
    );

    return GestureDetector(
      onLongPress: () => widget.onItemDelete(widget.id), // 수정된 부분
      child: target,
    );
  }
}