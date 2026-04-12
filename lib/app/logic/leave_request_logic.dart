import 'package:digi_care_pro/app/data/enum/leave_type.dart';
import 'package:digi_care_pro/app/data/api/api_models/request_day_off.dart';
import 'package:digi_care_pro/app/data/repositories/account_repository.dart';
import 'package:digi_care_pro/app/data/repositories/employee_repository.dart';
import 'package:digi_care_pro/app/ui/widgets/snack.dart';
import 'package:get/get.dart';

class LeaveRequestLogic extends GetxController {
  sendRequest({
    required String startDate,
    required String endDate,
    required LeaveType leaveType,
    String? description,
  }) async {
    var result = await EmployeeRepository.get().requestDayOff(
      RequestDayOffRequest(
        employeeId: AccountRepository.get().fetchProfile().employeeId,
        leaveTypeId: leaveType.code,
        startDate: startDate,
        endDate: endDate,
        description: description,
      ),
    );

    result.fold(
      (error) {
        snackError(message: error.message);
      },
      (response) {
        Get.back(result: true);

        snackSuccess(message: response.message);
      },
    );
  }
}
