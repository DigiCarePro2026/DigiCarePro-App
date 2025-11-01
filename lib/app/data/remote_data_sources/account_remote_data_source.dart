import 'package:dartz/dartz.dart';
import 'package:digi_care_pro/app/data/api/api_models/app_response.dart';
import 'package:digi_care_pro/app/data/api/api_models/change_password.dart';
import 'package:digi_care_pro/app/data/api/api_models/forget_password.dart';
import 'package:digi_care_pro/app/data/api/api_models/get_profile.dart';
import 'package:digi_care_pro/app/data/api/api_models/login.dart';
import 'package:digi_care_pro/app/data/api/api_models/reset_password.dart';
import 'package:digi_care_pro/app/data/models/api_error.dart';
import 'package:digi_care_pro/app/data/remote_data_sources/base_remote_data_source.dart';

class AccountRemoteDataSource extends BaseRemoteDataSource {
  static AccountRemoteDataSource? _instance;

  static AccountRemoteDataSource get() {
    _instance ??= AccountRemoteDataSource();

    return _instance!;
  }

  Future<Either<ApiError, AppResponse<LoginResponse>>> login(LoginRequest request, {String? loadingMessage}) async =>
      api.post<LoginResponse>(
        path: '/auth/login',
        body: request.toJson(),
        loadingMessage: loadingMessage,
        fromJson: (json) => LoginResponse.fromJson(json),
      );

  Future<Either<ApiError, AppResponse<GetProfileResponse>>> getProfile({String? loadingMessage}) async =>
      api.get<GetProfileResponse>(
        path: '/auth/get-profile',
        loadingMessage: loadingMessage,
        fromJson: (json) => GetProfileResponse.fromJson(json),
      );

  Future<Either<ApiError, AppResponse>> forgetPassword(ForgetPasswordRequest request, {String? loadingMessage}) async =>
      api.post(path: '/auth/forgot-password', body: request.toJson(), loadingMessage: loadingMessage);

  Future<Either<ApiError, AppResponse>> resetPassword(ResetPasswordRequest request, {String? loadingMessage}) async =>
      api.post(path: '/auth/reset-password', body: request.toJson(), loadingMessage: loadingMessage);

  Future<Either<ApiError, AppResponse>> changePassword(ChangePasswordRequest request, {String? loadingMessage}) =>
      api.post(path: '/user/change-password', body: request.toJson(), loadingMessage: loadingMessage);
}
