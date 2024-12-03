import 'package:google_maps_flutter/google_maps_flutter.dart';

class Schedule {
  final int scheduleId;
  final int userId;
  final String title;
  final DateTime time;
  final LatLng latLng;
  BitmapDescriptor? icon; // 아이콘 추가

  Schedule({
    required this.scheduleId,
    required this.userId,
    required this.title,
    required this.time,
    required this.latLng,
    this.icon,
  });

  @override
  String toString() {
    return 'Schedule(scheduleId: $scheduleId, userId: $userId, title: "$title", time: $time, latLng: $latLng)';
  }
}

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
