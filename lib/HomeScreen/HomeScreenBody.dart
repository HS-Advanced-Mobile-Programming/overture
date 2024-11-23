import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'ExchangeRate.dart';

class HomeScreenBody extends StatelessWidget {
  const HomeScreenBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [ExchangeRate(), const Text('나의 일정'), const Text('날씨')],
      )
    );
  }
}