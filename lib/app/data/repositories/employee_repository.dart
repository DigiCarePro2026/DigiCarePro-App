import 'package:dartz/dartz.dart';
import 'package:digi_care_pro/app/data/api/api_models/app_response.dart';
import 'package:digi_care_pro/app/data/models/api_error.dart';
import 'package:digi_care_pro/app/data/models/change_settings.dart';
import 'package:digi_care_pro/app/data/models/customer.dart';
import 'package:digi_care_pro/app/data/models/employee.dart';
import 'package:digi_care_pro/app/data/models/request_day_off.dart';
import 'package:digi_care_pro/app/data/models/support_employee.dart';
import 'package:digi_care_pro/app/data/remote_data_sources/employee_remote_data_source.dart';

class EmployeeRepository {
  static EmployeeRepository? _instance;

  static EmployeeRepository get() {
    _instance ??= EmployeeRepository();

    return _instance!;
  }

  Future<Either<ApiError, AppResponse<Employee>>> getEmployeeProfile({String? loadingMessage}) =>
      EmployeeRemoteDataSource.get().getEmployeeProfile(loadingMessage: loadingMessage);

  Future<Either<ApiError, AppResponse<List<Customer>>>> getCustomers() => EmployeeRemoteDataSource.get().getCustomers();

  Future<Either<ApiError, AppResponse<List<SupportEmployee>>>> getSupportEmployees( {String? loadingMessage}) =>
      EmployeeRemoteDataSource.get().getSupportEmployees(loadingMessage: loadingMessage);

  Future<Either<ApiError, AppResponse>> requestDayOff(RequestDayOffRequest request, {String? loadingMessage}) =>
      EmployeeRemoteDataSource.get().requestDayOff(request, loadingMessage: loadingMessage);

  Future<Either<ApiError, AppResponse>> changeSettings(ChangeSettingsRequest request, {String? loadingMessage}) =>
      EmployeeRemoteDataSource.get().changeSettings(request, loadingMessage: loadingMessage);
}
