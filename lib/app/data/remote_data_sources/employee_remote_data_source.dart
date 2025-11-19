import 'package:dartz/dartz.dart';
import 'package:digi_care_pro/app/data/api/api_models/app_response.dart';
import 'package:digi_care_pro/app/data/api/api_models/cancel_day_off.dart';
import 'package:digi_care_pro/app/data/api/api_models/get-timesheet.dart';
import 'package:digi_care_pro/app/data/api/api_models/get_day_off.dart';
import 'package:digi_care_pro/app/data/models/api_error.dart';
import 'package:digi_care_pro/app/data/models/change_settings.dart';
import 'package:digi_care_pro/app/data/models/customer.dart';
import 'package:digi_care_pro/app/data/models/day_off.dart';
import 'package:digi_care_pro/app/data/models/employee.dart';
import 'package:digi_care_pro/app/data/api/api_models/request_day_off.dart';
import 'package:digi_care_pro/app/data/models/support_employee.dart';
import 'package:digi_care_pro/app/data/models/timesheet_record.dart';
import 'package:digi_care_pro/app/data/remote_data_sources/base_remote_data_source.dart';

class EmployeeRemoteDataSource extends BaseRemoteDataSource {
  static EmployeeRemoteDataSource? _instance;

  static EmployeeRemoteDataSource get() {
    _instance ??= EmployeeRemoteDataSource();

    return _instance!;
  }

  Future<Either<ApiError, AppResponse<Employee>>> getEmployeeProfile({String? loadingMessage}) async =>
      api.get<Employee>(
        path: '/employee/get',
        fromJson: (json) => Employee.fromJson(json),
        loadingMessage: loadingMessage,
      );

  Future<Either<ApiError, AppResponse<List<Customer>>>> getCustomers() => api.get<List<Customer>>(
    path: '/employee/customers',
    fromJson: (json) => (json as List).map((json) => Customer.fromJson(json)).toList(),
  );

  Future<Either<ApiError, AppResponse<List<SupportEmployee>>>> getSupportEmployees({String? loadingMessage}) => api.get(
    path: '/employee/support-employees',
    loadingMessage: loadingMessage,
    fromJson: (json) => (json as List).map((json) => SupportEmployee.fromJson(json)).toList(),
  );

  Future<Either<ApiError, AppResponse<List<DayOff>>>> getListOfDayOff(
    GetDayOffRequest request, {
    String? loadingMessage,
  }) => api.get(
    path: '/employee/list-of-request-day-off',
    queryParameters: request.toJson(),
    loadingMessage: loadingMessage,
    fromJson: (json) => (json as List).map((json) => DayOff.fromJson(json)).toList(),
  );

  Future<Either<ApiError, AppResponse>> requestDayOff(RequestDayOffRequest request, {String? loadingMessage}) =>
      api.post(path: '/employee/request-day-off', body: request.toJson(), loadingMessage: loadingMessage);

  Future<Either<ApiError, AppResponse>> cancelDayOff(CancelDayOffRequest request, {String? loadingMessage}) =>
      api.delete(path: '/employee/cancel-day-off/${request.id}', loadingMessage: loadingMessage);

  Future<Either<ApiError, AppResponse>> changeSettings(ChangeSettingsRequest request, {String? loadingMessage}) =>
      api.put(path: '/employee/settings', body: request.toJson(), loadingMessage: loadingMessage);

  Future<Either<ApiError, AppResponse<List<String>>>> getTimesheetMonths({String? loadingMessage}) => api.get(
    path: '/employeeTimeSheet/months',
    fromJson: (json) => (json as List).map((json) => json as String).toList(),
  );

  Future<Either<ApiError, AppResponse<List<TimesheetRecord>>>> getTimeSheet(
    GetTimesheetRequest request, {
    String? loadingMessage,
  }) => api.get(
    path: '/employeeTimeSheet/monthly',
    queryParameters: request.toJson(),
    fromJson: (json) => (json as List).map((json) => TimesheetRecord.fromJson(json)).toList(),
  );
}
