import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:expandable_widgets/expandable_widgets.dart';
import 'package:intl/intl.dart';
import 'package:flutter_time_picker_spinner/flutter_time_picker_spinner.dart';
import 'package:overture/CheckListScreen/ClothExpansionTileWidget.dart';
import 'package:overture/models/check_model_files/clothes_model.dart';
import 'package:overture/models/check_model_files/essential_model.dart';
import '../models/check_model_files/airportinfo_model.dart';
import '../service/FirestoreAirportinfoService.dart';
import 'EssentialCheckListWidget.dart';


class CheckListScreen extends StatefulWidget {
  const CheckListScreen({super.key});

  @override
  State<CheckListScreen> createState() => _CheckListScreenState();
}

class _CheckListScreenState extends State<CheckListScreen> {

  String _startDate = DateFormat('yyyy.MM.dd').format(DateTime.now());
  String _endDate = DateFormat('yyyy.MM.dd').format(DateTime.now());

  late String editableStartDate;
  late String editableEndDate;

  String _fromAirport = "KOREA/INC"; // 출발 나라와 공항 이름의 조합
  String _toAirport = "FRANCE/CDG"; // 도착 나라와 공항 이름의 조합

  late String _totalDate;

  String _airline = "대한항공"; //항공사
  String _flightName = "KE901"; //항공편
  String _terminalNum = "T2"; // 터미널
  String _portNum = "253";// 탑승구
  String _boardingTime = DateFormat('HH:mm').format(DateTime.now());

  late String editableBoardingTime;

  EssentialCheckListModel essentialCheckListModel = EssentialCheckListModel();

  ClothesCheckListModel clothesCheckListModel = ClothesCheckListModel();

  FirestoreAirportinfoService airportinfoService = FirestoreAirportinfoService();

  Future<void> getAllAirportInfo() async {
    List<AirportInfoModel> fetchedAirportInfo = await airportinfoService.getAllAirportInfo();

    setState(() {
      _startDate = fetchedAirportInfo[0].start_date;
      _endDate = fetchedAirportInfo[0].end_date;
      _fromAirport = fetchedAirportInfo[0].from_airport;
      _toAirport = fetchedAirportInfo[0].to_airport;
      _airline = fetchedAirportInfo[0].air_line;
      _flightName = fetchedAirportInfo[0].flight_name;
      _terminalNum = fetchedAirportInfo[0].terminal_num;
      _portNum = fetchedAirportInfo[0].port_num;
      _boardingTime = fetchedAirportInfo[0].boarding_time;
    });
  }

  @override
  void initState() {
    super.initState();

    getAllAirportInfo();

    this._totalDate = (DateFormat("yyyy.MM.dd").parse(_endDate)
        .difference(DateFormat("yyyy.MM.dd").parse(_startDate))
        .inDays+1).toString();
    this.editableStartDate = _startDate;
    this.editableEndDate = _endDate;
    this.editableBoardingTime = _boardingTime;

    // this.clothingList.add(ClothesCheckListItem(id: "0",itemName: "상의",description: "회의용", quantity: 3, onItemDelete: deleteClothesById, ),);
  }


  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children:[
          Padding(
            padding: EdgeInsets.only(bottom: 8),
            child: Container(
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
            )
          ),
          TravelEssentialsCheckList(),
          ClothingExpansionTile(
            clothingList: this.clothesCheckListModel.clothesCheckList,
            onItemAdded: (ClothesContent newClothe){
              setState(() {
                this.clothesCheckListModel.addClothe(newClothe);
              });

            },
            onItemDelete: (String target){
              setState(() {
                this.clothesCheckListModel.deleteClothes(target);
              });
            },
          )
        ]
      )
    );
  }

  // 여행 정보 수정 Widget
  Widget EditTravelPeriodWidget(){
    TextEditingController _fromAirportController = TextEditingController(text: this._fromAirport);
    TextEditingController _toAirportController = TextEditingController(text: this._toAirport);
    TextEditingController _airlineController = TextEditingController(text: this._airline);
    TextEditingController _flightNameController = TextEditingController(text: this._flightName);
    TextEditingController _terminalNumController = TextEditingController(text: this._terminalNum);
    TextEditingController _portNumController = TextEditingController(text: this._portNum);

    String tempTime = "";

    return Padding(
      padding: EdgeInsets.all(8),
      child: Center(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("출발 날짜"),
                  Text(editableStartDate),
                  IconButton(icon: Icon(Icons.calendar_today, color: Colors.pink,), onPressed: (){
                    showDatePicker(
                      context: context,
                      initialDate: DateFormat("yyyy.MM.dd").parse(editableStartDate),
                      firstDate: DateTime(2020),
                      lastDate: DateTime(2030),
                    ).then((value) {
                      if (value != null) {
                        setState(() {
                          editableStartDate = DateFormat('yyyy.MM.dd').format(value);
                        });
                      }
                    });
                  },)
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("도착 날짜"),
                  Text(editableEndDate),
                  IconButton(icon: Icon(Icons.calendar_today, color: Colors.pink,), onPressed: (){
                    showDatePicker(
                      context: context,
                      initialDate: DateFormat("yyyy.MM.dd").parse(editableEndDate),
                      firstDate: DateTime(2020),
                      lastDate: DateTime(2030),
                    ).then((value) {
                      if (value != null) {
                        setState(() {
                          editableEndDate = DateFormat('yyyy.MM.dd').format(value);
                        });
                      }
                    });
                  },)
                ],
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("탑승 시간"),
                  Text(editableBoardingTime),
                  IconButton(
                    icon: Icon(Icons.access_time_rounded, color: Colors.pink,),
                    onPressed: (){
                      showModalBottomSheet(context: context, builder: (BuildContext context) {
                        return Column(
                            children: [
                              Spacer(),
                              TimePickerSpinner(
                                is24HourMode: false,
                                normalTextStyle: TextStyle(
                                    fontSize: 24,
                                    color: Colors.black
                                ),
                                highlightedTextStyle: TextStyle(
                                    fontSize: 24,
                                    color: Colors.blue
                                ),
                                spacing: 50,
                                itemHeight: 80,
                                isForce2Digits: true,
                                onTimeChange: (time) {
                                  setState(() {
                                    tempTime = DateFormat('HH:mm').format(time);
                                  });
                                },
                              ),
                              Spacer(),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  Expanded(
                                    child: Container(
                                      color:Colors.black,
                                      child: TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);  // 취소 버튼 클릭 시 BottomSheet 닫기
                                        },
                                        child: Text("취소", style: TextStyle(color: Colors.white),),
                                      ),
                                    )
                                  ),
                                  Expanded(
                                    child: Container(
                                      color:Colors.blue,
                                      child: TextButton(
                                      onPressed: () {
                                        setState(() {
                                          editableBoardingTime = tempTime;  // 저장 버튼 클릭 시 시간 반영
                                        });
                                        Navigator.pop(context);  // BottomSheet 닫기
                                      },
                                      child: Text("수정", style: TextStyle(color: Colors.white),),
                                    ),
                                  )),
                                ],
                              ),
                            ],
                          );
                      });
                    },
                  )
                ],
              ),
              TextButton(
                onPressed: () {
                  //TODO firebase에 저장 필요
                  //EX : _boardingTimeController.text로 값 가져오기
                  //지금은 UI 반영만 된 상태

                  String newStartDate = editableStartDate;
                  String newEndDate = editableEndDate;
                  String newFromAirport = _fromAirportController.text;
                  String newToAirport = _toAirportController.text;
                  String newAirLine = _airlineController.text;
                  String newFlightName = _flightNameController.text;
                  String newTerminalNum = _terminalNumController.text;
                  String newPortNum = _portNumController.text;
                  String newBoardingTime = editableBoardingTime;

                  airportinfoService.updateAirportInfo(AirportInfoModel(
                      air_line: newAirLine,
                      boarding_time: newBoardingTime,
                      end_date: newEndDate,
                      flight_name: newFlightName,
                      from_airport: newFromAirport,
                      port_num: newPortNum,
                      start_date: newStartDate,
                      terminal_num: newTerminalNum,
                      to_airport:newToAirport
                  ));

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
                    this._totalDate = (DateFormat("yyyy.MM.dd").parse(_endDate)
                        .difference(DateFormat("yyyy.MM.dd").parse(_startDate))
                        .inDays+1).toString();
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
        children: essentialCheckListModel.essentialCheckList
            .map((item) => EssentialCheckListItem(
              itemName: item.itemName,
              description: item.description,
              checked: item.isChecked,
          )
        ).toList(),
      ),
    );
  }

}

Widget TravelPeriod(String startDate, String fromAirport ,String endDate, String toAirport){
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
