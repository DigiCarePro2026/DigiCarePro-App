import 'package:digi_care_pro/app/data/models/support_employee.dart';
import 'package:digi_care_pro/app/data/repositories/employee_repository.dart';
import 'package:digi_care_pro/app/ui/widgets/snack.dart';
import 'package:get/get.dart';

class EmployeeListLogic extends GetxController {
  List<SupportEmployee> employees = [];

  @override
  void onReady() {
    super.onReady();
    _getSupportEmployees();
  }

  _getSupportEmployees() async {
    var result = await EmployeeRepository.get().getSupportEmployees();

    result.fold(
      (error) {
        snackError(message: error.message);
      },
      (response) {
        employees = response.data!;

        update();
      },
    );
  }
}
