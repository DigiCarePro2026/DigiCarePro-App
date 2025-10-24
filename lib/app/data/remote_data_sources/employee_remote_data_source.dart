import 'package:dartz/dartz.dart';
import 'package:digi_care_pro/app/data/api/api_models/app_response.dart';
import 'package:digi_care_pro/app/data/models/api_error.dart';
import 'package:digi_care_pro/app/data/models/customer.dart';
import 'package:digi_care_pro/app/data/remote_data_sources/base_remote_data_source.dart';

class EmployeeRemoteDataSource extends BaseRemoteDataSource {
  static EmployeeRemoteDataSource? _instance;

  static EmployeeRemoteDataSource get() {
    _instance ??= EmployeeRemoteDataSource();

    return _instance!;
  }

  Future<Either<ApiError, AppResponse<List<Customer>>>> getCustomers() async =>
      api.get<List<Customer>>(
        path: '/employee/customers',
        fromJson: (json) =>
            (json as List).map((json) => Customer.fromJson(json)).toList(),
      );
}
