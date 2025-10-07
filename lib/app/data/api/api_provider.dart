
import 'package:dartz/dartz.dart';
import 'package:digi_care_pro/app/data/models/api_error.dart';
import 'package:digi_care_pro/app/data/pref.dart';
import 'package:digi_care_pro/app/utils/globals.dart';
import 'package:digi_care_pro/app/utils/utils.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart' as getX;

class ApiProvider {
  var dio = Dio(
    BaseOptions(
      connectTimeout: const Duration(seconds: 5),
      receiveTimeout: const Duration(seconds: 5),
      baseUrl: 'https://mobileapi.demostage.ir/api',
    ),
  );

  static final ApiProvider _instance = ApiProvider._();

  factory ApiProvider() => _instance;

  ApiProvider._() {
    dio.options.headers['locale'] = 'fa';

    final token = Pref.getString(Pref.token);
    if (token != null) {
      dio.options.headers['Authorization'] = 'Bearer $token';
    }

    _addInterceptors();
  }

  setToken(token) {
    dio.options.headers['Authorization'] = 'Bearer $token';
  }

  _addInterceptors() {
    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        bool netAvailable = await isNetworkAvailable();

        if (netAvailable) {
          logger.i('onRequest: ${options.path}\n${options.data.toString()}');

          return handler.next(options);
        } else {
          logger.i('you are offline!!!');

          // getX.Get.to(OfflineScreen());
        }
      },
      onResponse: (response, handler) {
        logger.i('onResponse : ${response.data}');

        return handler.next(response);
      },
      onError: (error, handler) {
        // Handle errors globally

/*        switch (error.response?.statusCode) {
          case 401:
            logger.e('Unauthorized error, redirecting to login...');
            break;

          case 404:
            snackError(message: '404');
            break;

          default:
          // Handle other errors
        }*/

        // _handleError(error);

        logger.e('Error occurred: ${error.message}');

        return handler.next(error); // Continue to the next interceptor or error
      },
    ));
  }

  Future<Either<ApiError,T>> get<T>({
    required String path,
    Map<String, dynamic>? headers,
    dynamic body,
    dynamic queryParameters,
    required T Function(dynamic) fromJson,
  }) async {
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

  Future<Either<ApiError,T>> post<T>({
    required String path,
    Map<String, dynamic>? headers,
    required dynamic body,
    T Function(dynamic)? fromJson,
  }) async {
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

  Future<Either<ApiError,T>> patch<T>({
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

  Future<Either<ApiError,T>> delete<T>({
    required String path,
    Map<String, dynamic>? headers,
    required int pathParameter,
    T Function(dynamic)? fromJson,
  }) async {
    try {
      Response response =
          await dio.delete('$path/$pathParameter', options: Options(headers: headers));
      return _handleResponse(response, fromJson);
    } catch (e) {
      return _handleError(e);
    }
  }

  Future<Either<ApiError,T>> _handleResponse<T>(
    Response response,
    T Function(dynamic)? fromJson,
  ) async {
    if (!response.data['isSuccess']) {
      return Left(ApiError(code: response.statusCode!, message: response.data['message']));
    }

    T? data;
    if (fromJson != null && response.data['data'] != null) {
      data = fromJson(response.data['data']);
    }

    data ??= response.data['message'];

    return Right(data as T);
  }

  Future<Either<ApiError,T>> _handleError<T>(dynamic e) async {
    if (e is DioError && e.response != null) {
      switch (e.response!.statusCode) {
        case 403:
          // show403Dialog(message: e.response!.data['message']);
          break;

        case 503:
          logger.i('server is offline');

          // getX.Get.offAll(OfflineServerScreen());
          break;
      }

      ApiError error =
          ApiError(code: e.response!.statusCode!, message: e.response!.data['message']);
      return Left(error);
    } else {
      // Handle other types of errors if needed
      return Left(ApiError(code: 0, message: 'Failed to complete request: $e'));
    }
  }
}
