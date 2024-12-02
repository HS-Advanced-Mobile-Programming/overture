import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DaySelector extends StatefulWidget {
  final DateTime startDate;
  final DateTime endDate;
  final int selectedDay;
  final Function(int) onSelectDay;

  const DaySelector({
    super.key,
    required this.startDate,
    required this.endDate,
    required this.selectedDay,
    required this.onSelectDay,
  });

  @override
  _DaySelectorState createState() => _DaySelectorState();
}

class _DaySelectorState extends State<DaySelector> {
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollLeft() {
    if (_scrollController.offset > 0) {
      _scrollController.animateTo(
        _scrollController.offset - 100,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  void _scrollRight() {
    if (_scrollController.offset < _scrollController.position.maxScrollExtent) {
      _scrollController.animateTo(
        _scrollController.offset + 100,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final int totalDays =
        widget.endDate.difference(widget.startDate).inDays + 1;

    return Row(
      children: [
        IconButton(
          icon: const Icon(Icons.chevron_left),
          onPressed: _scrollLeft,
        ),
        Expanded(
          child: SizedBox(
            height: 60,
            child: ListView.builder(
              controller: _scrollController,
              scrollDirection: Axis.horizontal,
              itemCount: totalDays,
              itemBuilder: (context, index) {
                final day = index + 1;
                DateTime n = widget.startDate.add(Duration(days: index));
                return Padding(
                  padding: const EdgeInsets.all(1.0),
                  child: ChoiceChip(
                    showCheckmark: false,
                    label: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Day $day',
                          textAlign: TextAlign.center,
                        ),
                        Text(DateFormat('MM.dd(E)', 'ko_KR').format(n))
                      ],
                    ),
                    selected: widget.selectedDay == day,
                    onSelected: (selected) {
                      if (selected) {
                        widget.onSelectDay(day);
                      }
                    },
                  ),
                );
              },
            ),
          ),
        ),
        IconButton(
          icon: const Icon(Icons.chevron_right),
          onPressed: _scrollRight,
        ),
      ],
    );
  }
}
