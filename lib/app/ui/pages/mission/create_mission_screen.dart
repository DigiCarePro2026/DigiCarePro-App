import 'package:digi_care_pro/app/ui/theme/app_dimens.dart';
import 'package:digi_care_pro/app/ui/widgets/calendar_widget.dart';
import 'package:digi_care_pro/app/ui/widgets/delay_time_picker.dart';
import 'package:digi_care_pro/app/ui/widgets/primary_button.dart';
import 'package:digi_care_pro/app/ui/widgets/time_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CreateMissionScreen extends StatefulWidget {
  const CreateMissionScreen({super.key});

  @override
  State<CreateMissionScreen> createState() => _CreateMissionScreenState();
}

class _CreateMissionScreenState extends State<CreateMissionScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('create_mission'.tr)),
      body: Padding(
        padding: const EdgeInsets.all(bodyPadding),
        child: Column(
          children: [
            CalendarWidget(
              selectionMode: CalendarSelectionMode.single,
              minDate: DateTime.now().subtract(const Duration(days: 1)),
            ),
            SizedBox(height: fieldSpace),
            Row(
              children: [
                Expanded(flex:1,child: Center(child: TimePickerField(title: 'start'.tr))),
                Expanded(flex:1, child: Center(child: TimePickerField(title: 'end'.tr))),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.only(
          left: bodyPadding,
          right: bodyPadding,
          bottom: bodyPadding + MediaQuery.of(context).padding.bottom,
        ),
        child: PrimaryButton(
          label: 'submit_mission'.tr,
          onPressed: () {

          },
        ),
      ),
    );
  }
}
