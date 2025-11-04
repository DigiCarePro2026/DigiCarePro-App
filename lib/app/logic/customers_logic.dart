import 'package:digi_care_pro/app/data/models/customer.dart';
import 'package:digi_care_pro/app/data/models/paging_model.dart';
import 'package:digi_care_pro/app/data/repositories/customer_repository.dart';
import 'package:digi_care_pro/app/data/repositories/employee_repository.dart';
import 'package:digi_care_pro/app/ui/widgets/snack.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class CustomersLogic extends GetxController {
  PagingModel paging = PagingModel(page: 1, pageSize: 50);
  List<Customer> customers = [];

  @override
  void onReady() {
    super.onReady();
    getCustomers();
  }

  Future<void> getCustomers() async {
    var result = await CustomerRepository.get().getCustomers(pagingModel: paging,);

    result.fold(
      (error) {
        snackError(message: error.message);
      },
      (response) {
        customers.addAll(response.data!.customers);

        update();
      },
    );
  }
}
