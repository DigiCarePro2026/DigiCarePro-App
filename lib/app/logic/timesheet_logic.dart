import 'package:digi_care_pro/app/data/api/api_models/get-timesheet.dart';
import 'package:digi_care_pro/app/data/api/api_models/sign_timesheet.dart';
import 'package:digi_care_pro/app/data/models/timesheet_record.dart';
import 'package:digi_care_pro/app/data/models/timesheet_signature.dart';
import 'package:digi_care_pro/app/data/repositories/employee_repository.dart';
import 'package:digi_care_pro/app/ui/widgets/snack.dart';
import 'package:digi_care_pro/app/utils/dialog_handler.dart';
import 'package:get/get.dart';

class TimeSheetLogic extends GetxController {
  List<String> months = [];
  List<TimesheetRecord> records = [];
  TimesheetSignature? signatures;

  String? selectedMonth;

  @override
  void onReady() {
    _getMonths();

    super.onReady();
  }

  _getMonths() async {
    DialogHandler.showLoading('loading_default_message'.tr);

    var result = await EmployeeRepository.get().getTimesheetMonths();

    result.fold(
      (error) {
        snackError(message: error.message);
      },
      (response) async {
        months = response.data ?? [];

        if (months.isNotEmpty) {
          selectedMonth = months[0];

          await getTimesheet();
          getSignatures();
        }

        update();
      },
    );
  }

  getTimesheet() async {
    var result = await EmployeeRepository.get().getTimesheet(
      GetTimesheetRequest(month: selectedMonth!),
    );

    DialogHandler.hideLoading();

    result.fold(
      (error) {
        snackError(message: error.message);
      },
      (response) {
        records = response.data!;

        update();
      },
    );
  }

  getSignatures() async {
    var result = await EmployeeRepository.get().getTimesheetSignatures(
      GetTimesheetRequest(month: selectedMonth!),
    );

    result.fold(
      (error) {
        snackError(message: error.message);
      },
      (response) {
        signatures = response.data!;

        update();
      },
    );
  }

  uploadSign(List<int> byteData) async {
    var result = await EmployeeRepository.get().uploadSignature(
      SignTimesheetRequest(month: selectedMonth!, imageData: byteData),
      loadingMessage: 'Uploading signature',
    );

    result.fold(
      (error) {
        snackError(message: error.message);
      },
      (response) async {
        snackSuccess(message: response.message);

        await getTimesheet();
        getSignatures();
      },
    );
  }
}
