import 'package:flutter/material.dart';
import 'package:overture/models/place_model_files/place_model.dart';
import 'package:overture/widgets/place_repository.dart';
import 'package:overture/widgets/schedule_bottom_sheet.dart';

class PlaceSearch extends StatefulWidget {
  final Function(Place) onPlaceSelected;

  const PlaceSearch({super.key, required this.onPlaceSelected});

  @override
  _PlaceSearchState createState() => _PlaceSearchState();
}

class _PlaceSearchState extends State<PlaceSearch> {
  final PlaceRepository repository = PlaceRepository();
  List<Place> places = [];

  void fetchData(String query) async {
    try {
      final results = await repository.fetchAndCachePlaces(query);
      setState(() {
        places = results;
      });
      for (Place place in places) {
        print("${place.placeName} ${place.addressName}");
      }
    } catch (e) {
      print("Error: $e");
    }
  }

  void loadCachedData() {
    setState(() {
      places = repository.getCachedPlaces();
    });
  }

  @override
  void initState() {
    super.initState();
    loadCachedData(); // 앱 실행 시 캐시 데이터 로드
  }

  final text =
      "한성대학교는 서울 성북구와 종로구에 위치한 사립 대학교로, 1972년에 설립되었습니다. 주요 학부로는 인문대학, 사회과학대학, 예술대학, 공과대학 등이 있으며 다양한 학부와 전공을 제공합니다. 학부와 석사, 박사 과정에서 공학, 경영학, 컴퓨터 과학, 미술, 패션 디자인 등 다양한 학문을 다룹니다";

  void _performSearch(String value) {
    fetchData(value);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20), topRight: Radius.circular(20)),
      ),
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0) +
                const EdgeInsets.symmetric(vertical: 10.0),
            child: TextField(
              style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 20),
              onChanged: _performSearch,
              decoration: InputDecoration(
                prefixIcon: IconButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    icon: const Icon(Icons.arrow_back)),
                hintText: "장소 검색",
                border: const OutlineInputBorder(borderSide: BorderSide.none),
                suffixIcon: const Icon(Icons.search),
              ),
            ),
          ),
          const Divider(
            thickness: 10.0,
            color: Color(0xffF2F2F2),
          ),
          Expanded(
            child: ListView.separated(
              separatorBuilder: (BuildContext context, int index) =>
                  const Divider(
                color: Color(0xffD2D2D2),
              ),
              itemCount: places.length,
              itemBuilder: (context, index) {
                final place = places[index];
                return ListTile(
                  tileColor: Colors.white,
                  title: Text(place.placeName,
                      style: const TextStyle(
                          fontWeight: FontWeight.w700, fontSize: 20)),
                  subtitle: Text(place.addressName,
                      style: const TextStyle(
                          fontWeight: FontWeight.w400, fontSize: 12)),
                  trailing: IconButton(
                    icon: Chip(
                      shape: RoundedRectangleBorder(
                          side: const BorderSide(
                              width: 1, color: Colors.transparent),
                          borderRadius: BorderRadius.circular(20.0)),
                      backgroundColor: const Color(0xffF2F2F2),
                      label: const Text('정보',
                          style: TextStyle(
                              fontWeight: FontWeight.w700, fontSize: 15)),
                    ),
                    onPressed: () {
                      showModalBottomSheet(
                        context: context,
                        builder: (BuildContext context) {
                          return ScheduleBottomSheet(
                            title: place.placeName,
                            button: const Text(
                              '닫기',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold),
                            ),
                            buttonOnPressed: () => Navigator.of(context).pop(),
                            child: TextField(
                              readOnly: true,
                              controller: TextEditingController(text: text),
                              minLines: 5,
                              maxLines: null,
                              decoration: const InputDecoration(
                                  border: OutlineInputBorder(
                                      borderSide: BorderSide.none),
                                  fillColor: Colors.transparent,
                                  filled: true),
                            ),
                          );
                        },
                      );
                    },
                  ),
                  onTap: () {
                    widget.onPlaceSelected(place);
                    Navigator.of(context).pop();
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
