import 'package:dartz/dartz.dart';
import 'package:digi_care_pro/app/data/api/api_models/app_response.dart';
import 'package:digi_care_pro/app/data/api/api_models/send_message.dart';
import 'package:digi_care_pro/app/data/models/api_error.dart';
import 'package:digi_care_pro/app/data/models/customer.dart';
import 'package:digi_care_pro/app/data/remote_data_sources/base_remote_data_source.dart';

class NotificationRemoteDataSource extends BaseRemoteDataSource {
  static NotificationRemoteDataSource? _instance;

  static NotificationRemoteDataSource get() {
    _instance ??= NotificationRemoteDataSource();

    return _instance!;
  }

  Future<Either<ApiError, AppResponse>> sendMessage(SendMessageRequest request, {String? loadingMessage}) async =>
      api.post(path: '/message/send-to-company', body: request.toJson(), loadingMessage: loadingMessage);
}
