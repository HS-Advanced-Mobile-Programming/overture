import "package:json_annotation/json_annotation.dart";

part 'geocoding_model.g.dart';

@JsonSerializable()
class GeocodingModel{

  String name;
  LocalNamesModel local_names;
  double lat;
  double lon;
  String country;

  GeocodingModel({
    required this.name,
    required this.local_names,
    required this.lat,
    required this.lon,
    required this.country
  });

  @override
  String toString() => "${lat}, ${lon}";

  factory GeocodingModel.fromJson(Map<String, dynamic> json)=>
      _$GeocodingModelFromJson(json);

  Map<String, dynamic> toJson() => _$GeocodingModelToJson(this);
}

@JsonSerializable()
class LocalNamesModel{

  String? hi;
  String? bh;
  String? fi;
  String? zh;
  String? vo;
  String? vi;
  String? az;
  String? an;
  String? yi;
  String? et;
  String? ky;
  String? be;
  String? pl;
  String? kn;
  String? eu;
  String? la;
  String? ka;
  String? el;
  String? ml;
  String? ur;
  String? nl;
  String? bn;
  String? os;
  String? mk;
  String? ru;
  String? tr;
  String? hy;
  String? gl;
  String? bs;
  String? tg;
  String? ja;
  String? ca;
  String? cs;
  String? sv;
  String? mr;
  String? af;
  String? hu;
  String? fr;
  String? bg;
  String? sr;
  String? bo;
  String? ro;
  String? lt;
  String? he;
  String? uz;
  String? en;
  String? qu;
  String? cv;
  String? tk;
  String? uk;
  String? ta;
  String? km;
  String? oc;
  @JsonKey(name: 'is')
  String? isLang;
  String? it;
  String? sk;
  String? ba;
  String? pt;
  String? kk;
  String? de;
  String? am;
  String? fa;
  String? th;
  String? lv;
  String? eo;
  String? my;
  String? es;
  String? hr;
  String? ko;
  String? ar;
  String? sl;
  String? ku;
  String? mn;


  LocalNamesModel({
    required this.hi,
    required this.bh,
    required this.fi,
    required this.zh,
    required this.vo,
    required this.vi,
    required this.az,
    required this.an,
    required this.yi,
    required this.et,
    required this.ky,
    required this.be,
    required this.pl,
    required this.kn,
    required this.eu,
    required this.la,
    required this.ka,
    required this.el,
    required this.ml,
    required this.ur,
    required this.nl,
    required this.bn,
    required this.os,
    required this.mk,
    required this.ru,
    required this.tr,
    required this.hy,
    required this.gl,
    required this.bs,
    required this.tg,
    required this.ja,
    required this.ca,
    required this.cs,
    required this.sv,
    required this.mr,
    required this.af,
    required this.hu,
    required this.fr,
    required this.bg,
    required this.sr,
    required this.bo,
    required this.ro,
    required this.lt,
    required this.he,
    required this.uz,
    required this.en,
    required this.qu,
    required this.cv,
    required this.tk,
    required this.uk,
    required this.ta,
    required this.km,
    required this.oc,
    required this.isLang,
    required this.it,
    required this.sk,
    required this.ba,
    required this.pt,
    required this.kk,
    required this.de,
    required this.am,
    required this.fa,
    required this.th,
    required this.lv,
    required this.eo,
    required this.my,
    required this.es,
    required this.hr,
    required this.ko,
    required this.ar,
    required this.sl,
    required this.ku,
    required this.mn,
  });

  factory LocalNamesModel.fromJson(Map<String, dynamic> json)=>
      _$LocalNamesModelFromJson(json);

  Map<String, dynamic> toJson() => _$LocalNamesModelToJson(this);



}