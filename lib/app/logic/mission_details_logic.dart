import 'dart:async';

import 'package:digi_care_pro/app/data/api/api_models/cancel_mission.dart';
import 'package:digi_care_pro/app/data/api/api_models/change_mission_datetime.dart';
import 'package:digi_care_pro/app/data/api/api_models/check_mission_status.dart';
import 'package:digi_care_pro/app/data/api/api_models/delay_mission.dart';
import 'package:digi_care_pro/app/data/api/api_models/report_mission.dart';
import 'package:digi_care_pro/app/data/enum/cancel_mission_type.dart';
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
import 'package:digi_care_pro/app/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class MissionDetailsLogic extends GetxController {
  late Mission mission;
  bool isLocationServiceOk = false;
  Position? userLocation;
  List<MenuModel> menuItems = [];

  MissionDetailsLogic(this.mission);

  @override
  void onReady() {
    _prepareMenuItems();

    checkMissionStatus();

    super.onReady();
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
      MenuModel(
        title: 'add_mission'.tr,
        icon: 'assets/icons/add-mission.svg',
        color: AppColors.addMissionColor,
        callback: () {
          Get.toNamed(Routes.CREATE_MISSION, arguments: mission.customerId);
        },
      ),
      MenuModel(
        title: 'customer_signature'.tr,
        icon: 'assets/icons/signature.svg',
        color: AppColors.signatureColor,
        callback: () {
          Get.toNamed(Routes.MISSION_SIGNATURE, arguments: mission.id);
        },
      ),
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
      MenuModel(
        title: 'change_date_time'.tr,
        icon: 'assets/icons/calendar-setting.svg',
        color: AppColors.delayReportColor,
        callback: () async {
          String? result = await showChangeDateAndTimeBottomSheet();
        },
      ),
      MenuModel(
        title: 'cancel_mission'.tr,
        icon: 'assets/icons/cancel.svg',
        color: AppColors.delayReportColor,
        callback: () async {
          CancelMissionType? reason = await showCancelMissionBottomSheet();

          if (reason != null) {
            _cancelMissionApi(reason.title);
          }
        },
      ),
    ];
  }

  Future<bool> findUserLocation() async {
    final completer = Completer<bool>();

    isLocationServiceOk = await LocationService.instance.ensurePermissionAndService(context: Get.context!);

    update();
    if(isLocationServiceOk){
      DialogHandler.showLoading('finding_location'.tr);

      userLocation = await LocationService.instance.getCurrentLocation(context: Get.context!);

      Get.back();

      if (!completer.isCompleted) completer.complete(true);
    }else{
      if (!completer.isCompleted) completer.complete(false);
    }

    return completer.future;
  }

  checkMissionStatus() async {
    await findUserLocation();

    if(isLocationServiceOk) {
      var result = await MissionRepository.get().checkMissionStatus(
          CheckMissionStatusRequest(
              missionId: mission.id, latitude: userLocation!.latitude, longitude: userLocation!.longitude),
          loadingMessage: 'loading_check_mission_status'.tr);

      Get.back();

      result.fold((error) {
        snackError(message: error.message);
      }, (response) {
        update();
      });
    }
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
            bottom: MediaQuery
                .of(context)
                .viewInsets
                .bottom + MediaQuery
                .of(context)
                .padding
                .bottom,
            left: 16,
            right: 16,
            top: 20,
          ),
          child: StatefulBuilder(
            builder: (context, setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('delay_report_title'.tr, style: Theme
                      .of(context)
                      .textTheme
                      .headlineMedium),
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
    var result = await MissionRepository.get().delayReport(
      DelayMissionRequest(missionId: mission.id, delayMinutes: minutes),
      loadingMessage: 'loading_delay_mission'.tr,
    );

    Get.back();

    result.fold(
          (error) {
        snackError(message: error.message);
      },
          (response) {
        snackSuccess(message: response.message);

        //todo: what todo?
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
            bottom: MediaQuery
                .of(context)
                .viewInsets
                .bottom + MediaQuery
                .of(context)
                .padding
                .bottom,
            left: 16,
            right: 16,
            top: 20,
          ),
          child: StatefulBuilder(
            builder: (context, setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('mission_report'.tr, style: Theme
                      .of(context)
                      .textTheme
                      .headlineMedium),
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

    Get.back();

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

  //<editor-fold desc="change datetime">
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
                bottom: MediaQuery
                    .of(context)
                    .viewInsets
                    .bottom + MediaQuery
                    .of(context)
                    .padding
                    .bottom,
                left: 16,
                right: 16,
                top: 20,
              ),
              child: StatefulBuilder(
                builder: (context, setState) {
                  return SingleChildScrollView(
                    child: Column(
                      children: [
                        Text('change_date_time'.tr, style: Theme
                            .of(context)
                            .textTheme
                            .headlineMedium),
                        const SizedBox(height: 16),
                        Column(
                          children: [
                            CalendarWidget(
                              selectionMode: CalendarSelectionMode.single,
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
                                      initialValue: TimeOfDay.now(),
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
    var result = await MissionRepository.get().changeMissionDatetime(
      ChangeMissionDatetimeRequest(
        missionId: mission.id,
        plannedStart: plannedStart,
        plannedEnd: plannedEnd,
        reason: reason,
      ),
      loadingMessage: 'loading_change_mission_datetime'.tr,
    );

    Get.back();

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
            bottom: MediaQuery
                .of(context)
                .viewInsets
                .bottom + MediaQuery
                .of(context)
                .padding
                .bottom,
            left: 16,
            right: 16,
            top: 20,
          ),
          child: StatefulBuilder(
            builder: (context, setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('cancel_mission'.tr, style: Theme
                      .of(context)
                      .textTheme
                      .headlineMedium),
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
                        child: Text(cmt.title, style: Theme
                            .of(context)
                            .textTheme
                            .labelMedium),
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
    var result = await MissionRepository.get().cancelMission(
      CancelMissionRequest(missionId: mission.id, reason: reason),
      loadingMessage: 'loading_cancel_mission'.tr,
    );

    Get.back();

    result.fold(
          (error) {
        snackError(message: error.message);
      },
          (response) {
        snackSuccess(message: response.message);

        //todo: what todo?
      },
    );
  }

//</editor-fold>
}
