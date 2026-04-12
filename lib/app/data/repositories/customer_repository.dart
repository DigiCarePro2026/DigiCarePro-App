import 'package:dartz/dartz.dart';
import 'package:digi_care_pro/app/data/api/api_models/app_response.dart';
import 'package:digi_care_pro/app/data/api/api_models/get_customers.dart';
import 'package:digi_care_pro/app/data/models/api_error.dart';
import 'package:digi_care_pro/app/data/models/customer.dart';
import 'package:digi_care_pro/app/data/models/paging_model.dart';
import 'package:digi_care_pro/app/data/remote_data_sources/customer_remote_data_source.dart';
import 'package:digi_care_pro/app/data/remote_data_sources/employee_remote_data_source.dart';

class CustomerRepository {
  static CustomerRepository? _instance;

  static CustomerRepository get() {
    _instance ??= CustomerRepository();

    return _instance!;
  }

  Future<Either<ApiError, AppResponse<GetCustomersResponse>>> getCustomers({
    String? keyword,
    required PagingModel pagingModel,
    String? loadingMessage,
  }) async => CustomerRemoteDataSource.get().getCustomers(keyword:keyword, pagingModel: pagingModel, loadingMessage: loadingMessage);
}
