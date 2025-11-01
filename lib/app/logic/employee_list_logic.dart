import 'package:digi_care_pro/app/data/models/support_employee.dart';
import 'package:digi_care_pro/app/data/repositories/employee_repository.dart';
import 'package:digi_care_pro/app/ui/widgets/snack.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class EmployeeListLogic extends GetxController {
  List<SupportEmployee> employees = [];

  @override
  void onReady() {
    super.onReady();
    _getSupportEmployees();
  }

  _getSupportEmployees() async {
    var result = await EmployeeRepository.get().getSupportEmployees(loadingMessage: 'support_employees_loading'.tr);

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

  makeCall(String phoneNumber) async {
    final Uri launchUri = Uri(scheme: 'tel', path: phoneNumber);
    await launchUrl(launchUri);
  }
}
