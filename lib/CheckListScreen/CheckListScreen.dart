import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animated_icons/icons8.dart';

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

  String _totalTime = "72";

  // 항공사 : 대한항공 | 항공편 : KE901
  // 출발터미널 : T2 | 탑승구 : 253 | 탑승시간 : 19:30
  String _airline = "대한항공"; //항공사
  String _flightName = "KE901"; //항공편
  String _terminalNum="T2"; // 터미널
  String _portNum = "253";// 탑승구
  String _boardingTime = "19:30"; // 탑승시간

  List<Widget> TravelEssentialsList = [
    // _CheckListItem("비자발급","프랑스 여행 시 단기체류(90일 이하)의 경우 무비자 입국 가능 ※ 장기체류의 경우 별도의 비자신청이 필요합니다.")
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children:[
        Container(
          color: Colors.white,
          child:Padding(
            padding: EdgeInsets.all(16.0),
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
                        // 여행 시작, 조착 일자, 도착 공항
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
                        // 수정창 띄위기
                        Container(
                          child: GestureDetector(
                            onTap: ()=>{
                              // 편집창 띄위기
                              showModalBottomSheet(context: context, builder: (context) {
                                return Container(
                                  //TODO 수정창 만들기
                                );
                              })
                            },
                            child: Row(
                              children: [
                                Icon(Icons.border_color_outlined, color: Colors.blue),
                                Text("여행정보 수정", style: TextStyle(color: Colors.blue))
                              ],
                            )
                          ),
                        )
                      ],
                    ),
                    Column( // 총 여행시간
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text("총 여행 시간"),
                        Text("${_totalTime}시간", style: TextStyle(fontWeight: FontWeight.w600, fontSize: 25))
                      ],
                    )
                  ],
                ),
              ],
            )
          )
        ),
        TravelEssentialsCheckList()
      ]
    );
  }

  Widget TravelPeriod(String startDate,String fromAirport ,String endDate, String toAirport){
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

  Widget TravelEssentialsCheckList(){
    return ExpansionTile(
      collapsedBackgroundColor: Colors.white,
      backgroundColor: Colors.white,
      title: Text("🎒 여행 필수 품목"),
      children: [
        Column(children: this.TravelEssentialsList),
        GestureDetector( // 아이템 추가 버튼
            onTap: (){/*TODO Item 추가하기*/},
            child: Padding(padding: EdgeInsets.all(15), child: Row(children: [Icon(Icons.add_box), SizedBox(width: 10),Text("추가하기") ]))
        )
      ]
    );
  }

}

// //TODO 단어랑 정의 Pair How?
// Widget _CheckListItem(String listName, String description){
//   String clickableWords = '무비자,단기체류,장기체류,비자신청,무비자';  // 클릭 가능한 단어들
//   List<TextSpan> textSpans = [];
//
//   // description에 포함된 텍스트를 분리해서 각각 TextSpan으로 만들기
//   description.split(' ').forEach((word) {
//     if (clickableWords.contains(word)) {
//       // 해당 단어가 포함되면 LongPressGestureRecognizer를 추가하여 클릭 가능하게 만듦
//       textSpans.add(TextSpan(
//         text: '$word ',
//         style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
//         recognizer: LongPressGestureRecognizer()..onLongPress = () {
//           // 롱 클릭시 의미 띄우기
//           print('클릭된 단어: $word');
//         },
//       ));
//     } else {
//       // 해당 단어는 그냥 텍스트로 추가
//       textSpans.add(TextSpan(
//           text: '$word '  // 기본 텍스트 색상
//       ));
//     }
//   });
//
//   return ExpansionTile(
//     title: Row(children: [Checkbox(value: value, onChanged: onChanged),Text("${listName}", style: TextStyle(fontWeight: FontWeight.w800))],) ,
//     backgroundColor: Colors.white,
//     children: [
//       Padding(
//         padding: EdgeInsets.only(right: 16,left: 16, bottom: 16),
//         child: RichText(
//           text: TextSpan(
//             children: textSpans,
//             style: TextStyle( color: Colors.black), // 기본 텍스트 스타일
//           ),
//         )
//       ),
//     ],
//   );
// }
