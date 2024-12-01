import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:expandable_widgets/expandable_widgets.dart';

class CheckListScreen extends StatefulWidget {
  const CheckListScreen({super.key});

  @override
  State<CheckListScreen> createState() => _CheckListScreenState();
}

class _CheckListScreenState extends State<CheckListScreen> {

  //TODO DB에서 읽어옴 -> 데이터 없을 때도 출력 필요
  String _startDate = "2024.07.01";
  String _endDate = "2024.07.01";
  String _fromAirport = "KOREA/INC"; // 출발 나라와 공항 이름의 조합
  String _toAirport = "FRANCE/CDG"; // 도착 나라와 공항 이름의 조합

  String _totalDate = "3";

  String _airline = "대한항공"; //항공사
  String _flightName = "KE901"; //항공편
  String _terminalNum="T2"; // 터미널
  String _portNum = "253";// 탑승구
  String _boardingTime = "19:30"; // 탑승시간

  List<Widget> TravelEssentialsList = [
    _CheckListItem("비자발급","프랑스 여행 시 단기체류(90일 이하)의 경우 무비자 입국 가능 장기체류의 경우 별도의 비자신청이 필요합니다.")
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children:[
          Container(
            padding: EdgeInsets.all(16.0),
            color: Colors.white,
            child:Column(
              children: [
                Row( // 공유버튼 및 체크리스트 제목 부분
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("체크리스트", style: Theme.of(context).textTheme.headlineLarge?.copyWith(fontWeight: FontWeight.bold)),
                    IconButton(
                      onPressed: () {
                        //TODO 공유 화면
                      },
                      icon: Icon(Icons.share, color: Colors.blue, size: 32)
                    )
                  ]
                ),
                Row( // 여행일자 및 여행 총 시간 설명,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // 시작 일자, 출발 공항, 도착 일자, 도착 공항
                        TravelPeriod(_startDate, _fromAirport, _endDate, _toAirport),

                        // 구체적인 항공편 정보
                        Padding(
                          padding: EdgeInsets.only(top: 16,bottom: 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("항공사 : ${_airline} | 항공편 : ${_flightName}", style: TextStyle(fontWeight: FontWeight.w800, color: Color(0xFF495057)),),
                              Text("출발터미널 : ${_terminalNum} | 탑승구 : ${_portNum} | 탑승시간 : ${_boardingTime}", style: TextStyle(fontWeight: FontWeight.w800, color:Color(0xFF495057)),)
                            ],
                          ),
                        ),
                      ],
                    ),
                    Column( // 총 여행시간
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text("총 여행"),
                        Text("${_totalDate} 일", style: TextStyle(fontWeight: FontWeight.w600, fontSize: 25))
                      ],
                    ),
                  ],
                ),
                // 수정 화면 띄우기
                Container(
                  child: Expandable(
                    firstChild: Text("여행 정보 수정", style: TextStyle(color: Colors.blue,)),
                    secondChild: EditTravelPeriodWidget(),
                    arrowLocation: ArrowLocation.left,
                    arrowWidget: Icon(Icons.keyboard_arrow_up_sharp, color: Colors.blue,),
                    boxShadow: [],
                  ),
                )
              ],
            )
            ),
          TravelEssentialsCheckList()
        ]
      )
    );
  }

  Widget TravelPeriod(String startDate, String fromAirport ,String endDate, String toAirport){
    // TODO 여기서  totalTime 시간 계산 -> 이미 앞에서 시간이 계산 되었기 때문

    return Padding(
      padding: EdgeInsets.only(top: 16),
      child: Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Column( // from part
              children: [
                Text("${startDate}", style: TextStyle(fontWeight: FontWeight.w600, fontSize: 25)),
                Text("${fromAirport}")
              ],
            ),
            Padding(padding: EdgeInsets.only(right: 8, left: 8), child: Icon(Icons.airplanemode_active)),
            Column( // end part
              children: [
                Text("${endDate}", style: TextStyle(fontWeight: FontWeight.w600, fontSize: 25)),
                Text("${toAirport}")
              ],
            )
          ],
        )
      )
    );
  }

  // 여행 정보 수정 Widget
  Widget EditTravelPeriodWidget(){
    TextEditingController _startDateController = TextEditingController(text: this._startDate);
    TextEditingController _endDateController = TextEditingController(text: this._endDate);
    TextEditingController _fromAirportController = TextEditingController(text: this._fromAirport);
    TextEditingController _toAirportController = TextEditingController(text: this._toAirport);
    TextEditingController _airlineController = TextEditingController(text: this._airline);
    TextEditingController _flightNameController = TextEditingController(text: this._flightName);
    TextEditingController _terminalNumController = TextEditingController(text: this._terminalNum);
    TextEditingController _portNumController = TextEditingController(text: this._portNum);
    TextEditingController _boardingTimeController = TextEditingController(text: this._boardingTime);


    return Padding(
      padding: EdgeInsets.all(8),
      child: Center(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                readOnly: true,
                controller: _startDateController,
                decoration: InputDecoration(labelText: '출발 날짜'),
              ),
              TextField(
                controller: _endDateController,
                readOnly: true,
                decoration: InputDecoration(labelText: '도착 날짜'),
              ),
              TextField(
                controller: _fromAirportController,
                decoration: InputDecoration(labelText: '출발 공항', hintText: "KOREA/INC"),
              ),
              TextField(
                controller: _toAirportController,
                decoration: InputDecoration(labelText: '도착 공항', hintText: "FRANCE/CDG"),
              ),
              TextField(
                controller: _airlineController,
                decoration: InputDecoration(labelText: '항공사'),
              ),
              TextField(
                controller: _flightNameController,
                decoration: InputDecoration(labelText: '항공편명'),
              ),
              TextField(
                controller: _terminalNumController,
                decoration: InputDecoration(labelText: '출발 터미널'),
              ),
              TextField(
                controller: _portNumController,
                decoration: InputDecoration(labelText: '탑승구'),
              ),
              TextField(
                readOnly: true,
                controller: _boardingTimeController,
                decoration: InputDecoration(labelText: '탑승시간'),
              ),
              TextButton(
                onPressed: (){
                  //TODO firebase에 저장 필요
                  //EX : _boardingTimeController.text로 값 가져오기
                  //지금은 UI 반영만 했음

                  String newStartDate = _startDateController.text;
                  String newEndDate = _endDateController.text;
                  String newFromAirport = _fromAirportController.text;
                  String newToAirport = _toAirportController.text;
                  String newAirLine = _airlineController.text;
                  String newFlightName = _flightNameController.text;
                  String newTerminalNum = _terminalNumController.text;
                  String newPortNum = _portNumController.text;
                  String newBoardingTime = _boardingTimeController.text;

                  setState(() {
                    this._startDate = newStartDate;
                    this._endDate = newEndDate;
                    this._fromAirport = newFromAirport;
                    this._toAirport = newToAirport;
                    this._airline = newAirLine;
                    this._flightName = newFlightName;
                    this._terminalNum = newTerminalNum;
                    this._portNum = newPortNum;
                    this._boardingTime = newBoardingTime;
                    // this._totalDate = "여기서 시간 계산"
                  });

                },
                child: Text("저장", style: TextStyle(color: Colors.black),),
                style: TextButton.styleFrom(backgroundColor: Colors.blue, shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero))
              ),
            ],
          )
        )
      )
    );
  }

  // 여행 필수 품목 Widget
  Widget TravelEssentialsCheckList(){
    return Padding(padding: EdgeInsets.symmetric(vertical: 8),
      child: ExpansionTile(
        collapsedBackgroundColor: Colors.white,
        backgroundColor: Colors.white,
        title: Text("🎒 여행 필수 품목"),
        children: [
          Column(children: this.TravelEssentialsList),
          GestureDetector( // 아이템 추가 버튼
            onTap: (){
              showModalBottomSheet(context: context, builder: (context) {
                return Container(
                  //TODO 리스트Item 추가창 만들기
                );
              });
            },
            child: Padding(padding: EdgeInsets.all(15), child: Row(children: [Icon(Icons.add_box), SizedBox(width: 10),Text("추가하기") ]))
          )
        ]
      ),
    );
  }

}


Widget _CheckListItem(String listName, String description) {
  Map<String, String> clickableWords = {
    "무비자": "비자sfdgggggggggfdgsfdgsfdgdgdgfgdfgsdgf가 없음.",
    "단기체류": "객지에 가서 단기간 동안 머물러 있음.",
    "장기체류": "객지에 가서 장기간 동안 머물러 있음.",
  };

  List<Widget> wordWidgets = [];

  description.split(' ').forEach((word) {
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

  // TODO 롱 클릭시 수정 필요함? 준희 물어보기 -> 여행 필수 품목은 고정으로 하는게 어떠 신지? (수정, 추가 불가)
  return ExpansionTile(
    title: Row(
      children: [
        //TODO checkBox 추가
        Text("$listName", style: TextStyle(fontWeight: FontWeight.w800)),
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