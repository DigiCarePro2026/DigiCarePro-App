import 'package:digi_care_pro/app/data/models/timesheet_record.dart';
import 'package:digi_care_pro/app/logic/timesheet_logic.dart';
import 'package:digi_care_pro/app/ui/theme/app_dimens.dart';
import 'package:digi_care_pro/app/ui/widgets/app_dropdown_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TimesheetScreen extends StatefulWidget {
  const TimesheetScreen({super.key});

  @override
  State<TimesheetScreen> createState() => _TimesheetScreenState();
}

class _TimesheetScreenState extends State<TimesheetScreen> {
  TimeSheetLogic logic = TimeSheetLogic();

  String? selectedMonth;

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
                  value: selectedMonth ?? (logic.months.isEmpty ? '' : logic.months[0]),
                  title: 'timesheet_month_title'.tr,
                  items: logic.months.map((m) => DropdownMenuItem<String>(value: m, child: Text(m))).toList(),
                  onChanged: (item) {
                    selectedMonth = item;
                  },
                ),
                SizedBox(height: 12),
                SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Table(
                    border: TableBorder.all(color: Colors.grey.shade300),
                    columnWidths: const {
                      0: FlexColumnWidth(1.5), // Date
                      1: FlexColumnWidth(1.3), // Start
                      2: FlexColumnWidth(1.3), // End
                      3: FlexColumnWidth(1.3), // Total
                      4: FlexColumnWidth(1.3), // Work
                      5: FlexColumnWidth(1.3), // Pause
                    },
                    children: [
                      _buildHeaderRow(),
                      ...logic.records.map((r) => _buildDataRow(r)),
                    ],
                  ),
                )
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
        _Cell(r.date.substring(0,10)),
        _Cell(r.startTime.substring(r.startTime.indexOf('T')+1, r.startTime.indexOf('T')+6)),
        _Cell(r.endTime.substring(r.endTime.indexOf('T')+1, r.endTime.indexOf('T')+6)),
        _Cell(r.totalTimeDisplay),
        _Cell(r.workTimeDisplay),
        _Cell(r.pauseTimeDisplay),
      ],
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
      child: Text(
        text,
        textAlign: TextAlign.center,
      ),
    );
  }
}
