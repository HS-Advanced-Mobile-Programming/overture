import 'package:json_annotation/json_annotation.dart';

part 'airportinfo_model.g.dart';

@JsonSerializable()
class AirportInfoModel{
  String air_line;
  String boarding_time;
  String end_date;
  String flight_name;
  String from_airport;
  String port_num;
  String start_date;
  String terminal_num;
  String to_airport;

  AirportInfoModel({
    required this.air_line,
    required this.boarding_time,
    required this.end_date,
    required this.flight_name,
    required this.from_airport,
    required this.port_num,
    required this.start_date,
    required this.terminal_num,
    required this.to_airport
  });

  factory AirportInfoModel.fromJson(Map<String, dynamic> json)=>
      _$AirportInfoModelFromJson(json);

  Map<String, dynamic> toJson() => _$AirportInfoModelToJson(this);

}