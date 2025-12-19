import 'dart:math';

import 'package:digi_care_pro/app/data/api/api_models/change_mission_datetime.dart';
import 'package:digi_care_pro/app/data/api/api_models/get_missions.dart';
import 'package:digi_care_pro/app/data/enum/mission_status.dart';
import 'package:digi_care_pro/app/data/models/customer.dart';
import 'package:digi_care_pro/app/data/models/mission.dart';
import 'package:digi_care_pro/app/data/repositories/mission_repository.dart';
import 'package:digi_care_pro/app/ui/widgets/app_text_area_field.dart';
import 'package:digi_care_pro/app/ui/widgets/calendar_widget.dart';
import 'package:digi_care_pro/app/ui/widgets/primary_button.dart';
import 'package:digi_care_pro/app/ui/widgets/secondary_button.dart';
import 'package:digi_care_pro/app/ui/widgets/snack.dart';
import 'package:digi_care_pro/app/ui/widgets/time_picker.dart';
import 'package:digi_care_pro/app/utils/dialog_handler.dart';
import 'package:digi_care_pro/app/utils/mission_event_bus.dart';
import 'package:digi_care_pro/app/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MissionsLogic extends GetxController {
  DateTime _selectedDateTime = DateTime.now();
  Customer? selectedCustomer;

  int? selectedDay;
  List<Mission> allMissions = [], filteredMissions = [];
  MissionStatus selectedMissionType = MissionStatus.all;

  int missionCountInDateFilter = 0;

  @override
  void onReady() {
    getMissions();

    MissionEventBus eventBus = Get.find();

    eventBus.delayUpdated.stream.listen((reloadMissions) {
      if (reloadMissions) {
        getMissions();
      } else {
        update();
      }
    });

    super.onReady();
  }

  void onCustomerSelected(customer) {
    selectedCustomer = customer;

    getMissions();
  }

  getMissions() async {
    DialogHandler.showLoading('loading_missions'.tr);

    var result = await MissionRepository.get().getMissions(
      GetMissionsRequest(
        year: _selectedDateTime.year,
        month: _selectedDateTime.month,
        customerId: selectedCustomer?.id,
      ),
    );

    DialogHandler.hideLoading();

    result.fold(
      (error) {
        snackError(message: error.message);
      },
      (response) {
        allMissions = response.data!;

        // DateTime now = DateTime.now();
        // if (now.month == _selectedDateTime.month) {
          innerFilterMissions(day: selectedDay, missionType: selectedMissionType);
        // } else {
        //   filteredMissions.clear();
        //   filteredMissions.addAll(allMissions);
        //   missionCountInDateFilter = allMissions.length;
        //   update();
        // }
      },
    );
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

  innerFilterMissions({int? day, MissionStatus? missionType}) {
    // if (day != null) {
    selectedDay = day;
    //}

    if (selectedDay != null) {
      _changeDay(selectedDay!);
    } else {
      filteredMissions.clear();
      filteredMissions.addAll(allMissions);
      missionCountInDateFilter = filteredMissions.length;
    }

    if (missionType != null) {
      selectedMissionType = missionType;

      _filterMissionType();
    }
  }

  _filterMissionType() {
    List<Mission> tempList = [];

    for (Mission mission in filteredMissions) {
      switch (selectedMissionType) {
        case MissionStatus.all:
          tempList.add(mission);
          break;

        case MissionStatus.draft:
          /* if (mission.realStartTime == null && mission.realEndTime == null) {
            tempList.add(mission);
          }*/

          if (mission.status == MissionStatus.draft.code) {
            tempList.add(mission);
          }
          break;

        case MissionStatus.inProgress:
          /*if (mission.realStartTime != null && mission.realEndTime == null) {
            tempList.add(mission);
          }*/
          if (mission.status == MissionStatus.inProgress.code) {
            tempList.add(mission);
          }
          break;

        case MissionStatus.completed:
          /*if (mission.realStartTime != null && mission.realEndTime != null) {
            tempList.add(mission);
          }*/
          if (mission.status == MissionStatus.completed.code) {
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

  //<editor-fold desc="Change datetime">
  Future<String?> showChangeDateAndTimeBottomSheet(Mission mission) async {
    DateTime? selectedDate = DateTime.tryParse(mission.plannedStartDateTime!);
    TimeOfDay startTime =
        parseTime(mission.plannedStartDateTime) ??
        TimeOfDay.now().replacing(hour: TimeOfDay.now().hour, minute: (TimeOfDay.now().minute / 15).floor() * 15);
    TimeOfDay endTime =
        parseTime(mission.plannedEndDateTime) ??
        TimeOfDay.now().replacing(hour: min(TimeOfDay.now().hour + 2, 23), minute: TimeOfDay.now().hour == 23 ? 55 : 0);
    TextEditingController reasonController = TextEditingController();

    return await showModalBottomSheet<String>(
      context: Get.context!,
      isScrollControlled: true,
      useSafeArea: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.85,
          maxChildSize: 0.95,
          minChildSize: 0.50,
          expand: false,
          builder: (BuildContext context, ScrollController scrollController) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom + MediaQuery.of(context).padding.bottom,
                left: 16,
                right: 16,
                top: 20,
              ),
              child: StatefulBuilder(
                builder: (context, setState) {
                  return SingleChildScrollView(
                    child: Column(
                      children: [
                        Text('change_date_time'.tr, style: Theme.of(context).textTheme.headlineMedium),
                        const SizedBox(height: 16),
                        Column(
                          children: [
                            CalendarWidget(
                              selectionMode: CalendarSelectionMode.single,
                              initialDate: selectedDate,
                              minDate: DateTime.now().subtract(const Duration(days: 1)),
                              onDateSelected: (date, isChangedMonth) {
                                if (!isChangedMonth) {
                                  selectedDate = date;
                                }
                              },
                            ),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: Center(
                                    child: TimePickerField(
                                      title: 'start'.tr,
                                      initialValue: startTime,
                                      onChanged: (time) {
                                        setState(() {
                                          startTime = time;
                                        });
                                      },
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Center(
                                    child: TimePickerField(
                                      title: 'end'.tr,
                                      initialValue: endTime,
                                      onChanged: (time) {
                                        setState(() {
                                          endTime = time;
                                        });
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            AppTextAreaField(title: 'reason'.tr, controller: reasonController),
                          ],
                        ),
                        const SizedBox(height: 24),
                        Row(
                          children: [
                            Expanded(
                              child: SecondaryButton(label: 'cancel'.tr, onPressed: () => Navigator.pop(context, null)),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: PrimaryButton(
                                label: 'confirm'.tr,
                                onPressed: () {
                                  if (selectedDate == null) {
                                    snackError(message: 'change_datetime_error_date_null'.tr);
                                    return;
                                  }

                                  DateTime plannedStart = DateTime(
                                    selectedDate!.year,
                                    selectedDate!.month,
                                    selectedDate!.day,
                                    startTime.hour,
                                    startTime.minute,
                                  );

                                  DateTime plannedEnd = DateTime(
                                    selectedDate!.year,
                                    selectedDate!.month,
                                    selectedDate!.day,
                                    endTime.hour,
                                    endTime.minute,
                                  );

                                  _changeMissionDatetimeApi(
                                    mission: mission,
                                    plannedStart: plannedStart.toIso8601String(),
                                    plannedEnd: plannedEnd.toIso8601String(),
                                    reason: reasonController.text,
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  );
                },
              ),
            );
          },
        );
      },
    );
  }

  _changeMissionDatetimeApi({
    required Mission mission,
    required String plannedStart,
    required String plannedEnd,
    required String reason,
  }) async {
    DialogHandler.showLoading('loading_change_mission_datetime'.tr);

    var result = await MissionRepository.get().changeMissionDatetime(
      ChangeMissionDatetimeRequest(
        missionId: mission.id,
        plannedStart: plannedStart,
        plannedEnd: plannedEnd,
        reason: reason,
      ),
    );

    DialogHandler.hideLoading();

    result.fold(
      (error) {
        snackError(message: error.message);
      },
      (response) {
        Navigator.pop(Get.context!, result);

        getMissions();
        snackSuccess(message: response.message);
      },
    );
  }

  //</editor-fold>
}
