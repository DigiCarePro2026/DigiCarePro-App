import 'package:digi_care_pro/app/data/api/api_models/get_day_off.dart';
import 'package:digi_care_pro/app/data/models/day_off.dart';
import 'package:digi_care_pro/app/data/repositories/employee_repository.dart';
import 'package:digi_care_pro/app/ui/widgets/snack.dart';
import 'package:get/get.dart';

class RequestsLogic extends GetxController {
  List<DayOff> requests = [];

  @override
  void onReady() {
    super.onReady();
    _getRequests();
  }

  _getRequests() async {
    var result = await EmployeeRepository.get().getDayOffs(
      GetDayOffRequest(month: DateTime.now().toIso8601String()),
      loadingMessage: 'loading_get_requests'.tr,
    );

    Get.back();

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
}
