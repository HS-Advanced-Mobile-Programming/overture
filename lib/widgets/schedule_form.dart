import 'package:flutter/material.dart';
import 'package:overture/models/schedule_model_files/schedule_model.dart';
import 'place_search.dart';

class ScheduleForm extends StatefulWidget {
  final Schedule? schedule;
  final Function(Schedule) onSubmit;

  ScheduleForm({this.schedule, required this.onSubmit});

  @override
  _ScheduleFormState createState() => _ScheduleFormState();
}

class _ScheduleFormState extends State<ScheduleForm> {
  late TextEditingController _titleController;
  late TextEditingController _contentController;
  late TextEditingController _timeController;
  late TextEditingController _placeController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.schedule?.title ?? '');
    _contentController = TextEditingController(text: widget.schedule?.content ?? '');
    _timeController = TextEditingController(text: widget.schedule?.time ?? '');
    _placeController = TextEditingController(text: widget.schedule?.place ?? '');
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    _timeController.dispose();
    _placeController.dispose();
    super.dispose();
  }

  void _showPlaceSearch() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Container(
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
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          TextField(
            controller: _titleController,
            decoration: InputDecoration(labelText: '제목'),
          ),
          TextField(
            controller: _contentController,
            decoration: InputDecoration(labelText: '내용'),
          ),
          TextField(
            controller: _timeController,
            decoration: InputDecoration(labelText: '시간'),
            onTap: () async {
              final TimeOfDay? picked = await showTimePicker(
                context: context,
                initialTime: TimeOfDay.now(),
              );
              if (picked != null) {
                setState(() {
                  _timeController.text = picked.format(context);
                });
              }
            },
          ),
          TextField(
            controller: _placeController,
            decoration: InputDecoration(
              labelText: '장소',
              suffixIcon: IconButton(
                icon: Icon(Icons.search),
                onPressed: _showPlaceSearch,
              ),
            ),
            readOnly: true,
            onTap: _showPlaceSearch,
          ),
          SizedBox(height: 20),
          ElevatedButton(
            child: Text(widget.schedule == null ? '추가' : '수정'),
            onPressed: () {
              if (_titleController.text.isEmpty ||
                  _placeController.text.isEmpty ||
                  _timeController.text.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('제목, 장소, 시간을 모두 입력해주세요.')),
                );
                return;
              }
              final schedule = Schedule(
                id: widget.schedule?.id ?? DateTime.now().toString(),
                title: _titleController.text,
                content: _contentController.text,
                time: _timeController.text,
                place: _placeController.text,
              );
              widget.onSubmit(schedule);
            },
          ),
        ],
      ),
    );
  }
}

