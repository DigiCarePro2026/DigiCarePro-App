import 'package:dartz/dartz.dart';
import 'package:digi_care_pro/app/data/api/api_models/app_response.dart';
import 'package:digi_care_pro/app/data/api/api_models/send_message.dart';
import 'package:digi_care_pro/app/data/models/api_error.dart';
import 'package:digi_care_pro/app/data/models/customer.dart';
import 'package:digi_care_pro/app/data/remote_data_sources/employee_remote_data_source.dart';
import 'package:digi_care_pro/app/data/remote_data_sources/notification_remote_data_source.dart';

class NotificationRepository {
  static NotificationRepository? _instance;

  static NotificationRepository get() {
    _instance ??= NotificationRepository();

    return _instance!;
  }

  Future<Either<ApiError, AppResponse>> sendMessage(SendMessageRequest request, {String? loadingMessage}) async =>
      NotificationRemoteDataSource.get().sendMessage(request, loadingMessage: loadingMessage);
}
