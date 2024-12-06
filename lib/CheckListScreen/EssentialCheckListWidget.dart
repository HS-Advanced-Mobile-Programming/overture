import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class EssentialCheckListItem extends StatefulWidget {
  final String itemName;
  final String description;
  bool checked;

  EssentialCheckListItem({
    required this.itemName,
    required this.description,
    required this.checked,
    Key? key,
  }) : super(key: key);

  @override
  _EssentialCheckListItemState createState() => _EssentialCheckListItemState();
}

class _EssentialCheckListItemState extends State<EssentialCheckListItem> {

  // [참조] https://musubi-life.tistory.com/29
  // Tooltip을 띄우는 함수
  void showTooltip(GlobalKey key, String word, String definition) {
    final RenderBox renderBox = key.currentContext!.findRenderObject() as RenderBox;
    final position = renderBox.localToGlobal(Offset.zero); // 단어의 위치를 계산

    final overlay = Overlay.of(key.currentContext!);
    final entry = OverlayEntry(
      builder: (context) => Positioned(
        top: position.dy - 40, // 단어의 위쪽에 툴팁을 표시
        left: position.dx,
        child: Material(
          borderRadius: BorderRadius.all(Radius.circular(5)),
          color: Colors.amber,
          child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 100),
              child: Padding(
                padding: EdgeInsets.all(8), child: Text(
                '$word: \n$definition',
                style: TextStyle(color: Colors.black),
              ),
              )
          ),
        ),
      ),
    );
    overlay.insert(entry);

    // 일정 시간 후 Tooltip을 자동으로 제거
    Future.delayed(Duration(seconds: 2), () {
      entry.remove();
    });
  }

  @override
  Widget build(BuildContext context) {
    Map<String, String> clickableWords = {
      "무비자": "비자가 없음.",
      "단기체류": "객지에 가서 단기간 동안 머물러 있음.",
      "장기체류": "객지에 가서 장기간 동안 머물러 있음.",
    };

    List<Widget> wordWidgets = [];

    widget.description.split(' ').forEach((word) {
      if (clickableWords.keys.contains(word)) {
        final key = GlobalKey();

        wordWidgets.add(
          GestureDetector(
            key: key,
            onLongPress: () {
              // 롱 클릭 시 해당 단어 위치에 Tooltip을 표시
              showTooltip(key, word, clickableWords[word]!);
            },
            child: Text(
              '$word ',
              style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold, decoration: TextDecoration.underline),
            ),
          ),
        );
      } else {
        wordWidgets.add(
          Text('$word '),
        );
      }
    });

    return ExpansionTile(
      title: Row(
        children: [
          Checkbox(value: widget.checked, onChanged: (value){
            setState(() {
              // TODO 여기서 파베로 요청
              widget.checked = value ?? false;
            });
          }),
          Text("${widget.itemName}", style: TextStyle(fontWeight: FontWeight.w800)),
        ],
      ),
      backgroundColor: Colors.white,
      children: [
        Padding(
          padding: EdgeInsets.only(right: 16, left: 16, bottom: 16),
          child: Wrap(children: wordWidgets), // CheckList Item 설명 부분
        ),
      ],
    );
  }
}



