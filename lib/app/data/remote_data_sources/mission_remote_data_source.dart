import 'package:dartz/dartz.dart';
import 'package:digi_care_pro/app/data/api/api_models/app_response.dart';
import 'package:digi_care_pro/app/data/models/api_error.dart';
import 'package:digi_care_pro/app/data/models/customer.dart';
import 'package:digi_care_pro/app/data/models/mission.dart';
import 'package:digi_care_pro/app/data/remote_data_sources/base_remote_data_source.dart';
import 'package:get/get.dart';

class MissionRemoteDataSource extends BaseRemoteDataSource {
  static MissionRemoteDataSource? _instance;

  static MissionRemoteDataSource get() {
    _instance ??= MissionRemoteDataSource();

    return _instance!;
  }

  Future<Either<ApiError, AppResponse<List<Mission>>>> getMissions({
    required int year,
    required int month,
  }) async => api.get<List<Mission>>(
    path: '/mission/employee/$year/$month',
    loadingMessage: 'loading_missions'.tr,
    fromJson: (json) =>
        (json as List).map((json) => Mission.fromJson(json)).toList(),
  );
}
