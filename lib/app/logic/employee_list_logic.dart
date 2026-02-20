import 'package:digi_care_pro/app/data/enum/page_status.dart';
import 'package:digi_care_pro/app/data/models/support_employee.dart';
import 'package:digi_care_pro/app/data/repositories/employee_repository.dart';
import 'package:digi_care_pro/app/ui/widgets/snack.dart';
import 'package:get/get.dart';

class EmployeeListLogic extends GetxController {

  PageStatus pageStatus = PageStatus.loading;
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
        pageStatus = PageStatus.error;
        snackError(message: error.message);
        update();
      },
      (response) {
        employees = response.data!;

        pageStatus = employees.isEmpty ? PageStatus.empty : PageStatus.loaded;

        update();
      },
    );
  }
}
