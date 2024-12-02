import 'package:flutter/material.dart';
import 'package:overture/screens/schedule_view.dart';

class ScheduleScreen extends StatelessWidget {
  const ScheduleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ScheduleView(
        startDate: DateTime.now(),
        endDate: DateTime.now().add(const Duration(days: 7)),
      ),
    );
  }
}
