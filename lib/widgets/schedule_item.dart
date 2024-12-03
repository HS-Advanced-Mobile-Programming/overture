import 'package:flutter/material.dart';
import 'package:overture/models/schedule_model_files/schedule_model.dart';

class ScheduleItem extends StatelessWidget {
  final Schedule schedule;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const ScheduleItem({
    super.key,
    required this.schedule,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
        borderRadius: BorderRadius.circular(20.0), // 둥근 모서리 적용
        child: Dismissible(
            key: Key(schedule.id),
            direction: DismissDirection.endToStart,
            onDismissed: (direction) {
              onDelete();
            },
            background: Container(
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              color: Colors.black,
              child: const Icon(Icons.delete, color: Colors.red),
            ),
            child: Container(
              child: ListTile(
                tileColor: const Color(0xffF4F4F5),
                title: Text(
                  "🚩 ${schedule.title}",
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
                ),
                subtitle: Padding(
                  padding: const EdgeInsets.only(left: 12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("🌎 ${schedule.place}"),
                      Text("🕔 ${schedule.time}"),
                    ],
                  ),
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: onEdit,
                ),
              ),
            )));
  }
}
