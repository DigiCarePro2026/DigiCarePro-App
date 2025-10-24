import 'package:dartz/dartz.dart';
import 'package:digi_care_pro/app/data/api/api_models/app_response.dart';
import 'package:digi_care_pro/app/data/models/api_error.dart';
import 'package:digi_care_pro/app/data/models/customer.dart';
import 'package:digi_care_pro/app/data/remote_data_sources/employee_remote_data_source.dart';

class EmployeeRepository {
  static EmployeeRepository? _instance;

  static EmployeeRepository get() {
    _instance ??= EmployeeRepository();

    return _instance!;
  }

  Future<Either<ApiError, AppResponse<List<Customer>>>> getCustomers() async =>
      EmployeeRemoteDataSource.get().getCustomers();
}
