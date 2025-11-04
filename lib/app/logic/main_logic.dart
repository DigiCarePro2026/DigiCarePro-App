import 'package:digi_care_pro/app/data/models/customer.dart';
import 'package:digi_care_pro/app/data/repositories/employee_repository.dart';
import 'package:get/get.dart';

class MainLogic extends GetxController{

  List<Customer> employeeCustomers = [];

  @override
  Future<void> onInit() async {
    super.onInit();

    await _getEmployeeCustomers();
  }

  Future<void> _getEmployeeCustomers() async {
    var result = await EmployeeRepository.get().getCustomers();

    Get.back();

    result.fold((error){

    }, (response){
      employeeCustomers = response.data!;

      update();
    });
  }
}