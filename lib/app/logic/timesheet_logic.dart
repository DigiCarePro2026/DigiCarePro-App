import 'package:digi_care_pro/app/data/api/api_models/get-timesheet.dart';
import 'package:digi_care_pro/app/data/models/timesheet_record.dart';
import 'package:digi_care_pro/app/data/repositories/employee_repository.dart';
import 'package:digi_care_pro/app/ui/widgets/snack.dart';
import 'package:get/get.dart';

class TimeSheetLogic extends GetxController {

  List<String> months = [];
  List<TimesheetRecord> records = [];

  @override
  void onReady() {
    _getMonths();

    super.onReady();
  }

  _getMonths() async {
    var result = await EmployeeRepository.get().getTimesheetMonths();

    result.fold((error) {
      snackError(message: error.message);
    }, (response) {
      months = response.data ?? [];

      getTimesheet();

      update();
    });
  }

  getTimesheet() async {
    var result = await EmployeeRepository.get().getTimesheet(GetTimesheetRequest(month: '2025-11-01'));

    result.fold((error) {
      snackError(message: error.message);
    }, (response) {
      records = response.data!;

      update();
    });
  }
}
