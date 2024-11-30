
import 'dart:convert';
import 'dart:ffi';

import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animated_icons/icons8.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';
import 'package:overture/models/geocoding_model_files/geocoding_model.dart';
import 'package:overture/models/weather_model_files/weather_model.dart';

class WeatherWidget extends StatefulWidget {
  const WeatherWidget({super.key});

  @override
  State<WeatherWidget> createState() => _WeatherWidgetState();
}

class _WeatherWidgetState extends State<WeatherWidget> {

  List<DropdownMenuEntry> cityName = [
    DropdownMenuEntry(value: "Seoul", label: "한국"),
    DropdownMenuEntry(value: "Canberra", label: "호주"),
    DropdownMenuEntry(value: "Ottawa", label: "캐나다"),
    DropdownMenuEntry(value: "Bern", label: "스위스"),
    DropdownMenuEntry(value: "Berlin", label: "독일"),
    DropdownMenuEntry(value: "London", label: "영국"),
    DropdownMenuEntry(value: "HongKong", label: "홍콩"),
    DropdownMenuEntry(value: "Tokyo", label: "일본"),
    DropdownMenuEntry(value: "Jakarta", label: "인도네시아"),
    DropdownMenuEntry(value: "Wellington", label: "뉴질랜드"),
    DropdownMenuEntry(value: "Singapore", label: "싱가포르"),
    DropdownMenuEntry(value: "D.C.", label: "미국")
  ];

  List<_WeatherState> weatherOfFiveDays = [];

  String cur_city = "Seoul";

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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(right: 24),
                      child: Text("${cur_city}의 \n날씨", style: Theme.of(context).textTheme.headlineLarge?.copyWith(fontWeight: FontWeight.bold)),
                    ),
                    Flexible(
                      child: DropdownMenu(
                        initialSelection: "Seoul",
                        dropdownMenuEntries: cityName,
                        onSelected: (value) {
                          setState(() {
                            cur_city = value;
                            getWeatherJson(cur_city).then((value)=>{
                              setState(() {
                                weatherOfFiveDays = value ?? weatherOfFiveDays;
                              })
                            });
                          });
                        },
                      )
                    )

                  ]
                ),
                SizedBox(height: 32),
                DottedLine(direction: Axis.horizontal, lineThickness: 3.0, dashColor: Colors.grey),
                SizedBox(height: 32),
                Container(
                  height: 200,
                  child: ListView(
                    padding: EdgeInsets.symmetric(vertical: 8.0),
                    scrollDirection: Axis.horizontal,
                    children: [
                      if(weatherOfFiveDays.isEmpty)
                        Text("날씨를 확인해 보세요.", style: TextStyle(fontSize: 32, fontWeight: FontWeight.w800))
                      else
                        for(_WeatherState ws in weatherOfFiveDays )
                          WeatherIconWidget(ws)
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }


  Widget WeatherIconWidget(_WeatherState weatherState){
    
    LottieBuilder lottieIcon = Lottie.asset(
      Icons8.sun_weather, // Lottie 애니메이션 파일 경로
      width: 50, // 아이콘 크기
      height: 50, // 아이콘 크기
      repeat: true, // 애니메이션 반복
      animate: true, // 애니메이션 자동 재생
    );
    
    switch (weatherState.weatherCondition){
      case "Clouds":
        lottieIcon = Lottie.asset(
          Icons8.cloudy_weather,
          width: 50,
          height: 50,
          repeat: true,
          animate: true,
        );
        break;
      case "Rain":
        lottieIcon = Lottie.asset(
          Icons8.rainy_weather,
          width: 50,
          height: 50,
          repeat: true,
          animate: true,
        );
        break;
      case "Snow":
        lottieIcon = Lottie.asset(
          Icons8.light_snowy_weather,
          width: 50,
          height: 50,
          repeat: true,
          animate: true,
        );
        break;
      case "Fog":
        lottieIcon = Lottie.asset(
          Icons8.fog_weather,
          width: 50,
          height: 50,
          repeat: true,
          animate: true,
        );
        break;
      case "Dust":
      case "Sand":
    }

    return Padding(
        padding: EdgeInsets.symmetric(horizontal: 8.0),
        child: Container(
            width: 125,
            decoration: BoxDecoration(
              color: Color.fromRGBO(60, 145, 255, 0.5),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  spreadRadius: 2,
                  blurRadius: 6,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(weatherState.dateTime),
                    lottieIcon,
                    Text(weatherState.description),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("${weatherState.minTemp}°", style: TextStyle(fontWeight: FontWeight.w800)),
                        Text(" / ", style: TextStyle(color: Colors.grey),),
                        Text("${weatherState.maxTemp}°", style: TextStyle(fontWeight: FontWeight.w800))
                      ],
                    )
                  ],
                )
            )
        )
    );

  }
}

class _WeatherState {

  String weatherCondition=""; //main값들 cluods 이런거
  String description="";// 맑음 흐림 이런거
  double minTemp=0;
  double maxTemp=0;
  String dateTime="";

  _WeatherState({
    required this.weatherCondition,
    required this.description,
    required this.minTemp,
    required this.maxTemp,
    required this.dateTime
  });
}

Future<List<_WeatherState>?> getWeatherJson(String cityName) async {

  List<_WeatherState> returnValue = [];

  String geocodingUri = "${dotenv.get("GEOCODING_BASE_URL")}?q=${cityName}&limit=1&appid=${dotenv.get("WEATHER_API_KEY")}";

  try {
    final geocodingResponse = await http.get(Uri.parse(geocodingUri));

    if (geocodingResponse.statusCode == 200) {
      final List<dynamic> jsonResponse = jsonDecode(geocodingResponse.body);
      final List<GeocodingModel> geocodingResult = jsonResponse
          .map<GeocodingModel>((data) => GeocodingModel.fromJson(data))
          .toList();
      // debugPrint(geocodingResult.toString());

      double lat = geocodingResult[0].lat;
      double lon = geocodingResult[0].lon;

      try{
        String weatherUri = "${dotenv.get("WEATHER_BASE_URL")}?lat=${lat}&lon=${lon}&appid=${dotenv.get("WEATHER_API_KEY")}&units=metric&lang=kr";

        final weatherResponse = await http.get(Uri.parse(weatherUri));

        if(weatherResponse.statusCode == 200){
          final Map<String, dynamic> jsonResponse = jsonDecode(weatherResponse.body);
          final WeatherModel weatherResult = WeatherModel.fromJson(jsonResponse);

          for(int i=0;i<weatherResult.list.length;i++){
            if(i%8 == 0){
              returnValue.add(
                _WeatherState(
                    weatherCondition: weatherResult.list[i].weather[0].main,
                    description: weatherResult.list[i].weather[0].description,
                    minTemp: weatherResult.list[i].main.temp_min,
                    maxTemp: weatherResult.list[i].main.temp_max,
                    dateTime: weatherResult.list[i].dt_txt.split(" ")[0]
                )
              );
            }
          }
        }

        return returnValue;
      }catch(e){
        //TODO snackbar에 표시
        debugPrint("Weather API 호출 오류: $e");
      }

    }
  } catch (e) {
    //TODO snackbar에 표시
    debugPrint("Geocoding API 호출 오류: $e");
  }

  return null;
}