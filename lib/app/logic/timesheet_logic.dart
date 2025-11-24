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

      if(months.isNotEmpty) {
        getTimesheet(months[0].substring(0, 10));
      }

      update();
    });
  }

  getTimesheet(String month) async {
    var result = await EmployeeRepository.get().getTimesheet(GetTimesheetRequest(month: month));

    result.fold((error) {
      snackError(message: error.message);
    }, (response) {
      records = response.data!;

      update();
    });
  }
}
