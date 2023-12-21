import 'package:calendar_scheduler/model/schedule_model.dart';
import 'package:calendar_scheduler/apis/schedule_api.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

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
    final uuid = Uuid();
    final tempId = uuid.v4();
    final newSchedule = schedule.copyWith(id: tempId);
    final savedSchedule = await api.createSchedule(schedule: schedule);

    cache.update(
      targetDate,
      (value) => [
        ...value,
        newSchedule,
      ]..sort(
          (a, b) => a.startTime.compareTo(
            b.startTime,
          ),
        ),
      ifAbsent: () => [newSchedule],
    );

    notifyListeners();

    try {
      final savedSchedule = await api.createSchedule(schedule: schedule);

      cache.update(
        targetDate,
        (value) => value
            .map((e) => e.id == tempId
                ? e.copyWith(
                    id: savedSchedule,
                  )
                : e)
            .toList(),
      );
    } catch (e) {
      cache.update(
          targetDate, (value) => value.where((e) => e.id != tempId).toList());
    }
  }

  void deleteSchedule({required DateTime date, required String id}) async {
    final targetSchedule =
        cache[date]!.firstWhere((element) => element.id == id);

    cache.update(
      date,
      (value) => value.where((element) => element.id != id).toList(),
      ifAbsent: () => [],
    );

    try {
      await api.deleteSchedule(id: id);
    } catch (e) {
      cache.update(
        date,
        (value) => [...value, targetSchedule]..sort(
            (a, b) => a.startTime.compareTo(b.startTime),
          ),
      );
    }
    notifyListeners();
  }

  void changeSelectedDate({required DateTime date}) {
    selectedDate = date;
    notifyListeners();
  }
}
