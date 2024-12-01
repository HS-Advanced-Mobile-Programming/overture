import 'package:flutter/material.dart';

class PlaceSearch extends StatefulWidget {
  final Function(String) onPlaceSelected;

  PlaceSearch({required this.onPlaceSelected});

  @override
  _PlaceSearchState createState() => _PlaceSearchState();
}

class _PlaceSearchState extends State<PlaceSearch> {
  String _searchTerm = '';
  List<Map<String, String>> _searchResults = [];

  void _performSearch(String value) {
    // 실제 구현에서는 API 호출을 통해 장소를 검색해야 합니다.
    // 여기서는 예시 데이터를 사용합니다.
    setState(() {
      _searchTerm = value;
      _searchResults = [
        {'name': '서울타워', 'address': '서울특별시 용산구 남산공원길 105'},
        {'name': '경복궁', 'address': '서울특별시 종로구 사직로 161'},
        {'name': '명동성당', 'address': '서울특별시 중구 명동길 74'},
      ].where((place) =>
      place['name']!.toLowerCase().contains(value.toLowerCase()) ||
          place['address']!.toLowerCase().contains(value.toLowerCase())
      ).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.all(8.0),
          child: TextField(
            onChanged: _performSearch,
            decoration: const InputDecoration(
              labelText: '장소 검색',
              suffixIcon: Icon(Icons.search),
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: _searchResults.length,
            itemBuilder: (context, index) {
              final place = _searchResults[index];
              return ListTile(
                title: Text(place['name']!),
                subtitle: Text(place['address']!),
                trailing: IconButton(
                  icon: Icon(Icons.info),
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      builder: (BuildContext context) {
                        return Container(
                          padding: EdgeInsets.all(16.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Text(place['name']!, style: Theme.of(context).textTheme.labelLarge),
                              Text(place['address']!),
                              SizedBox(height: 20),
                              ElevatedButton(
                                child: Text('닫기'),
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
                  widget.onPlaceSelected(place['name']!);
                  Navigator.of(context).pop();
                },
              );
            },
          ),
        ),
      ],
    );
  }
}

