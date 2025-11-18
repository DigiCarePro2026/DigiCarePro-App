import 'dart:math';

import 'package:dartz/dartz.dart';
import 'package:digi_care_pro/app/data/api/api_models/app_response.dart';
import 'package:digi_care_pro/app/data/constants/pref_key.dart';
import 'package:digi_care_pro/app/data/models/api_error.dart';
import 'package:digi_care_pro/app/data/pref.dart';
import 'package:digi_care_pro/app/routes/app_routes.dart';
import 'package:digi_care_pro/app/ui/widgets/primary_button.dart';
import 'package:digi_care_pro/app/ui/widgets/secondary_button.dart';
import 'package:digi_care_pro/app/ui/widgets/snack.dart';
import 'package:digi_care_pro/app/utils/globals.dart';
import 'package:digi_care_pro/app/utils/dialog_handler.dart';
import 'package:digi_care_pro/app/utils/utils.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' as getX;

import 'api_models/login.dart';

class ApiProvider {
  var dio = Dio(
    BaseOptions(
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
      baseUrl: 'https://mobileapi.demostage.ir/api',
    ),
  );

  static final ApiProvider _instance = ApiProvider._();

  factory ApiProvider() => _instance;

  int _requestCount = 0;
  String? loadingMessage;

  ApiProvider._() {
    // dio.options.headers['locale'] = 'fa';

    final token = Pref.getString(PrefKey.accessToken);
    if (token != null) {
      dio.options.headers['Authorization'] = 'Bearer $token';
    }

    _addInterceptors();
  }

  setToken(token) {
    dio.options.headers['Authorization'] = 'Bearer $token';
  }

  _addInterceptors() {
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          _requestCount++;

          if (_requestCount == 1) {
            _showLoading(loadingMessage ?? 'loading_default_message'.tr);
          }

      /*    bool netAvailable = await isNetworkAvailable();

          if (netAvailable) {
            logger.i('onRequest: ${options.path}\n${options.data.toString()}');

            return handler.next(options);
          } else {
            getX.Get.back();
            showOfflineBottomSheet();
          }*/

          return handler.next(options);
        },
        onResponse: (response, handler) {
          _requestCount--;

          if (_requestCount <= 0) {
            _requestCount = 0;
            _hideLoading();
          }

          logger.i('onResponse : ${response.data.toString().substring(0, min(response.data.toString().length-1, 300))}');

          return handler.next(response);
        },
        onError: (error, handler) {
          _requestCount--;

          if (_requestCount <= 0) {
            _requestCount = 0;
            _hideLoading();
          }

          logger.e('Error occurred: ${error.message}');

          return handler.next(error); // Continue to the next interceptor or error
        },
      ),
    );
  }

  void _showLoading(String message) {
    Future.microtask(() {
      if (!getX.Get.isDialogOpen!) {
        DialogHandler.showLoading(message);
      }
    });
  }

  void _hideLoading() {
    Future.microtask(() {
      if (getX.Get.isDialogOpen!) {
        getX.Get.back(); // Safe close
      }
    });
  }

  Future<Either<ApiError, AppResponse<T>>> get<T>({
    required String path,
    Map<String, dynamic>? headers,
    dynamic body,
    dynamic queryParameters,
    required T Function(dynamic) fromJson,
    String? loadingMessage,
  }) async {
    this.loadingMessage = loadingMessage;

    try {
      Response response = await dio.get(
        path,
        data: body,
        queryParameters: queryParameters,
        options: Options(headers: headers),
      );
      return _handleResponse(response, fromJson);
    } catch (e) {
      return _handleError(e);
    }
  }

  Future<Either<ApiError, AppResponse<T>>> post<T>({
    required String path,
    Map<String, dynamic>? headers,
    required dynamic body,
    T Function(dynamic)? fromJson,
    String? loadingMessage,
  }) async {
    this.loadingMessage = loadingMessage;

    try {
      Response response = await dio.post(
        path,
        data: body,
        options: Options(headers: headers),
      );

      return _handleResponse(response, fromJson);
    } catch (e) {
      return _handleError(e);
    }
  }

  Future<Either<ApiError, AppResponse<T>>> put<T>({
    required String path,
    Map<String, dynamic>? headers,
    required dynamic body,
    T Function(dynamic)? fromJson,
    String? loadingMessage,
  }) async {
    this.loadingMessage = loadingMessage;

    try {
      Response response = await dio.put(
        path,
        data: body,
        options: Options(headers: headers),
      );

      return _handleResponse(response, fromJson);
    } catch (e) {
      return _handleError(e);
    }
  }

  Future<Either<ApiError, AppResponse<T>>> patch<T>({
    required String path,
    Map<String, dynamic>? headers,
    int? pathParameter,
    required dynamic body,
    T Function(dynamic)? fromJson,
  }) async {
    try {
      Response response = await dio.patch(
        '$path${pathParameter == null ? '' : '/'}${pathParameter ?? ''}',
        data: body,
        options: Options(headers: headers),
      );
      return _handleResponse(response, fromJson);
    } catch (e) {
      return _handleError(e);
    }
  }

  Future<Either<ApiError, AppResponse<T>>> delete<T>({
    required String path,
    Map<String, dynamic>? headers,
    T Function(dynamic)? fromJson,
    String? loadingMessage,
  }) async {
    this.loadingMessage = loadingMessage;

    try {
      Response response = await dio.delete(path, options: Options(headers: headers));

      return _handleResponse(response, fromJson);
    } catch (e) {
      return _handleError(e);
    }
  }

  Future<Either<ApiError, AppResponse<T>>> _handleResponse<T>(Response response, T Function(dynamic)? fromJson) async {
    if (!response.data['isSuccess']) {
      return Left(ApiError(code: response.statusCode!, message: response.data['message']));
    }

    T? data;

    if (fromJson != null) {
      if (response.data['data'] != null) {
        data = fromJson(response.data['data']);
      }
    } else {
      data = response.data['data'] as T;
    }

    return Right(AppResponse(data: data, message: response.data['message']));
  }

  Future<Either<ApiError, T>> _handleError<T>(dynamic e) async {
    if (e is DioError && e.response != null) {
      switch (e.response!.statusCode) {
        case 401:
          logger.e('Unauthorized error, call refreshToken...');

          refreshToken();
          break;

        case 403:
          // show403Dialog(message: e.response!.data['message']);
          break;

        case 500:
          // snackError(message: 'Server error 500');

          ApiError error = ApiError(code: e.response!.statusCode!, message: 'Server error 500');
          return Left(error);

        case 503:
          logger.i('server is offline');

          // getX.Get.offAll(OfflineServerScreen());
          break;
      }

      ApiError error = ApiError(code: e.response!.statusCode!, message: e.response!.data ['message']);
      return Left(error);
    } else {
      // Handle other types of errors if needed
      return Left(ApiError(code: 0, message: 'Failed to complete request: $e'));
    }
  }

  refreshToken() async {
    final refreshToken = Pref.getString(PrefKey.refreshToken);

    var result = await post<LoginResponse>(
      path: '/auth/refresh-token',
      body: {'refreshToken': refreshToken},
      fromJson: (json) => LoginResponse.fromJson(json),
    );

    result.fold(
      (error) {
        if (error.code == 401) {
          Pref.setString(PrefKey.accessToken, null);
          Pref.setString(PrefKey.refreshToken, null);

          snackError(message: 'refresh_token_401_message'.tr);
          getX.Get.offAllNamed(Routes.LOGIN);
        } else {
          logger.i('refreshToken error(not 401) : ${error.message}');
        }
      },
      (response) {
        logger.i('refreshToken success : ${response.message}');
      },
    );
  }

  bool _isBottomSheetOpen = false;

  Future<void> showOfflineBottomSheet() async {
    if (_isBottomSheetOpen) return;

    _isBottomSheetOpen = true;

    return await showModalBottomSheet<void>(
      context: getX.Get.context!,
      isScrollControlled: true,
      useSafeArea: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom + MediaQuery.of(context).padding.bottom,
            left: 16,
            right: 16,
            top: 20,
          ),
          child: StatefulBuilder(
            builder: (context, setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('offline'.tr, style: Theme.of(context).textTheme.headlineMedium),
                  const SizedBox(height: 16),
                  Text(
                    'You are offline, please check device connection'.tr,
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: SecondaryButton(
                          label: 'cancel'.tr,
                          onPressed: () {
                            _isBottomSheetOpen = false;

                            Navigator.pop(context, null);
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: PrimaryButton(
                          label: 'try_again'.tr,
                          onPressed: () {
                            _isBottomSheetOpen = false;
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                ],
              );
            },
          ),
        );
      },
    );
  }
}
