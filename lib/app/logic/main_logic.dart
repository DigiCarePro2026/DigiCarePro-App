import 'package:digi_care_pro/app/data/models/customer.dart';
import 'package:digi_care_pro/app/data/repositories/employee_repository.dart';
import 'package:digi_care_pro/app/data/repositories/notification_repository.dart';
import 'package:get/get.dart';

class MainLogic extends GetxController{

  List<Customer> employeeCustomers = [];
  int unSeenMessageCount = 0;
  int selectedPage = 1;

  @override
  Future<void> onReady() async {
    await _getEmployeeCustomers();

    getUnreadMessagesCount();

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

  getUnreadMessagesCount() async {
    var result = await NotificationRepository.get().getUnreadMessagesCount();

    result.fold((error){}, (response){
      unSeenMessageCount = response.data ?? 0;

      update();
    });
  }

  void decrementUnreadMessageCount() {
    if (unSeenMessageCount <= 0) {
      return;
    }

    unSeenMessageCount--;
    update();
  }

  void incrementUnreadMessageCount() {
    unSeenMessageCount++;
    update();
  }

  void setSelectedPage(int index) {
    if (selectedPage == index) return;
    selectedPage = index;
    update();
  }
}
