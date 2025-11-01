import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:digi_care_pro/app/data/api/api_models/app_response.dart';
import 'package:digi_care_pro/app/data/api/api_models/change_password.dart';
import 'package:digi_care_pro/app/data/api/api_models/forget_password.dart';
import 'package:digi_care_pro/app/data/api/api_models/get_profile.dart';
import 'package:digi_care_pro/app/data/api/api_models/login.dart';
import 'package:digi_care_pro/app/data/api/api_models/reset_password.dart';
import 'package:digi_care_pro/app/data/constants/pref_key.dart';
import 'package:digi_care_pro/app/data/models/api_error.dart';
import 'package:digi_care_pro/app/data/models/profile.dart';
import 'package:digi_care_pro/app/data/pref.dart';
import 'package:digi_care_pro/app/data/remote_data_sources/account_remote_data_source.dart';

class AccountRepository {
  static AccountRepository? _instance;

  static AccountRepository get() {
    _instance ??= AccountRepository();

    return _instance!;
  }

  Future<Either<ApiError, AppResponse<LoginResponse>>> login(LoginRequest request, {String? loadingMessage}) async =>
      AccountRemoteDataSource.get().login(request, loadingMessage: loadingMessage);

  Future<Either<ApiError, AppResponse<GetProfileResponse>>> getProfile({String? loadingMessage}) async {
    return await AccountRemoteDataSource.get().getProfile(loadingMessage: loadingMessage);
  }

  Future<Either<ApiError, AppResponse>> forgetPassword(ForgetPasswordRequest request, {String? loadingMessage}) async =>
      AccountRemoteDataSource.get().forgetPassword(request, loadingMessage: loadingMessage);

  Future<Either<ApiError, AppResponse>> resetPassword(ResetPasswordRequest request, {String? loadingMessage}) async =>
      AccountRemoteDataSource.get().resetPassword(request, loadingMessage: loadingMessage);

  Future<Either<ApiError, AppResponse>> changePassword(ChangePasswordRequest request, {String? loadingMessage}) async =>
      AccountRemoteDataSource.get().changePassword(request, loadingMessage: loadingMessage);

  logout() {
    Pref.setString(PrefKey.accessToken, null);
    Pref.setString(PrefKey.refreshToken, null);
  }

  saveLoginInfo(LoginResponse loginResponse) {
    Pref.setString(PrefKey.accessToken, loginResponse.accessToken);
    Pref.setString(PrefKey.refreshToken, loginResponse.refreshToken);
  }

  saveProfileInfo(Profile profile) {
    Pref.setString(PrefKey.profile, jsonEncode(profile.toJson()));
  }

  Profile fetchProfile() {
    return Profile.fromJson(jsonDecode(Pref.getString(PrefKey.profile)!));
  }
}
