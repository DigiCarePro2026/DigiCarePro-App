import 'dart:async';
import 'dart:math';

import 'package:digi_care_pro/app/data/api/api_models/cancel_mission.dart';
import 'package:digi_care_pro/app/data/api/api_models/change_mission_datetime.dart';
import 'package:digi_care_pro/app/data/api/api_models/check_mission_status.dart';
import 'package:digi_care_pro/app/data/api/api_models/delay_mission.dart';
import 'package:digi_care_pro/app/data/api/api_models/manual_end.dart';
import 'package:digi_care_pro/app/data/api/api_models/report_mission.dart';
import 'package:digi_care_pro/app/data/api/api_models/start_mission.dart';
import 'package:digi_care_pro/app/data/enum/cancel_mission_type.dart';
import 'package:digi_care_pro/app/data/enum/mission_action_type.dart';
import 'package:digi_care_pro/app/data/models/mission.dart';
import 'package:digi_care_pro/app/data/repositories/mission_repository.dart';
import 'package:digi_care_pro/app/routes/app_routes.dart';
import 'package:digi_care_pro/app/ui/pages/mission/mission_details_screen.dart';
import 'package:digi_care_pro/app/ui/theme/app_colors.dart';
import 'package:digi_care_pro/app/ui/widgets/app_dropdown_field.dart';
import 'package:digi_care_pro/app/ui/widgets/app_text_area_field.dart';
import 'package:digi_care_pro/app/ui/widgets/calendar_widget.dart';
import 'package:digi_care_pro/app/ui/widgets/primary_button.dart';
import 'package:digi_care_pro/app/ui/widgets/secondary_button.dart';
import 'package:digi_care_pro/app/ui/widgets/snack.dart';
import 'package:digi_care_pro/app/ui/widgets/delay_time_picker.dart';
import 'package:digi_care_pro/app/ui/widgets/time_picker.dart';
import 'package:digi_care_pro/app/utils/dialog_handler.dart';
import 'package:digi_care_pro/app/utils/location_service.dart';
import 'package:digi_care_pro/app/utils/mission_event_bus.dart';
import 'package:digi_care_pro/app/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class MissionDetailsLogic extends GetxController {
  late Mission mission;
  bool isLocationServiceOk = false;
  Position? userLocation;
  MissionActionType? actionType;

  List<MenuModel> menuItems = [];

  MissionDetailsLogic(this.mission);

  @override
  void onReady() {
    checkMissionStatus(true);

    super.onReady();
  }

  Future<bool> findUserLocation(bool hasLoading) async {
    var completer = Completer<bool>();

    isLocationServiceOk = await LocationService.instance.ensurePermissionAndService(context: Get.context!);

    update();
    if (isLocationServiceOk) {
      if (hasLoading) {
        DialogHandler.showLoading('finding_location'.tr);
      }

      userLocation = await LocationService.instance.getCurrentLocation(context: Get.context!);

      DialogHandler.hideLoading();

      if (!completer.isCompleted) completer.complete(true);
    } else {
      if (!completer.isCompleted) completer.complete(false);
    }

    return completer.future;
  }

  checkMissionStatus(bool hasLoadingForLocation) async {
    DialogHandler.showLoading('loading_check_mission_status'.tr);

    if(hasLoadingForLocation) {
      await findUserLocation(hasLoadingForLocation);
    }

    if (isLocationServiceOk) {
      var result = await MissionRepository.get().checkMissionStatus(
        CheckMissionStatusRequest(
          missionId: mission.id,
          latitude: userLocation!.latitude,
          longitude: userLocation!.longitude,
        ),
      );

      DialogHandler.hideLoading();

      result.fold(
        (error) {
          snackError(message: error.message);
        },
        (response) {
          actionType = response.data;

          _prepareMenuItems();
        },
      );
    }
  }

  _prepareMenuItems() {
    menuItems = [
      MenuModel(
        title: 'routing'.tr,
        icon: 'assets/icons/routing.svg',
        color: AppColors.routingColor,
        callback: () => openNavigation(mission.customerLatitude ?? 0, mission.customerLongitude ?? 0),
      ),
      MenuModel(
        title: 'call'.tr,
        icon: 'assets/icons/call.svg',
        color: AppColors.callColor,
        callback: () => makeCall(mission.customerPhone ?? ''),
      ),
      MenuModel(
        title: 'add_mission'.tr,
        icon: 'assets/icons/add-mission.svg',
        color: AppColors.addMissionColor,
        callback: () {
          Get.toNamed(Routes.CREATE_MISSION, arguments: mission.customerId);
        },
      ),
    ];

    if (actionType != MissionActionType.done) {
      menuItems.add(
        MenuModel(
          title: 'submit_report'.tr,
          icon: 'assets/icons/report.svg',
          color: AppColors.reportColor,
          callback: () async {
            String? report = await showMissionReportBottomSheet();

            if (report != null) {
              _reportMissionApi(report);
            }
          },
        ),
      );
      menuItems.add(
        MenuModel(
          title: 'delay_report'.tr,
          icon: 'assets/icons/delay-report.svg',
          color: AppColors.delayReportColor,
          callback: () async {
            Duration? duration = await showDelayTimeBottomSheet();

            if (duration != null) {
              _delayReportApi(duration.inMinutes);
            }
          },
        ),
      );
      menuItems.add(
        MenuModel(
          title: 'change_date_time'.tr,
          icon: 'assets/icons/calendar-setting.svg',
          color: AppColors.changeDateAndTimeColor,
          callback: () async {
            String? result = await showChangeDateAndTimeBottomSheet();
          },
        ),
      );
      menuItems.add(
        MenuModel(
          title: 'cancel_mission'.tr,
          icon: 'assets/icons/cancel.svg',
          color: AppColors.cancelMissionColor,
          callback: () async {
            CancelMissionType? reason = await showCancelMissionBottomSheet();

            if (reason != null) {
              _cancelMissionApi(reason.title);
            }
          },
        ),
      );
      menuItems.add(
        MenuModel(
          title: 'upload_document'.tr,
          icon: 'assets/icons/upload.svg',
          color: AppColors.uploadColor,
          callback: () {
            Get.toNamed(
              Routes.MISSION_UPLOAD_DOC,
              arguments: {'missionId': mission.id, 'customerId': mission.customerId},
            );
          },
        ),
      );
    }

    update();
  }

  handleActionTap() async {
    switch (actionType!) {
      case MissionActionType.autoStart:
        startMission();
        break;

      case MissionActionType.manualStart:
        String? reason = await showManualEndMissionBottomSheet();
        if (reason != null) {
          manualEnd(reason);
        }
        break;

      case MissionActionType.sign:
        bool needRefresh = await Get.toNamed(Routes.MISSION_SIGNATURE, arguments: mission.id);
        if (needRefresh) {
          checkMissionStatus(false);

          MissionEventBus eventBus = Get.find();
          eventBus.sendUpdate(true);
        }
        break;

      case MissionActionType.done:
        break;
    }
  }

  startMission() async {
    DialogHandler.showLoading('start_mission'.tr);

    var result = await MissionRepository.get().startMission(
      StartMissionRequest(missionId: mission.id, latitude: userLocation!.latitude, longitude: userLocation!.longitude),
    );

    DialogHandler.hideLoading();

    result.fold(
      (error) {
        snackError(message: error.message);
      },
      (response) {
        snackSuccess(message: response.message);

        checkMissionStatus(false);
      },
    );
  }

  Future<String?> showManualEndMissionBottomSheet() async {
    TextEditingController controller = TextEditingController();

    String? value;

    return await showModalBottomSheet<String>(
      context: Get.context!,
      isScrollControlled: true,
      useSafeArea: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom + MediaQuery.of(context).padding.bottom,
            left: 16,
            right: 16,
            top: 20,
          ),
          child: StatefulBuilder(
            builder: (context, setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('manual_start'.tr, style: Theme.of(context).textTheme.headlineMedium),
                  const SizedBox(height: 16),
                  AppTextAreaField(
                    title: 'reason'.tr,
                    onChanged: (text) => setState(() => value),
                    controller: controller,
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
                            if(controller.text.isEmpty){
                              snackError(message: 'reason_required'.tr);
                              return;
                            }

                            Navigator.pop(context, controller.text);
                          }
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                ],
              );
            },
          ),
        );
      },
    );
  }

  manualEnd(String reason) async {
    DialogHandler.showLoading('manual_start'.tr);

    var result = await MissionRepository.get().manualEnd(
      ManualEndRequest(missionId: mission.id, reason: reason),
      loadingMessage: 'Manual start'.tr,
    );

    DialogHandler.hideLoading();

    result.fold(
      (error) {
        snackError(message: error.message);
      },
      (response) {
        snackSuccess(message: response.message);

        MissionEventBus eventBus = Get.find();
        eventBus.sendUpdate(true);

        checkMissionStatus(false);
      },
    );
  }

  //<editor-fold desc="Delay">
  Future<Duration?> showDelayTimeBottomSheet({Duration? initialValue}) async {
    Duration? selectedValue = initialValue;

    return await showModalBottomSheet<Duration>(
      context: Get.context!,
      isScrollControlled: true,
      useSafeArea: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom + MediaQuery.of(context).padding.bottom,
            left: 16,
            right: 16,
            top: 20,
          ),
          child: StatefulBuilder(
            builder: (context, setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('delay_report_title'.tr, style: Theme.of(context).textTheme.headlineMedium),
                  const SizedBox(height: 16),
                  DelayTimePickerField(
                    title: '',
                    showHours: false,
                    initialValue: selectedValue,
                    onChanged: (value) {
                      setState(() => selectedValue = value);
                    },
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
                          onPressed: () => Navigator.pop(context, selectedValue),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                ],
              );
            },
          ),
        );
      },
    );
  }

  _delayReportApi(int minutes) async {
    DialogHandler.showLoading('loading_delay_mission'.tr);

    var result = await MissionRepository.get().delayReport(
      DelayMissionRequest(missionId: mission.id, delayMinutes: minutes),
    );

    DialogHandler.hideLoading();

    result.fold(
      (error) {
        snackError(message: error.message);
      },
      (response) {
        snackSuccess(message: response.message);

        if (response.data != null) {
          mission.plannedStartDateTime = response.data!.plannedStartDateTime;

          MissionEventBus eventBus = Get.find();
          eventBus.sendUpdate(false);

          update();
        }
      },
    );
  }

  //</editor-fold>

  //<editor-fold desc="Report">
  Future<String?> showMissionReportBottomSheet({String? initialValue}) async {
    String? report = initialValue;

    return await showModalBottomSheet<String>(
      context: Get.context!,
      isScrollControlled: true,
      useSafeArea: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom + MediaQuery.of(context).padding.bottom,
            left: 16,
            right: 16,
            top: 20,
          ),
          child: StatefulBuilder(
            builder: (context, setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('mission_report'.tr, style: Theme.of(context).textTheme.headlineMedium),
                  const SizedBox(height: 16),
                  AppTextAreaField(
                    title: 'description'.tr,
                    onChanged: (value) {
                      setState(() => report = value);
                    },
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: SecondaryButton(label: 'cancel'.tr, onPressed: () => Navigator.pop(context, null)),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: PrimaryButton(label: 'confirm'.tr, onPressed: () => Navigator.pop(context, report)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                ],
              );
            },
          ),
        );
      },
    );
  }

  _reportMissionApi(String report) async {
    var result = await MissionRepository.get().reportMission(
      ReportMissionRequest(missionId: mission.id, report: report),
      loadingMessage: 'loading_report_mission'.tr,
    );

    result.fold(
      (error) {
        snackError(message: error.message);
      },
      (response) {
        snackSuccess(message: response.message);
      },
    );
  }

  //</editor-fold>

  //<editor-fold desc="Change datetime">
  Future<String?> showChangeDateAndTimeBottomSheet() async {
    DateTime? selectedDate;
    TimeOfDay startTime = TimeOfDay.now();
    TimeOfDay endTime = TimeOfDay.now();
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
                              initialDate: DateTime.tryParse(mission.plannedStartDateTime!),
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
                                      initialValue: parseTime(mission.plannedStartDateTime) ?? TimeOfDay.now().replacing(
                                        hour: TimeOfDay.now().hour,
                                        minute: (TimeOfDay.now().minute / 15).floor() * 15,
                                      ),
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
                                      initialValue: parseTime(mission.plannedEndDateTime) ?? TimeOfDay.now().replacing(
                                        hour: min(TimeOfDay.now().hour + 2, 23),
                                        minute: TimeOfDay.now().hour == 23 ? 55 : 0,
                                      ),
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

  _changeMissionDatetimeApi({required String plannedStart, required String plannedEnd, required String reason}) async {
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

        snackSuccess(message: response.message);
      },
    );
  }

  //</editor-fold>

  //<editor-fold desc="Cancel">
  Future<CancelMissionType?> showCancelMissionBottomSheet() async {
    CancelMissionType? selectedValue;

    return await showModalBottomSheet<CancelMissionType>(
      context: Get.context!,
      isScrollControlled: true,
      useSafeArea: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom + MediaQuery.of(context).padding.bottom,
            left: 16,
            right: 16,
            top: 20,
          ),
          child: StatefulBuilder(
            builder: (context, setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('cancel_mission'.tr, style: Theme.of(context).textTheme.headlineMedium),
                  const SizedBox(height: 16),
                  AppDropdownField<CancelMissionType>(
                    title: 'reason'.tr,
                    onChanged: (value) {
                      setState(() {
                        selectedValue = value;
                      });
                    },
                    items: CancelMissionType.values.map((cmt) {
                      return DropdownMenuItem<CancelMissionType>(
                        value: cmt,
                        child: Text(cmt.title, style: Theme.of(context).textTheme.labelMedium),
                      );
                    }).toList(),
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
                          onPressed: () => Navigator.pop(context, selectedValue),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                ],
              );
            },
          ),
        );
      },
    );
  }

  _cancelMissionApi(String reason) async {
    DialogHandler.showLoading('loading_cancel_mission'.tr);

    var result = await MissionRepository.get().cancelMission(
      CancelMissionRequest(missionId: mission.id, reason: reason),
    );

    DialogHandler.hideLoading();

    result.fold(
      (error) {
        snackError(message: error.message);
      },
      (response) {
        MissionEventBus eventBus = Get.find();
        eventBus.sendUpdate(false);

        Get.back();

        snackSuccess(message: response.message);
      },
    );
  }

  //</editor-fold>
}
