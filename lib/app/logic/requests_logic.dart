import 'package:digi_care_pro/app/data/api/api_models/cancel_day_off.dart';
import 'package:digi_care_pro/app/data/api/api_models/get_day_off.dart';
import 'package:digi_care_pro/app/data/models/day_off.dart';
import 'package:digi_care_pro/app/data/repositories/employee_repository.dart';
import 'package:digi_care_pro/app/ui/widgets/snack.dart';
import 'package:digi_care_pro/app/utils/dialog_handler.dart';
import 'package:get/get.dart';

class RequestsLogic extends GetxController {
  List<DayOff> requests = [];

  List<String> months = [];
  String? selectedMonth;

  @override
  void onReady() {
    super.onReady();

    _getMonths();
  }

  _getMonths() async {
    var result = await EmployeeRepository.get().getDayOffMonths();

    result.fold(
          (error) {
        snackError(message: error.message);
      },
          (response) async {
        months = response.data ?? [];

        if (months.isNotEmpty) {
          selectedMonth = months[0];

          getRequests();
        }

        update();
      },
    );
  }

  getRequests() async {
    DialogHandler.showLoading('loading_get_requests'.tr);

    var result = await EmployeeRepository.get().getDayOffs(
      GetDayOffRequest(month: selectedMonth!),
    );

    DialogHandler.hideLoading();

    result.fold(
      (error) {
        snackError(message: error.message);
      },
      (response) {
        requests = response.data!;

        update();
      },
    );
  }

  cancelRequest(String id) async {
    DialogHandler.showLoading('loading_cancel_request'.tr);

    var result = await EmployeeRepository.get().cancelDayOff(
      CancelDayOffRequest(id: id),
    );

    DialogHandler.hideLoading();

    result.fold(
      (error) {
        snackError(message: error.message);
      },
      (response) {
        snackSuccess(message: response.message);

        getRequests();
      },
    );
  }
}
