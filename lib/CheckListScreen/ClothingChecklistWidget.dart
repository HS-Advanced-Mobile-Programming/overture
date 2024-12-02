import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ClothesCheckListItem extends StatefulWidget{
  final String itemName;
  final String description;
  final int quantity;
  // final Function(Widget newItem) onItemDelete; //TODO 삭제 안됨

  ClothesCheckListItem({
    required this.itemName,
    required this.description,
    required this.quantity,
    // required this.onItemDelete,
    Key? key
  }) : super(key: key);

  @override
  State<ClothesCheckListItem> createState() => _ClothesCheckListItemState();
}

class _ClothesCheckListItemState extends State<ClothesCheckListItem> {
  bool checked = false;

  @override
  Widget build(BuildContext context) {

    Widget target =  ExpansionTile(
      title: Row(
        children: [
          Checkbox(value: this.checked, onChanged: (value){
            setState(() {
              // TODO 여기서 파베로 요청
              this.checked = value ?? false;
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

    return target;
  }
}