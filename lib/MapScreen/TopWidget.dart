import 'package:flutter/material.dart';

import '../SearchScreen/SearchScreen.dart';
import 'entity/entity.dart';

class TopSheet extends StatelessWidget {
  final ValueChanged<Place> onSearchMarker;

  const TopSheet({required this.onSearchMarker, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xFFF0F4F6),
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
      child: Row(
        children: [
          const Text("지도", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
          const Spacer(),
          IconButton(
            onPressed: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const PlaceSearchScreen(),
                ),
              );

              onSearchMarker(result);
            },
            icon: const Icon(Icons.search),
          ),
        ],
      ),
    );
  }
}