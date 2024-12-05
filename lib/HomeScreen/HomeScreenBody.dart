import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'ExchangeRateWidget.dart';
import 'MyScheduleWidget.dart';
import 'WeatherWidget.dart';

class HomeScreenBody extends StatelessWidget {
  const HomeScreenBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ListView(
        children: [ExchangeRateWidget(), MyScheduleWidget(), WeatherWidget()],
      )
    );
  }
}