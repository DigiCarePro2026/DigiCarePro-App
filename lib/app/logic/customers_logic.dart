import 'dart:async';

import 'package:digi_care_pro/app/data/enum/page_status.dart';
import 'package:digi_care_pro/app/data/models/customer.dart';
import 'package:digi_care_pro/app/data/models/paging_model.dart';
import 'package:digi_care_pro/app/data/repositories/customer_repository.dart';
import 'package:digi_care_pro/app/ui/widgets/snack.dart';
import 'package:get/get.dart';

class CustomersLogic extends GetxController {
  PageStatus pageStatus = PageStatus.loading;
  PagingModel paging = PagingModel(page: 1, pageSize: 50);
  String? searchKeyword;
  List<Customer> customers = [];

  @override
  void onReady() {
    super.onReady();
    getCustomers();
  }

  Timer? _debounce;

  void onSearchChanged(String term) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();

    _debounce = Timer(const Duration(seconds: 1), () {
      searchKeyword = term;

      pageStatus = PageStatus.loading;
      customers.clear();
      update();
      getCustomers();
    });
  }

  Future<void> getCustomers() async {
    var result = await CustomerRepository.get().getCustomers(keyword: searchKeyword, pagingModel: paging);

    result.fold(
      (error) {
        pageStatus = PageStatus.error;
        snackError(message: error.message);
        update();
      },
      (response) {
        // paging = response.data!.pagingModel;
        customers.addAll(response.data!.customers);

        pageStatus = customers.isEmpty ? PageStatus.empty : PageStatus.loaded;

        update();
      },
    );
  }
}
