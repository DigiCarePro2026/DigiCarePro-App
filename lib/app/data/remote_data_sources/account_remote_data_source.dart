import 'package:dartz/dartz.dart';
import 'package:digi_care_pro/app/data/api/api_models/login.dart';
import 'package:digi_care_pro/app/data/models/api_error.dart';
import 'package:digi_care_pro/app/data/remote_data_sources/base_remote_data_source.dart';

class AccountRemoteDataSource extends BaseRemoteDataSource {

  static AccountRemoteDataSource? _instance;

  static AccountRemoteDataSource get() {
    _instance ??= AccountRemoteDataSource();

    return _instance!;
  }

  Future<Either<ApiError,LoginResponse>> login(LoginRequest request) async =>
      api.post<LoginResponse>(path: '/auth/login', body: request.toJson());
}
