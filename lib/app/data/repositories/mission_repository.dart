import 'package:dartz/dartz.dart';
import 'package:digi_care_pro/app/data/api/api_models/app_response.dart';
import 'package:digi_care_pro/app/data/models/api_error.dart';
import 'package:digi_care_pro/app/data/models/customer.dart';
import 'package:digi_care_pro/app/data/models/mission.dart';
import 'package:digi_care_pro/app/data/remote_data_sources/employee_remote_data_source.dart';
import 'package:digi_care_pro/app/data/remote_data_sources/mission_remote_data_source.dart';

class MissionRepository {
  static MissionRepository? _instance;

  static MissionRepository get() {
    _instance ??= MissionRepository();

    return _instance!;
  }

  Future<Either<ApiError, AppResponse<List<Mission>>>> getMissions({
    required int year,
    required int month,
  }) async =>
      MissionRemoteDataSource.get().getMissions(year: year, month: month);
}
