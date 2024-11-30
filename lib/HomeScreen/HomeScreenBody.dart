import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'ExchangeRateWidget.dart';
import 'WeatherWidget.dart';

class HomeScreenBody extends StatelessWidget {
  const HomeScreenBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ListView(
        children: [ExchangeRateWidget(), const Text('나의 일정'), WeatherWidget()],
      )
    );
  }
}