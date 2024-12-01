import 'package:flutter/material.dart';

class DaySelector extends StatelessWidget {
  final DateTime startDate;
  final DateTime endDate;
  final int selectedDay;
  final Function(int) onSelectDay;

  DaySelector({
    required this.startDate,
    required this.endDate,
    required this.selectedDay,
    required this.onSelectDay,
  });

  @override
  Widget build(BuildContext context) {
    final int totalDays = endDate.difference(startDate).inDays + 1;

    return Container(
      height: 50,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: totalDays,
        itemBuilder: (context, index) {
          final day = index + 1;
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: ChoiceChip(
              label: Text('Day $day'),
              selected: selectedDay == day,
              onSelected: (selected) {
                if (selected) {
                  onSelectDay(day);
                }
              },
            ),
          );
        },
      ),
    );
  }
}

