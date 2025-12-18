import 'package:digi_care_pro/app/data/models/employee.dart';
import 'package:digi_care_pro/app/data/repositories/employee_repository.dart';
import 'package:digi_care_pro/app/ui/widgets/snack.dart';
import 'package:digi_care_pro/app/utils/dialog_handler.dart';
import 'package:get/get.dart';

class EmployeeProfileLogic extends GetxController {
  Employee? employee;

  @override
  void onInit() {
    super.onInit();

    Future.delayed(Duration(milliseconds: 200),(){
      _getEmployeeProfile();
    });
  }

  _getEmployeeProfile() async {
    DialogHandler.showLoading('loading_profile'.tr);

    var result = await EmployeeRepository.get().getEmployeeProfile();

    DialogHandler.hideLoading();

    result.fold((error) {
      snackError(message: error.message);
    }, (response) {
      employee = response.data!;

      update();
    });
  }
}
