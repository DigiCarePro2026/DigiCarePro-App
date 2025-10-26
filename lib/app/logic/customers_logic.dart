import 'package:digi_care_pro/app/data/models/customer.dart';
import 'package:digi_care_pro/app/data/repositories/customer_repository.dart';
import 'package:digi_care_pro/app/data/repositories/employee_repository.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class CustomersLogic extends GetxController{

  List<Customer> customers = [];

  @override
  Future<void> onInit() async {

   await getCustomers();

    super.onInit();
  }

  Future<void> getCustomers() async {
    var result = await CustomerRepository.get().getCustomers();

    result.fold((error){}, (response){
      customers = response.data!.customers;

      update();
    });
  }

  makeCall(String phoneNumber) async {
    final Uri launchUri = Uri(scheme: 'tel', path: phoneNumber);
    await launchUrl(launchUri);
  }
}