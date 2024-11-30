import 'dart:convert';

import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:intl/intl.dart';

import '../models/exchange_model_files/exchange_model.dart';

class ExchangeRateWidget extends StatefulWidget {
  @override
  State<ExchangeRateWidget> createState() => _ExchangeRateWidgetState();
}

class _ExchangeRateWidgetState extends State<ExchangeRateWidget> {
  List<DropdownMenuEntry> countryName = [
    DropdownMenuEntry(value: "KRW", label: "한국 원"),
    DropdownMenuEntry(value: "AUD", label: "호주 달러"),
    DropdownMenuEntry(value: "CAD", label: "캐나다 달러"),
    DropdownMenuEntry(value: "CHF", label: "스위스 프랑"),
    DropdownMenuEntry(value: "EUR", label: "유로"),
    DropdownMenuEntry(value: "GBP", label: "영국 파운드"),
    DropdownMenuEntry(value: "HKD", label: "홍콩 달러"),
    DropdownMenuEntry(value: "JPY", label: "일본 옌"),
    DropdownMenuEntry(value: "IDR", label: "인도네시아 루피아"),
    DropdownMenuEntry(value: "NZD", label: "뉴질랜드 달러"),
    DropdownMenuEntry(value: "SGD", label: "싱가포르 달러"),
    DropdownMenuEntry(value: "USD", label: "미국 달러")
  ];

  String cur_unit = "원";
  String exchange_price = "1000";
  String kor_price = "1000";

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 32.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15.0),
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Container(
            color: Colors.white,
            padding: EdgeInsets.all(32.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("환율", style: Theme.of(context).textTheme.headlineLarge?.copyWith(fontWeight: FontWeight.bold)),
                SizedBox(height: 32),
                DottedLine(direction: Axis.horizontal, lineThickness: 3.0, dashColor: Colors.grey),
                SizedBox(height: 32),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(right: 24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("${exchange_price} ${cur_unit} 당", style: Theme.of(context).textTheme.headlineLarge?.copyWith(fontWeight: FontWeight.bold, color: Color(0xFF3C91FF))),
                          Text("${kor_price} 원", style: Theme.of(context).textTheme.headlineLarge?.copyWith(fontWeight: FontWeight.bold))
                        ],
                      ),
                    ),
                    Flexible(
                      child: DropdownMenu(
                        initialSelection: "KRW",
                        dropdownMenuEntries: countryName,
                        onSelected: (value) async {
                          cur_unit = value;

                          if (cur_unit == "IDR" || cur_unit == "JPY") {
                            exchange_price = "100";
                          } else {
                            exchange_price = "1";
                          }

                          await getExchangeJson(cur_unit).then((fetchedKorPrice)=>{
                            setState(() {
                              kor_price = fetchedKorPrice;
                            })
                          });
                        },
                      )
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Future<String> getExchangeJson(String cur_unit) async {
  var now = DateTime.now();
  debugPrint("[day]${now}");
  var yesterday = now.subtract(Duration(days: 1));
  var formattedDate = DateFormat('yyyyMMdd').format(yesterday);
  debugPrint("[day]${formattedDate}");

  String url = "${dotenv.get('EXCHANGE_BASE_URL')}?authkey=${dotenv.get("EXCHANGE_API_KEY")}&searchdate=${formattedDate}&data=${dotenv.get("EXCHANGE_DATA_TYPE")}";

  try {
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      debugPrint(response.body);
      final List<dynamic> jsonResponse = jsonDecode(response.body);
      final List<ExchangeModel> result = jsonResponse
          .map<ExchangeModel>((data) => ExchangeModel.fromJson(data))
          .toList();

      for (ExchangeModel i in result) {
        if (i.cur_unit.contains(cur_unit)) {
          debugPrint("환율 값: ${i.kftc_deal_bas_r}");
          return i.kftc_deal_bas_r;
        }
      }
    }
  } catch (e) {
    debugPrint("Exchange API 호출 오류: $e");
    return "ERROR";
  }

  return "값 없음";
}