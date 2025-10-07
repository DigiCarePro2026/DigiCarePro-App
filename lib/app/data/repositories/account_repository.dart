import 'package:dartz/dartz.dart';
import 'package:digi_care_pro/app/data/api/api_models/login.dart';
import 'package:digi_care_pro/app/data/models/api_error.dart';
import 'package:digi_care_pro/app/data/remote_data_sources/account_remote_data_source.dart';

class AccountRepository {

  static AccountRepository? _instance;

  static AccountRepository get() {
    _instance ??= AccountRepository();

    return _instance!;
  }

  Future<Either<ApiError, LoginResponse>> login(LoginRequest request) async => AccountRemoteDataSource.get().login(request);
}
