import 'dart:math';

import 'package:digi_care_pro/app/logic/create_mission_logic.dart';
import 'package:digi_care_pro/app/logic/missions_logic.dart';
import 'package:digi_care_pro/app/ui/theme/app_dimens.dart';
import 'package:digi_care_pro/app/ui/widgets/app_text_area_field.dart';
import 'package:digi_care_pro/app/ui/widgets/calendar_widget.dart';
import 'package:digi_care_pro/app/ui/widgets/primary_button.dart';
import 'package:digi_care_pro/app/ui/widgets/time_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CreateMissionScreen extends StatefulWidget {
  const CreateMissionScreen({super.key, required this.customerId});

  final String customerId;

  @override
  State<CreateMissionScreen> createState() => _CreateMissionScreenState();
}

class _CreateMissionScreenState extends State<CreateMissionScreen> {
  late CreateMissionLogic logic;

  String? selectedDate;
  TimeOfDay startTime = TimeOfDay.now().replacing(
    hour: TimeOfDay.now().hour,
    minute: ((TimeOfDay.now().minute) / 15).toInt() * 15,
  );
  TimeOfDay endTime = TimeOfDay.now().replacing(
    hour: min(TimeOfDay.now().hour + 2, 23),
    minute: TimeOfDay.now().hour == 23 ? 55 : 0,
  );
  TextEditingController descController = TextEditingController();

  @override
  void initState() {
    logic = CreateMissionLogic(widget.customerId);

    Get.put(logic);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CreateMissionLogic>(
      builder: (logic) {
        return Scaffold(
          appBar: AppBar(title: Text('create_mission'.tr)),
          body: Padding(
            padding: const EdgeInsets.all(bodyPadding),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  CalendarWidget(
                    selectionMode: CalendarSelectionMode.single,
                    minDate: DateTime.now().subtract(const Duration(days: 1)),
                    onDateSelected: (date, isChangedMonth) {
                      setState(() {
                        if (!isChangedMonth) {
                          if(date != null) {
                            selectedDate = date.toIso8601String();
                          }
                        }
                      });
                    },
                  ),
                  SizedBox(height: fieldSpace),
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
                  SizedBox(height: 32),
                  AppTextAreaField(title: 'description'.tr, controller: descController),
                ],
              ),
            ),
          ),
          bottomNavigationBar: Padding(
            padding: EdgeInsets.only(
              left: bodyPadding,
              right: bodyPadding,
              bottom: bodyPadding + MediaQuery.of(context).padding.bottom,
            ),
            child: PrimaryButton(
              enabled: selectedDate != null,
              label: 'submit_mission'.tr,
              onPressed: () {
                logic.createMission(
                  date: selectedDate!,
                  startTime:
                      '${startTime.hour.toString().padLeft(2, '0')}:${startTime.minute.toString().padLeft(2, '0')}:00',
                  endTime: '${endTime.hour.toString().padLeft(2, '0')}:${endTime.minute.toString().padLeft(2, '0')}:00',
                  comment: descController.text,
                );
              },
            ),
          ),
        );
      },
    );
  }
}
