import 'package:digi_care_pro/app/data/enum/page_status.dart';
import 'package:digi_care_pro/app/data/models/mission.dart';
import 'package:digi_care_pro/app/data/repositories/mission_repository.dart';
import 'package:digi_care_pro/app/ui/widgets/calendar_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MissionsLogic extends GetxController {

  PageStatus pageStatus = PageStatus.loading;
  DateTime _selectedDateTime = DateTime.now();
  List<Mission> missions = [];

  @override
  Future<void> onInit() async {
    super.onInit();

    Future.delayed(Duration(milliseconds: 200),(){
      getMissions();
    });

  }

  getMissions() async {
    // pageStatus = PageStatus.loading;
    // update();

    var result = await MissionRepository.get().getMissions(
      year: _selectedDateTime.year,
      month: _selectedDateTime.month,
    );

    result.fold((error) {}, (response) {
      missions = response.data!;

      pageStatus = PageStatus.loaded;
      update();
    });
  }

  Map<DateTime, List<Event>> groupMissionsByDate() {
    final Map<DateTime, List<Event>> groupedEvents = {};

    for (var mission in missions) {
      if (mission.plannedStartDateTime == null) continue;

      final startDateTime = DateTime.tryParse(mission.plannedStartDateTime!);
      if (startDateTime == null) continue;

      final dateKey = DateTime(startDateTime.year, startDateTime.month, startDateTime.day);

      final startTime = TimeOfDay(hour: startDateTime.hour, minute: startDateTime.minute);
      final endDateTime = mission.plannedEndDateTime != null
          ? DateTime.tryParse(mission.plannedEndDateTime!)
          : startDateTime.add(const Duration(hours: 1));
      final endTime = TimeOfDay(hour: endDateTime!.hour, minute: endDateTime.minute);

      final event = Event(
        title: mission.customer.getFullName(),
        startTime: startTime,
        endTime: endTime,
      );

      groupedEvents.putIfAbsent(dateKey, () => []);
      groupedEvents[dateKey]!.add(event);
    }

    return groupedEvents;
  }

  changeDate(DateTime dateTime){
    _selectedDateTime = dateTime;

    getMissions();
  }
}
