import 'package:digi_care_pro/app/data/enum/mission_type.dart';
import 'package:digi_care_pro/app/data/enum/page_status.dart';
import 'package:digi_care_pro/app/data/models/mission.dart';
import 'package:digi_care_pro/app/data/repositories/mission_repository.dart';
import 'package:digi_care_pro/app/ui/widgets/calendar_widget.dart';
import 'package:digi_care_pro/app/ui/widgets/snack.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MissionsLogic extends GetxController {
  DateTime _selectedDateTime = DateTime.now();
  int? _selectedDay;
  List<Mission> allMissions = [], filteredMissions = [];
  MissionType selectedMissionType = MissionType.all;

  int missionCountInDateFilter = 0;

  @override
  void onReady() {
    getMissions();

    super.onReady();
  }

  getMissions() async {
    var result = await MissionRepository.get().getMissions(
      year: _selectedDateTime.year,
      month: _selectedDateTime.month,
    );

    result.fold((error) {
      snackError(message: error.message);

    }, (response) {
      allMissions = response.data!;
      filteredMissions.clear();

      filteredMissions.addAll(allMissions);

      missionCountInDateFilter = allMissions.length;

      update();
    });
  }

  Map<DateTime, List<Event>> groupMissionsByDate() {
    final Map<DateTime, List<Event>> groupedEvents = {};

    for (var mission in allMissions) {
      if (mission.plannedStartDateTime == null) continue;

      final startDateTime = DateTime.tryParse(mission.plannedStartDateTime!);
      if (startDateTime == null) continue;

      final dateKey = DateTime(startDateTime.year, startDateTime.month, startDateTime.day);

      final startTime = TimeOfDay(hour: startDateTime.hour, minute: startDateTime.minute);
      final endDateTime = mission.plannedEndDateTime != null
          ? DateTime.tryParse(mission.plannedEndDateTime!)
          : startDateTime.add(const Duration(hours: 1));
      final endTime = TimeOfDay(hour: endDateTime!.hour, minute: endDateTime.minute);

      final event = Event(title: mission.customerName ?? '', startTime: startTime, endTime: endTime);

      groupedEvents.putIfAbsent(dateKey, () => []);
      groupedEvents[dateKey]!.add(event);
    }

    return groupedEvents;
  }

  changeMonth(DateTime dateTime) {
    _selectedDateTime = dateTime;

    getMissions();
  }

  innerFilterMissions({int? day, MissionType? missionType}){
    if(day != null){
      _selectedDay = day;
    }

    if(_selectedDay != null){
      _changeDay(_selectedDay!);
    }else{
      filteredMissions.addAll(allMissions);
    }

    if(missionType != null){
      selectedMissionType = missionType;
    }

    _filterMissionType();
  }

  _filterMissionType() {
    List<Mission> tempList = [];

    for (Mission mission in filteredMissions) {
      switch (selectedMissionType) {
        case MissionType.all:
          tempList.add(mission);
          break;

        case MissionType.todo:
          if (mission.realStartTime == null) {
            tempList.add(mission);
          }
          break;

        case MissionType.inProgress:
          if (mission.realStartTime != null && mission.realEndTime == null) {
            tempList.add(mission);
          }
          break;

        case MissionType.done:
          if (mission.realStartTime != null && mission.realEndTime != null) {
            tempList.add(mission);
          }
          break;
      }
    }

    filteredMissions.clear();
    filteredMissions.addAll(tempList);

    update();
  }

  _changeDay(int day) {
    filteredMissions.clear();

    for (Mission mission in allMissions) {
      if (mission.plannedStartDateTime != null) {
        final startDateTime = DateTime.tryParse(mission.plannedStartDateTime!);
        if (startDateTime == null) continue;
        if (startDateTime.day == day) {
          filteredMissions.add(mission);
        }
      }
    }

    missionCountInDateFilter = filteredMissions.length;

    update();
  }
}
