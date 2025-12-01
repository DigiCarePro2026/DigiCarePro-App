import 'dart:ui' as ui;

import 'package:digi_care_pro/app/data/models/timesheet_record.dart';
import 'package:digi_care_pro/app/logic/timesheet_logic.dart';
import 'package:digi_care_pro/app/ui/theme/app_dimens.dart';
import 'package:digi_care_pro/app/ui/widgets/app_dropdown_field.dart';
import 'package:digi_care_pro/app/ui/widgets/primary_button.dart';
import 'package:digi_care_pro/app/ui/widgets/secondary_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_signaturepad/signaturepad.dart';

class TimesheetScreen extends StatefulWidget {
  const TimesheetScreen({super.key});

  @override
  State<TimesheetScreen> createState() => _TimesheetScreenState();
}

class _TimesheetScreenState extends State<TimesheetScreen> {
  TimeSheetLogic logic = TimeSheetLogic();

  @override
  void initState() {
    Get.put(logic);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<TimeSheetLogic>(
      builder: (logic) {
        return Scaffold(
          appBar: AppBar(title: Text('timesheet'.tr)),
          body: Padding(
            padding: const EdgeInsets.all(bodyPadding),
            child: Column(
              children: [
                AppDropdownField<String>(
                  value: logic.selectedMonth ?? (logic.months.isEmpty ? '' : logic.months[0]),
                  title: 'timesheet_month_title'.tr,
                  items: logic.months.map((m) => DropdownMenuItem<String>(value: m, child: Text(m))).toList(),
                  onChanged: (item) {
                    logic.selectedMonth = item;

                    logic.getTimesheet();
                  },
                ),
                SizedBox(height: 12),
                SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Table(
                    border: TableBorder.all(color: Colors.grey.shade300),
                    columnWidths: const {
                      0: FlexColumnWidth(2), // Date
                      1: FlexColumnWidth(1.3), // Start
                      2: FlexColumnWidth(1.3), // End
                      3: FlexColumnWidth(1.3), // Total
                      4: FlexColumnWidth(1.3), // Work
                      5: FlexColumnWidth(1.3), // Pause
                    },
                    children: [_buildHeaderRow(), ...logic.records.map((r) => _buildDataRow(r))],
                  ),
                ),
                SizedBox(height: bodyPadding),
                if (logic.signatures != null)
                  Container(
                    decoration: BoxDecoration(border: BoxBorder.all(color: Theme.of(context).dividerColor, width: 1)),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: Container(
                            padding: EdgeInsets.all(12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('employee'.tr, style: Theme.of(context).textTheme.labelMedium),
                                SizedBox(height: 4),
                                Text(
                                  logic.signatures!.employeeSignDate ?? '',
                                  style: Theme.of(context).textTheme.titleSmall,
                                ),
                                SizedBox(height: fieldSpace),
                                Image.network(
                                  logic.signatures!.employeeSignaturePath ?? '',
                                  width: 150,
                                  height: 150,
                                  fit: BoxFit.cover,
                                  errorBuilder: (ctx, _, __) {
                                    return Container(
                                      width: 150,
                                      height: 150,
                                      /*color: Theme
                                        .of(context)
                                        .dividerColor,*/
                                      child: SecondaryButton(
                                        label: 'submit_sign'.tr,
                                        onPressed: () async {
                                          final signatureBytes = await showSignatureSheet(context);
                                          if (signatureBytes != null) {
                                            logic.uploadSign(signatureBytes);
                                          }
                                        },
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Container(
                            padding: EdgeInsets.all(12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('manager'.tr, style: Theme.of(context).textTheme.labelMedium),
                                SizedBox(height: 4),
                                Text(
                                  logic.signatures!.managerSignDate ?? '',
                                  style: Theme.of(context).textTheme.titleSmall,
                                ),
                                SizedBox(height: fieldSpace),
                                Image.network(
                                  logic.signatures!.managerSignaturePath ?? '',
                                  width: 150,
                                  height: 150,
                                  fit: BoxFit.cover,
                                  errorBuilder: (ctx, _, __) {
                                    return Container(width: 150, height: 150, color: Theme.of(context).dividerColor);
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  /// Header
  TableRow _buildHeaderRow() {
    return TableRow(
      decoration: const BoxDecoration(color: Color(0xFFECECEC)),
      children: const [
        _HeaderCell("Date"),
        _HeaderCell("Start"),
        _HeaderCell("End"),
        _HeaderCell("Total"),
        _HeaderCell("Work"),
        _HeaderCell("Pause"),
      ],
    );
  }

  /// Rows
  TableRow _buildDataRow(TimesheetRecord r) {
    return TableRow(
      children: [
        _Cell(r.date.substring(0, 10)),
        _Cell(r.startTime.substring(r.startTime.indexOf('T') + 1, r.startTime.indexOf('T') + 6)),
        _Cell(r.endTime.substring(r.endTime.indexOf('T') + 1, r.endTime.indexOf('T') + 6)),
        _Cell(r.totalTimeDisplay),
        _Cell(r.workTimeDisplay),
        _Cell(r.pauseTimeDisplay),
      ],
    );
  }

  Future<List<int>?> showSignatureSheet(BuildContext context) {
    final GlobalKey<SfSignaturePadState> signatureKey = GlobalKey();

    return showModalBottomSheet<List<int>>(
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
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('sign2'.tr, style: Theme.of(context).textTheme.headlineMedium),
              SizedBox(height: 16),
              Container(
                height: 250,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: SfSignaturePad(key: signatureKey, strokeColor: Colors.black),
              ),

              SizedBox(height: 16),

              Row(
                children: [
                  Expanded(
                    child: SecondaryButton(
                      label: 'clear'.tr,
                      onPressed: () {
                        signatureKey.currentState!.clear();
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: PrimaryButton(
                      label: 'submit'.tr,
                      onPressed: () async {
                        final pad = signatureKey.currentState!;
                        final img = await pad.toImage();
                        final data = await img.toByteData(format: ui.ImageByteFormat.png);

                        Navigator.pop(context, data!.buffer.asUint8List().toList());
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }
}

class _HeaderCell extends StatelessWidget {
  final String title;

  const _HeaderCell(this.title);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.bold),
        textAlign: TextAlign.center,
      ),
    );
  }
}

class _Cell extends StatelessWidget {
  final String text;

  const _Cell(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Text(text, textAlign: TextAlign.center),
    );
  }
}
