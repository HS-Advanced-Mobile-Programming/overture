import 'package:flutter/material.dart';

class PlaceSearch extends StatefulWidget {
  final Function(Map<String, String>) onPlaceSelected;

  const PlaceSearch({super.key, required this.onPlaceSelected});

  @override
  _PlaceSearchState createState() => _PlaceSearchState();
}

class _PlaceSearchState extends State<PlaceSearch> {
  List<Map<String, String>> _searchResults = [];

  void _performSearch(String value) {
    // 실제 구현에서는 API 호출을 통해 장소를 검색해야 합니다.
    // 여기서는 예시 데이터를 사용합니다.
    setState(() {
      _searchResults = [
        {'name': '서울타워', 'address': '서울특별시 용산구 남산공원길 105'},
        {'name': '경복궁', 'address': '서울특별시 종로구 사직로 161'},
        {'name': '명동성당', 'address': '서울특별시 중구 명동길 74'},
      ]
          .where((place) =>
              place['name']!.toLowerCase().contains(value.toLowerCase()) ||
              place['address']!.toLowerCase().contains(value.toLowerCase()))
          .toList();
    });
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
            padding: const EdgeInsets.all(8.0)+const EdgeInsets.symmetric(vertical: 10.0),
            child: TextField(
              style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 20),
              onChanged: _performSearch,
              decoration: InputDecoration(
                prefixIcon: IconButton(onPressed: () {
                  Navigator.of(context).pop();
                }, icon: const Icon(Icons.arrow_back)),
                hintText: "장소 검색",
                border: const OutlineInputBorder(borderSide: BorderSide.none),
                suffixIcon: const Icon(Icons.search),
              ),
            ),
          ),
          const Divider(thickness: 10.0, color: Color(0xffF2F2F2),),
          Expanded(
            child: ListView.separated(
              separatorBuilder: (BuildContext context, int index) =>
                  const Divider(),
              itemCount: _searchResults.length,
              itemBuilder: (context, index) {
                final place = _searchResults[index];
                return ListTile(
                  tileColor: Colors.white,
                  title: Text(place['name']!,
                      style: const TextStyle(
                          fontWeight: FontWeight.w700, fontSize: 20)),
                  subtitle: Text(place['address']!,
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
                          return Container(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Text(place['name']!,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w900,
                                        fontSize: 15)),
                                Text(place['address']!),
                                const SizedBox(height: 20),
                                ElevatedButton(
                                  child: const Text('닫기'),
                                  onPressed: () => Navigator.of(context).pop(),
                                ),
                              ],
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
