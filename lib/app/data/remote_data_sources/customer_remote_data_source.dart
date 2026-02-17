import 'package:dartz/dartz.dart';
import 'package:digi_care_pro/app/data/api/api_models/app_response.dart';
import 'package:digi_care_pro/app/data/api/api_models/get_customers.dart';
import 'package:digi_care_pro/app/data/models/api_error.dart';
import 'package:digi_care_pro/app/data/models/customer.dart';
import 'package:digi_care_pro/app/data/models/paging_model.dart';
import 'package:digi_care_pro/app/data/remote_data_sources/base_remote_data_source.dart';

class CustomerRemoteDataSource extends BaseRemoteDataSource {
  static CustomerRemoteDataSource? _instance;

  static CustomerRemoteDataSource get() {
    _instance ??= CustomerRemoteDataSource();

    return _instance!;
  }

  Future<Either<ApiError, AppResponse<GetCustomersResponse>>> getCustomers({
    String? keyword,
    required PagingModel pagingModel,
    String? loadingMessage,
  }) async => api.get<GetCustomersResponse>(
    path: '/employee/customers',
    // queryParameters: {'page': pagingModel.page, 'pageSize': pagingModel.pageSize, 'keyword': keyword},
    loadingMessage: loadingMessage,
    fromJson: (json) => GetCustomersResponse.fromJson({'items' : json}),
  );
}
