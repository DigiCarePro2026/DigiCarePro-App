import 'dart:core';

import 'package:digi_care_pro/app/data/models/customer.dart';
import 'package:digi_care_pro/app/data/models/paging_model.dart';

class GetCustomersResponse {
  final List<Customer> customers;
  final PagingModel? pagingModel;

  GetCustomersResponse({required this.customers, this.pagingModel});

  factory GetCustomersResponse.fromJson(Map<String, dynamic> json) =>
      GetCustomersResponse(
        customers: (json['items'] as List)
            .map((item) => Customer.fromJson(item))
            .toList(),
       /* pagingModel: PagingModel(
          page: json['page'],
          pageSize: json['pageSize'],
          totalCount: json['totalCount'],
        ),*/
      );
}
