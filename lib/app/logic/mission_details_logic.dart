import 'package:digi_care_pro/app/data/api/api_models/cancel_mission.dart';
import 'package:digi_care_pro/app/data/api/api_models/delay_mission.dart';
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
import 'package:digi_care_pro/app/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class MissionDetailsLogic extends GetxController {
  late Mission mission;
  List<MenuModel> menuItems = [];

  MissionDetailsLogic(this.mission);

  @override
  void onInit() {
    _prepareMenuItems();

    super.onInit();
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
        callback: () => _makeCall(mission.customerPhone ?? ''),
      ),
      MenuModel(
        title: 'upload_document'.tr,
        icon: 'assets/icons/upload.svg',
        color: AppColors.uploadColor,
        callback: () {
          Get.toNamed(Routes.MISSION_UPLOAD_DOC);
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
          Get.toNamed(Routes.MISSION_SIGNATURE);
        },
      ),
      MenuModel(
        title: 'submit_report'.tr,
        icon: 'assets/icons/report.svg',
        color: AppColors.reportColor,
        callback: () async {
          String? report = await showMissionReportBottomSheet();

          if (report != null) {
            debugPrint(report); //fixme: call api
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

  _makeCall(String phoneNumber) async {
    final Uri launchUri = Uri(scheme: 'tel', path: phoneNumber);
    await launchUrl(launchUri);
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
    var result = await MissionRepository.get().delayReport(
      DelayMissionRequest(missionId: mission.id, delayMinutes: minutes),
      loadingMessage: 'loading_delay_mission'.tr,
    );

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

  Future<String?> showChangeDateAndTimeBottomSheet() async {
    String? result;

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
                  Text('change_date_time'.tr, style: Theme.of(context).textTheme.headlineMedium),
                  const SizedBox(height: 16),
                  Column(
                    children: [
                      CalendarWidget(selectionMode: CalendarSelectionMode.single),
                      DelayTimePickerField(
                        title: '',
                        showHours: true,
                        initialValue: null,
                        onChanged: (value) {
                          // setState(() => selectedValue = value);
                        },
                      ),
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
                        child: PrimaryButton(label: 'confirm'.tr, onPressed: () => Navigator.pop(context, result)),
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
    var result = await MissionRepository.get().cancelMission(
      CancelMissionRequest(missionId: mission.id, reason: reason),
      loadingMessage: 'loading_cancel_mission'.tr,
    );

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
