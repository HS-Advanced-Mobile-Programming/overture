// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'exchange_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ExchangeModel _$ExchangeModelFromJson(Map<String, dynamic> json) =>
    ExchangeModel(
      result: (json['result'] as num).toInt(),
      cur_unit: json['cur_unit'] as String,
      ttb: json['ttb'] as String,
      tts: json['tts'] as String,
      deal_bas_r: json['deal_bas_r'] as String,
      bkpr: json['bkpr'] as String,
      yy_efee_r: json['yy_efee_r'] as String,
      ten_dd_efee_r: json['ten_dd_efee_r'] as String,
      kftc_bkpr: json['kftc_bkpr'] as String,
      kftc_deal_bas_r: json['kftc_deal_bas_r'] as String,
      cur_nm: json['cur_nm'] as String,
    );

Map<String, dynamic> _$ExchangeModelToJson(ExchangeModel instance) =>
    <String, dynamic>{
      'result': instance.result,
      'cur_unit': instance.cur_unit,
      'ttb': instance.ttb,
      'tts': instance.tts,
      'deal_bas_r': instance.deal_bas_r,
      'bkpr': instance.bkpr,
      'yy_efee_r': instance.yy_efee_r,
      'ten_dd_efee_r': instance.ten_dd_efee_r,
      'kftc_bkpr': instance.kftc_bkpr,
      'kftc_deal_bas_r': instance.kftc_deal_bas_r,
      'cur_nm': instance.cur_nm,
    };
