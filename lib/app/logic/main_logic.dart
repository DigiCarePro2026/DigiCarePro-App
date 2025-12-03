import 'package:digi_care_pro/app/data/models/customer.dart';
import 'package:digi_care_pro/app/data/repositories/employee_repository.dart';
import 'package:get/get.dart';

class MainLogic extends GetxController{

  List<Customer> employeeCustomers = [];
  int unSeenMessageCount = 0;

  @override
  Future<void> onReady() async {
    await _getEmployeeCustomers();

    super.onReady();
  }

  Future<void> _getEmployeeCustomers() async {
    var result = await EmployeeRepository.get().getCustomers();

    result.fold((error){

    }, (response){
      employeeCustomers = response.data!;

      update();
    });
  }
}