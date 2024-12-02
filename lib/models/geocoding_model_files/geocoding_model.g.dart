// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'geocoding_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GeocodingModel _$GeocodingModelFromJson(Map<String, dynamic> json) =>
    GeocodingModel(
      name: json['name'] as String,
      local_names:
          LocalNamesModel.fromJson(json['local_names'] as Map<String, dynamic>),
      lat: (json['lat'] as num).toDouble(),
      lon: (json['lon'] as num).toDouble(),
      country: json['country'] as String,
    );

Map<String, dynamic> _$GeocodingModelToJson(GeocodingModel instance) =>
    <String, dynamic>{
      'name': instance.name,
      'local_names': instance.local_names,
      'lat': instance.lat,
      'lon': instance.lon,
      'country': instance.country,
    };

LocalNamesModel _$LocalNamesModelFromJson(Map<String, dynamic> json) =>
    LocalNamesModel(
      hi: json['hi'] as String?,
      bh: json['bh'] as String?,
      fi: json['fi'] as String?,
      zh: json['zh'] as String?,
      vo: json['vo'] as String?,
      vi: json['vi'] as String?,
      az: json['az'] as String?,
      an: json['an'] as String?,
      yi: json['yi'] as String?,
      et: json['et'] as String?,
      ky: json['ky'] as String?,
      be: json['be'] as String?,
      pl: json['pl'] as String?,
      kn: json['kn'] as String?,
      eu: json['eu'] as String?,
      la: json['la'] as String?,
      ka: json['ka'] as String?,
      el: json['el'] as String?,
      ml: json['ml'] as String?,
      ur: json['ur'] as String?,
      nl: json['nl'] as String?,
      bn: json['bn'] as String?,
      os: json['os'] as String?,
      mk: json['mk'] as String?,
      ru: json['ru'] as String?,
      tr: json['tr'] as String?,
      hy: json['hy'] as String?,
      gl: json['gl'] as String?,
      bs: json['bs'] as String?,
      tg: json['tg'] as String?,
      ja: json['ja'] as String?,
      ca: json['ca'] as String?,
      cs: json['cs'] as String?,
      sv: json['sv'] as String?,
      mr: json['mr'] as String?,
      af: json['af'] as String?,
      hu: json['hu'] as String?,
      fr: json['fr'] as String?,
      bg: json['bg'] as String?,
      sr: json['sr'] as String?,
      bo: json['bo'] as String?,
      ro: json['ro'] as String?,
      lt: json['lt'] as String?,
      he: json['he'] as String?,
      uz: json['uz'] as String?,
      en: json['en'] as String?,
      qu: json['qu'] as String?,
      cv: json['cv'] as String?,
      tk: json['tk'] as String?,
      uk: json['uk'] as String?,
      ta: json['ta'] as String?,
      km: json['km'] as String?,
      oc: json['oc'] as String?,
      isLang: json['is'] as String?,
      it: json['it'] as String?,
      sk: json['sk'] as String?,
      ba: json['ba'] as String?,
      pt: json['pt'] as String?,
      kk: json['kk'] as String?,
      de: json['de'] as String?,
      am: json['am'] as String?,
      fa: json['fa'] as String?,
      th: json['th'] as String?,
      lv: json['lv'] as String?,
      eo: json['eo'] as String?,
      my: json['my'] as String?,
      es: json['es'] as String?,
      hr: json['hr'] as String?,
      ko: json['ko'] as String?,
      ar: json['ar'] as String?,
      sl: json['sl'] as String?,
      ku: json['ku'] as String?,
      mn: json['mn'] as String?,
    );

Map<String, dynamic> _$LocalNamesModelToJson(LocalNamesModel instance) =>
    <String, dynamic>{
      'hi': instance.hi,
      'bh': instance.bh,
      'fi': instance.fi,
      'zh': instance.zh,
      'vo': instance.vo,
      'vi': instance.vi,
      'az': instance.az,
      'an': instance.an,
      'yi': instance.yi,
      'et': instance.et,
      'ky': instance.ky,
      'be': instance.be,
      'pl': instance.pl,
      'kn': instance.kn,
      'eu': instance.eu,
      'la': instance.la,
      'ka': instance.ka,
      'el': instance.el,
      'ml': instance.ml,
      'ur': instance.ur,
      'nl': instance.nl,
      'bn': instance.bn,
      'os': instance.os,
      'mk': instance.mk,
      'ru': instance.ru,
      'tr': instance.tr,
      'hy': instance.hy,
      'gl': instance.gl,
      'bs': instance.bs,
      'tg': instance.tg,
      'ja': instance.ja,
      'ca': instance.ca,
      'cs': instance.cs,
      'sv': instance.sv,
      'mr': instance.mr,
      'af': instance.af,
      'hu': instance.hu,
      'fr': instance.fr,
      'bg': instance.bg,
      'sr': instance.sr,
      'bo': instance.bo,
      'ro': instance.ro,
      'lt': instance.lt,
      'he': instance.he,
      'uz': instance.uz,
      'en': instance.en,
      'qu': instance.qu,
      'cv': instance.cv,
      'tk': instance.tk,
      'uk': instance.uk,
      'ta': instance.ta,
      'km': instance.km,
      'oc': instance.oc,
      'is': instance.isLang,
      'it': instance.it,
      'sk': instance.sk,
      'ba': instance.ba,
      'pt': instance.pt,
      'kk': instance.kk,
      'de': instance.de,
      'am': instance.am,
      'fa': instance.fa,
      'th': instance.th,
      'lv': instance.lv,
      'eo': instance.eo,
      'my': instance.my,
      'es': instance.es,
      'hr': instance.hr,
      'ko': instance.ko,
      'ar': instance.ar,
      'sl': instance.sl,
      'ku': instance.ku,
      'mn': instance.mn,
    };