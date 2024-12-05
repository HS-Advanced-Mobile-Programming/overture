import 'dart:math';

import 'package:google_maps_flutter/google_maps_flutter.dart';

// class Schedule {
//   final int id;
//   final String content;
//   final String title;
//   final String place;
//   final DateTime time;
//   final LatLng latLng;
//
//   Schedule({
//     required this.id,
//     required this.content,
//     required this.place,
//     required this.title,
//     required this.time,
//     required this.latLng,
//   });
// }


class Place {
  final String name;
  final String address;
  final double rating;
  final String placeId;

  Place({
    required this.name,
    required this.address,
    required this.rating,
    required this.placeId,
  });

  // 팩토리 생성자: JSON 데이터를 클래스로 변환
  factory Place.fromJson(Map<String, dynamic> json) {
    return Place(
      name: json['name'] ?? '이름 없음',
      address: json['address'] ?? '주소 없음',
      rating: (json['rating'] ?? 0.0).toDouble(),
      placeId: json['place_id'] ?? '',
    );
  }

  // toJson: 클래스 데이터를 JSON 형식으로 변환
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'address': address,
      'rating': rating,
      'place_id': placeId,
    };
  }

  @override
  String toString() {
    return 'Place(name: $name, address: $address, rating: $rating, placeId: $placeId)';
  }
}

/// 두 지점 간의 거리 계산 (Haversine Formula)
double calculateDistance(LatLng start, LatLng end) {
  const R = 6371; // 지구 반지름 (km)

  // 위도와 경도를 라디안으로 변환
  double dLat = _degreesToRadians(end.latitude - start.latitude);
  double dLon = _degreesToRadians(end.longitude - start.longitude);

  double a = sin(dLat / 2) * sin(dLat / 2) +
      cos(_degreesToRadians(start.latitude)) * cos(_degreesToRadians(end.latitude)) *
          sin(dLon / 2) * sin(dLon / 2);

  double c = 2 * atan2(sqrt(a), sqrt(1 - a));
  return R * c; // 거리 (단위: km)
}

/// 도(degree)를 라디안으로 변환
double _degreesToRadians(double degrees) {
  return degrees * pi / 180;
}