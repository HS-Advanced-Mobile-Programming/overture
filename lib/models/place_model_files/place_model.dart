import 'package:hive/hive.dart';

part 'place_model.g.dart'; // Hive 코드 생성

@HiveType(typeId: 0) // typeId는 고유해야 함
class Place extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String placeName;

  @HiveField(2)
  String addressName;

  @HiveField(3)
  String roadAddressName;

  @HiveField(4)
  String categoryName;

  @HiveField(5)
  String placeUrl;

  @HiveField(6)
  String x;

  @HiveField(7)
  String y;

  Place({
    required this.id,
    required this.placeName,
    required this.addressName,
    required this.roadAddressName,
    required this.categoryName,
    required this.placeUrl,
    required this.x,
    required this.y,
  });
}