import "package:json_annotation/json_annotation.dart";

part 'exchange_model.g.dart';

@JsonSerializable()
class ExchangeModel {

  int result;
  String cur_unit;
  String ttb;
  String tts;
  String deal_bas_r;
  String bkpr;
  String yy_efee_r;
  String ten_dd_efee_r;
  String kftc_bkpr;
  String kftc_deal_bas_r;
  String cur_nm;

  ExchangeModel({
    required this.result,
    required this.cur_unit,
    required this.ttb,
    required this.tts,
    required this.deal_bas_r,
    required this.bkpr,
    required this.yy_efee_r,
    required this.ten_dd_efee_r,
    required this.kftc_bkpr,
    required this.kftc_deal_bas_r,
    required this.cur_nm
  });

  factory ExchangeModel.fromJson(Map<String, dynamic> json)=>
      _$ExchangeModelFromJson(json);

  Map<String, dynamic> toJson() => _$ExchangeModelToJson(this);

}