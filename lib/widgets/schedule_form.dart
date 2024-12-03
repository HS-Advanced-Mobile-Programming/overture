import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:overture/models/schedule_model_files/schedule_model.dart';
import 'package:overture/widgets/schedule_bottom_sheet.dart';
import 'place_search.dart';

class ScheduleForm extends StatefulWidget {
  final DateTime selectedDate;
  final Schedule? schedule;
  final Function(Schedule) onSubmit;

  const ScheduleForm(
      {super.key,
      required this.selectedDate,
      this.schedule,
      required this.onSubmit});

  @override
  _ScheduleFormState createState() => _ScheduleFormState();
}

class _ScheduleFormState extends State<ScheduleForm> {
  late TextEditingController _titleController;
  late TextEditingController _contentController;
  late TextEditingController _timeController;
  late TextEditingController _placeController;
  DateTime? _pickedTime;

  @override
  void initState() {
    super.initState();
    _titleController =
        TextEditingController(text: widget.schedule?.title ?? '');
    _contentController =
        TextEditingController(text: widget.schedule?.content ?? '');
    _timeController = TextEditingController(text: widget.schedule?.time ?? '');
    _placeController =
        TextEditingController(text: widget.schedule?.place ?? '');

    if (widget.schedule != null) {
      _pickedTime = DateFormat('yyyy-MM-dd HH:mm').parse(widget.schedule!.time);
      _timeController = TextEditingController(
        text: DateFormat('HH:mm').format(_pickedTime!),
      );
    } else {
      _timeController = TextEditingController();
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    _timeController.dispose();
    _placeController.dispose();
    super.dispose();
  }

  void _showPlaceSearch(BuildContext context2) {
    showModalBottomSheet(
      context: context2,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return SizedBox(
          height: MediaQuery.of(context).size.height * 0.9,
          child: PlaceSearch(
            onPlaceSelected: (Map<String, String> selectedPlace) {
              setState(() {
                _placeController.text = selectedPlace['name'] ?? '';
              });
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScheduleBottomSheet(
      title: "일정 추가",
      button: Text(
        widget.schedule == null ? '추가' : '수정',
        style: const TextStyle(
            color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
      ),
      buttonOnPressed: () {
        if (_titleController.text.isEmpty || _timeController.text.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('제목, 장소, 시간을 모두 입력해주세요.')),
          );
          return;
        }
        final schedule = Schedule(
          id: widget.schedule?.id ?? DateTime.now().toString(),
          title: _titleController.text,
          content: _contentController.text,
          time: _pickedTime != null
              ? DateFormat('yyyy-MM-dd HH:mm').format(_pickedTime!)
              : '',
          place: _placeController.text,
        );
        widget.onSubmit(schedule);
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Text(
            "제목",
            textAlign: TextAlign.start,
            style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w700,
                color: Color(0xff5F5F5F)),
          ),
          const SizedBox(height: 5),
          TextField(
            decoration: const InputDecoration(
                hintText: "예: 공항 출발",
                enabledBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Color(0xffA6A6A6), width: 1.0)),
                focusedBorder: const OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Color(0xff3C91FF), width: 1.0)),
                fillColor: Colors.white,
                filled: true),
            controller: _titleController,
          ),
          const SizedBox(height: 15),
          const Text(
            "장소",
            textAlign: TextAlign.start,
            style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w700,
                color: Color(0xff5F5F5F)),
          ),
          const SizedBox(height: 5),
          TextField(
            controller: _placeController,
            decoration: InputDecoration(
              hintText: "장소를 검색하세요.",
              enabledBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xffA6A6A6), width: 1.0)),
              focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xff3C91FF), width: 1.0)),
              fillColor: Colors.white,
              filled: true,
              suffixIcon: IconButton(
                icon: const Icon(Icons.search),
                onPressed: () => _showPlaceSearch(context),
              ),
            ),
            readOnly: true,
            onTap: () => _showPlaceSearch(context),
          ),
          const SizedBox(height: 15),
          const Text(
            "시간",
            textAlign: TextAlign.start,
            style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w700,
                color: Color(0xff5F5F5F)),
          ),
          const SizedBox(height: 5),
          TextField(
            readOnly: true,
            controller: _timeController,
            decoration: const InputDecoration(
                hintText: "시간을 입력하세요.",
                prefixIcon: Icon(Icons.access_time_rounded),
                enabledBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Color(0xffA6A6A6), width: 1.0)),
                focusedBorder: const OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Color(0xff3C91FF), width: 1.0)),
                fillColor: Colors.white,
                filled: true),
            onTap: () async {
              final TimeOfDay? picked = await showTimePicker(
                context: context,
                initialTime: TimeOfDay.now(),
              );
              if (picked != null) {
                setState(() {
                  final now = DateTime.now();
                  _pickedTime = DateTime(
                    now.year,
                    widget.selectedDate.month,
                    widget.selectedDate.day,
                    picked.hour,
                    picked.minute,
                  );
                  _timeController.text =
                      DateFormat('HH:mm').format(_pickedTime!);
                });
              }
            },
          ),
          const SizedBox(height: 15),
          const Text(
            "내용",
            textAlign: TextAlign.start,
            style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w700,
                color: Color(0xff5F5F5F)),
          ),
          const SizedBox(height: 5),
          TextField(
            controller: _contentController,
            minLines: 4,
            maxLines: null,
            decoration: const InputDecoration(
                enabledBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Color(0xffA6A6A6), width: 1.0)),
                focusedBorder: const OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Color(0xff3C91FF), width: 1.0)),
                fillColor: Colors.white,
                filled: true),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
