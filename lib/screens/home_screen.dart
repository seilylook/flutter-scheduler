import 'package:calendar_scheduler/widgets/main_calendar.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            MainCalendar(),
          ],
        ),
      ),
    );
  }
}
