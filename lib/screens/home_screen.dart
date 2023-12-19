import 'package:calendar_scheduler/constants/constants.dart';
import 'package:calendar_scheduler/widgets/main_calendar.dart';
import 'package:calendar_scheduler/widgets/schedule_bottom_sheet.dart';
import 'package:calendar_scheduler/widgets/schedule_card.dart';
import 'package:calendar_scheduler/widgets/today_banner.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DateTime selectedDate = DateTime.utc(
    DateTime.now().year,
    DateTime.now().month,
    DateTime.now().day,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: PRIMARY_COLOR,
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isDismissible: true,
            builder: (_) => ScheduleBottomSheet(),
            isScrollControlled: true,
          );
        },
        child: const Icon(
          Icons.add,
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            MainCalendar(
              selectedDate: selectedDate,
              onDaySelected: onDaySelected,
            ),
            TodayBanner(selectedDate: selectedDate, count: 0),
            const SizedBox(height: 8.0),
            ScheduleCard(startTime: 12, endTime: 14, content: 'flutter 프로젝트'),
          ],
        ),
      ),
    );
  }

  void onDaySelected(DateTime selectedDate, DateTime focusedDate) {
    setState(() {
      this.selectedDate = selectedDate;
    });
  }
}
