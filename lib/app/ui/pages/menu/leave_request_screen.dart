import 'package:digi_care_pro/app/data/enum/leave_type.dart';
import 'package:digi_care_pro/app/ui/theme/app_dimens.dart';
import 'package:digi_care_pro/app/ui/widgets/app_dropdown_field.dart';
import 'package:digi_care_pro/app/ui/widgets/app_text_area_field.dart';
import 'package:digi_care_pro/app/ui/widgets/calendar_widget.dart';
import 'package:digi_care_pro/app/ui/widgets/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LeaveRequestScreen extends StatefulWidget {
  const LeaveRequestScreen({super.key});

  @override
  State<LeaveRequestScreen> createState() => _LeaveRequestScreenState();
}

class _LeaveRequestScreenState extends State<LeaveRequestScreen> {

  final TextEditingController descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('leave_request'.tr), centerTitle: true),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(bodyPadding/2),
          child: Column(
            children: [
              CalendarWidget(
                selectionMode: CalendarSelectionMode.range,
                onRangeSelected: (start, end) {
                  print("Range selected: $start → $end");
                },
              ),
              SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.all(bodyPadding),
                child: AppDropdownField<LeaveType>(
                  title: 'reason'.tr,
                  value: LeaveType.personal,
                  onChanged: (value) {},
                  items: LeaveType.values.map(
                    (lt) => DropdownMenuItem<LeaveType>(
                      value: lt,
                      child: Text(lt.title),
                    ),
                  ).toList(),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(bodyPadding),
                child: AppTextAreaField(
                  title: 'description'.tr,
                  hint: 'leave_request_description_hint'.tr,
                  controller: descriptionController,
                  onChanged: (value) {
                    print(value);
                  },
                ),
              ),
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
          label: 'submit_request'.tr,
          onPressed: () {
            // TODO: Handle password change logic
          },
        ),
      ),
    );
  }
}
