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
  static const selectedDayTextStyle = TextStyle(
      fontSize: 17, fontWeight: FontWeight.w700, color: Color(0xffFFFFFF));
  static const selectedDateTextStyle = TextStyle(
      fontSize: 12, fontWeight: FontWeight.normal, color: Color(0xffC8C8C8));
  static const normalDayTextStyle = TextStyle(
      fontSize: 17, fontWeight: FontWeight.w700, color: Color(0xff1C0F13));
  static const normalDateTextStyle = TextStyle(
      fontSize: 12, fontWeight: FontWeight.normal, color: Color(0xff5F5F5F));

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
        SizedBox(
          width: 10,
        ),
        ClipRect(
          child: Align(
            alignment: Alignment.center,
            heightFactor: 0.5,
            widthFactor: 0.5,
            child: IconButton(
              iconSize: 50,
              icon: const Icon(Icons.chevron_left),
              onPressed: _scrollLeft,
            ),
          ),
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
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: ChoiceChip(
                    backgroundColor: Colors.white,
                    selectedColor: const Color(0xff1C0F13),
                    showCheckmark: false,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(22.0),
                        side: const BorderSide(color: Color(0xffC7C7C7))),
                    label: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 7.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Day $day',
                            textAlign: TextAlign.center,
                            style: widget.selectedDay == day
                                ? selectedDayTextStyle
                                : normalDayTextStyle,
                          ),
                          Text(
                            DateFormat('MM.dd(E)', 'ko_KR').format(n),
                            style: widget.selectedDay == day
                                ? selectedDateTextStyle
                                : normalDateTextStyle,
                          )
                        ],
                      ),
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
        ClipRect(
          child: Align(
            alignment: Alignment.center,
            heightFactor: 0.5,
            widthFactor: 0.5,
            child: IconButton(
              iconSize: 50,
              icon: const Icon(Icons.chevron_right),
              onPressed: _scrollRight,
            ),
          ),
        ),
        SizedBox(
          width: 10,
        ),
      ],
    );
  }
}
