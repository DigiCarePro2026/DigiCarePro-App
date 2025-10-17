import 'package:digi_care_pro/app/routes/app_routes.dart';
import 'package:digi_care_pro/app/ui/pages/mission/mission_details_screen.dart';
import 'package:digi_care_pro/app/ui/theme/app_colors.dart';
import 'package:digi_care_pro/app/ui/widgets/app_text_area_field.dart';
import 'package:digi_care_pro/app/ui/widgets/primary_button.dart';
import 'package:digi_care_pro/app/ui/widgets/secondary_button.dart';
import 'package:digi_care_pro/app/ui/widgets/time_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class MissionDetailsLogic extends GetxController {
  List<MenuModel> menuItems = [];

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
        callback: () => _route(),
      ),
      MenuModel(
        title: 'call'.tr,
        icon: 'assets/icons/call.svg',
        color: AppColors.callColor,
        callback: () => _makeCall('123'),
      ),
      MenuModel(
        title: 'upload_document'.tr,
        icon: 'assets/icons/upload.svg',
        color: AppColors.uploadColor,
      ),
      MenuModel(
        title: 'add_mission'.tr,
        icon: 'assets/icons/add-mission.svg',
        color: AppColors.addMissionColor,
      ),
      MenuModel(
        title: 'customer_signature'.tr,
        icon: 'assets/icons/signature.svg',
        color: AppColors.signatureColor,
        callback: (){
          Get.toNamed(Routes.MISSION_SIGNATURE);
        }
      ),
      MenuModel(
        title: 'submit_report'.tr,
        icon: 'assets/icons/report.svg',
        color: AppColors.reportColor,
        callback: () async {
          String? report = await showMissionReportBottomSheet();

          if (report != null) {
            debugPrint(report);//fixme: call api
          }
        }
      ),
      MenuModel(
        title: 'delay_report'.tr,
        icon: 'assets/icons/delay-report.svg',
        color: AppColors.delayReportColor,
        callback: () async {
          Duration? duration = await showDelayTimeBottomSheet();

          if (duration != null) {
            debugPrint(duration.inMinutes.toString());//fixme: call api
          }
        },
      ),
      MenuModel(
        title: 'change_date_time'.tr,
        icon: 'assets/icons/calendar-setting.svg',
        color: AppColors.delayReportColor,
      ),
      MenuModel(
        title: 'cancel_mission'.tr,
        icon: 'assets/icons/cancel.svg',
        color: AppColors.delayReportColor,
      ),
    ];
  }

  _route() async {
    final Uri googleMapsUri = Uri.parse(
      'https://www.google.com/maps/dir/?api=1&destination=35.6892,51.3890',
    );
    await launchUrl(googleMapsUri, mode: LaunchMode.externalApplication);
  }

  _makeCall(String phoneNumber) async {
    final Uri launchUri = Uri(scheme: 'tel', path: phoneNumber);
    await launchUrl(launchUri);
  }

  Future<Duration?> showDelayTimeBottomSheet({
    Duration? initialValue,
    bool showHours = true,
  }) async {
    Duration? selectedValue = initialValue;

    return await showModalBottomSheet<Duration>(
      context: Get.context!,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 16,
            right: 16,
            top: 20,
          ),
          child: StatefulBuilder(
            builder: (context, setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'delay_report_title'.tr,
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 16),
                  DelayTimePickerField(
                    title: '',
                    showHours: showHours,
                    initialValue: selectedValue,
                    onChanged: (value) {
                      setState(() => selectedValue = value);
                    },
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: SecondaryButton(
                          label: 'cancel'.tr,
                          onPressed: () => Navigator.pop(context, null),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: PrimaryButton(
                          label: 'confirm'.tr,
                          onPressed: () =>
                              Navigator.pop(context, selectedValue),
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

  Future<String?> showMissionReportBottomSheet({String? initialValue}) async{
    String? report = initialValue;

    return await showModalBottomSheet<String>(
      context: Get.context!,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 16,
            right: 16,
            top: 20,
          ),
          child: StatefulBuilder(
            builder: (context, setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'mission_report'.tr,
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 16),
                  AppTextAreaField(title: 'description'.tr,onChanged: (value){
                    setState(() => report = value);
                  },),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: SecondaryButton(
                          label: 'cancel'.tr,
                          onPressed: () => Navigator.pop(context, null),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: PrimaryButton(
                          label: 'confirm'.tr,
                          onPressed: () =>
                              Navigator.pop(context, report),
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
}
