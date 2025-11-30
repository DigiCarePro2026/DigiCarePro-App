import 'package:dartz/dartz.dart';
import 'package:digi_care_pro/app/data/api/api_models/app_response.dart';
import 'package:digi_care_pro/app/data/api/api_models/cancel_mission.dart';
import 'package:digi_care_pro/app/data/api/api_models/change_mission_datetime.dart';
import 'package:digi_care_pro/app/data/api/api_models/check_mission_status.dart';
import 'package:digi_care_pro/app/data/api/api_models/delay_mission.dart';
import 'package:digi_care_pro/app/data/api/api_models/get_missions.dart';
import 'package:digi_care_pro/app/data/api/api_models/manual_end.dart';
import 'package:digi_care_pro/app/data/api/api_models/report_mission.dart';
import 'package:digi_care_pro/app/data/api/api_models/signature_mission.dart';
import 'package:digi_care_pro/app/data/api/api_models/start_mission.dart';
import 'package:digi_care_pro/app/data/api/api_models/upload_doc_mission.dart';
import 'package:digi_care_pro/app/data/enum/mission_action_type.dart';
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

  Future<Either<ApiError, AppResponse<List<Mission>>>> getMissions(GetMissionsRequest request) async =>
      MissionRemoteDataSource.get().getMissions(request);

  Future<Either<ApiError, AppResponse>> cancelMission(CancelMissionRequest request, {String? loadingMessage}) =>
      MissionRemoteDataSource.get().cancel(request, loadingMessage: loadingMessage);

  Future<Either<ApiError, AppResponse>> delayReport(DelayMissionRequest request, {String? loadingMessage}) =>
      MissionRemoteDataSource.get().delayReport(request, loadingMessage: loadingMessage);

  Future<Either<ApiError, AppResponse>> reportMission(ReportMissionRequest request, {String? loadingMessage}) =>
      MissionRemoteDataSource.get().reportMission(request, loadingMessage: loadingMessage);

  Future<Either<ApiError, AppResponse>> createMission(CreateMissionRequest request, {String? loadingMessage}) =>
      MissionRemoteDataSource.get().createMission(request, loadingMessage: loadingMessage);

  Future<Either<ApiError, AppResponse>> changeMissionDatetime(
    ChangeMissionDatetimeRequest request, {
    String? loadingMessage,
  }) => MissionRemoteDataSource.get().changeMissionDatetime(request, loadingMessage: loadingMessage);

  Future<Either<ApiError, AppResponse>> uploadSignature(SignatureMissionRequest request, {String? loadingMessage}) =>
      MissionRemoteDataSource.get().uploadSignature(request, loadingMessage: loadingMessage);

  Future<Either<ApiError, AppResponse>> uploadDocument(UploadDocMissionRequest request, {String? loadingMessage}) =>
      MissionRemoteDataSource.get().uploadDocument(request, loadingMessage: loadingMessage);

  Future<Either<ApiError, AppResponse<MissionActionType>>> checkMissionStatus(CheckMissionStatusRequest request, {String? loadingMessage}) =>
      MissionRemoteDataSource.get().checkMissionStatus(request, loadingMessage: loadingMessage);

  Future<Either<ApiError, AppResponse>> startMission(StartMissionRequest request, {String? loadingMessage}) =>
      MissionRemoteDataSource.get().startMission(request, loadingMessage: loadingMessage);

  Future<Either<ApiError, AppResponse>> manualEnd(ManualEndRequest request, {String? loadingMessage}) =>
      MissionRemoteDataSource.get().manualEnd(request, loadingMessage: loadingMessage);
}
