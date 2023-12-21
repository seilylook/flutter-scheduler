import 'package:calendar_scheduler/model/schedule_model.dart';
import 'package:calendar_scheduler/apis/schedule_api.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ScheduleProvider extends ChangeNotifier {
  final ScheduleAPI api;

  DateTime selectedDate = DateTime.utc(
    DateTime.now().year,
    DateTime.now().month,
    DateTime.now().day,
  );

  Map<DateTime, List<ScheduleModel>> cache = {};

  ScheduleProvider({required this.api}) : super() {
    getSchedules(date: selectedDate);
  }

  void getSchedules({required DateTime date}) async {
    final response = await api.getSchedules(date: date);
    cache.update(date, (value) => response, ifAbsent: () => response);
    notifyListeners();
  }

  void createSchedule({required ScheduleModel schedule}) async {
    final targetDate = schedule.date;
    final savedSchedule = await api.createSchedule(schedule: schedule);

    cache.update(
      targetDate,
      (value) => [
        ...value,
        schedule.copyWith(
          id: savedSchedule,
        ),
      ]..sort(
          (a, b) => a.startTime.compareTo(
            b.startTime,
          ),
        ),
      ifAbsent: () => [schedule],
    );

    notifyListeners();
  }

  void deleteSchedule({required DateTime date, required String id}) async {
    final response = await api.deleteSchedule(id: id);

    cache.update(
      date,
      (value) => value.where((e) => e.id != id).toList(),
      ifAbsent: () => [],
    );

    notifyListeners();
  }

  void changeSelectedDate({required DateTime date}) {
    selectedDate = date;
    notifyListeners();
  }
}
