import 'package:dartz/dartz.dart';
import 'package:digi_care_pro/app/data/api/api_models/app_response.dart';
import 'package:digi_care_pro/app/data/api/api_models/cancel_mission.dart';
import 'package:digi_care_pro/app/data/api/api_models/delay_mission.dart';
import 'package:digi_care_pro/app/data/api/api_models/report_mission.dart';
import 'package:digi_care_pro/app/data/api/api_models/signature_mission.dart';
import 'package:digi_care_pro/app/data/api/api_models/upload_doc_mission.dart';
import 'package:digi_care_pro/app/data/models/api_error.dart';
import 'package:digi_care_pro/app/data/models/create_mission.dart';
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

  Future<Either<ApiError, AppResponse<List<Mission>>>> getMissions({required int year, required int month}) async =>
      MissionRemoteDataSource.get().getMissions(year: year, month: month);

  Future<Either<ApiError, AppResponse>> cancelMission(CancelMissionRequest request, {String? loadingMessage}) =>
      MissionRemoteDataSource.get().cancel(request, loadingMessage: loadingMessage);

  Future<Either<ApiError, AppResponse>> delayReport(DelayMissionRequest request, {String? loadingMessage}) =>
      MissionRemoteDataSource.get().delayReport(request, loadingMessage: loadingMessage);

  Future<Either<ApiError, AppResponse>> reportMission(ReportMissionRequest request, {String? loadingMessage}) =>
      MissionRemoteDataSource.get().reportMission(request, loadingMessage: loadingMessage);

  Future<Either<ApiError, AppResponse>> createMission(CreateMissionRequest request, {String? loadingMessage}) =>
      MissionRemoteDataSource.get().createMission(request, loadingMessage: loadingMessage);

  Future<Either<ApiError, AppResponse>> uploadSignature(SignatureMissionRequest request, {String? loadingMessage}) =>
      MissionRemoteDataSource.get().uploadSignature(request, loadingMessage: loadingMessage);

  Future<Either<ApiError, AppResponse>> uploadDocument(UploadDocMissionRequest request, {String? loadingMessage}) =>
      MissionRemoteDataSource.get().uploadDocument(request, loadingMessage: loadingMessage);
}
