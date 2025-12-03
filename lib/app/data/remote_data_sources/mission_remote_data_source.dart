import 'package:dartz/dartz.dart';
import 'package:digi_care_pro/app/data/api/api_models/app_response.dart';
import 'package:digi_care_pro/app/data/api/api_models/cancel_mission.dart';
import 'package:digi_care_pro/app/data/api/api_models/change_mission_datetime.dart';
import 'package:digi_care_pro/app/data/api/api_models/delay_mission.dart';
import 'package:digi_care_pro/app/data/api/api_models/check_mission_status.dart';
import 'package:digi_care_pro/app/data/api/api_models/get_missions.dart';
import 'package:digi_care_pro/app/data/api/api_models/manual_end.dart';
import 'package:digi_care_pro/app/data/api/api_models/report_mission.dart';
import 'package:digi_care_pro/app/data/api/api_models/signature_mission.dart';
import 'package:digi_care_pro/app/data/api/api_models/start_mission.dart';
import 'package:digi_care_pro/app/data/api/api_models/upload_doc_mission.dart';
import 'package:digi_care_pro/app/data/enum/mission_action_type.dart';
import 'package:digi_care_pro/app/data/models/api_error.dart';
import 'package:digi_care_pro/app/data/models/create_mission.dart';
import 'package:digi_care_pro/app/data/models/mission.dart';
import 'package:digi_care_pro/app/data/remote_data_sources/base_remote_data_source.dart';
import 'package:get/get.dart' hide FormData, MultipartFile;
import 'package:dio/dio.dart';

class MissionRemoteDataSource extends BaseRemoteDataSource {
  static MissionRemoteDataSource? _instance;

  static MissionRemoteDataSource get() {
    _instance ??= MissionRemoteDataSource();

    return _instance!;
  }

  Future<Either<ApiError, AppResponse<List<Mission>>>> getMissions(GetMissionsRequest request) async =>
      api.get<List<Mission>>(
        path: '/mission/employee/${request.year}/${request.month}',
        queryParameters: request.toJson(),
        loadingMessage: 'loading_missions'.tr,
        fromJson: (json) => (json as List).map((json) => Mission.fromJson(json)).toList(),
      );

  Future<Either<ApiError, AppResponse>> cancel(CancelMissionRequest request, {String? loadingMessage}) =>
      api.post(path: '/mission/${request.missionId}/cancel', body: request.toJson(), loadingMessage: loadingMessage);

  Future<Either<ApiError, AppResponse<Mission>>> delayReport(DelayMissionRequest request, {String? loadingMessage}) =>
      api.post(path: '/mission/${request.missionId}/delay', body: request.toJson(), loadingMessage: loadingMessage);

  Future<Either<ApiError, AppResponse>> reportMission(ReportMissionRequest request, {String? loadingMessage}) =>
      api.post(path: '/mission/${request.missionId}/report', body: request.toJson(), loadingMessage: loadingMessage);

  Future<Either<ApiError, AppResponse>> createMission(CreateMissionRequest request, {String? loadingMessage}) =>
      api.post(path: '/mission/${request.customerId}/add', body: request.toJson());

  Future<Either<ApiError, AppResponse>> changeMissionDatetime(
    ChangeMissionDatetimeRequest request, {
    String? loadingMessage,
  }) => api.put(
    path: '/mission/${request.missionId}/update-mission-dateTime',
    body: request.toJson(),
    loadingMessage: loadingMessage,
  );

  Future<Either<ApiError, AppResponse>> uploadSignature(
    SignatureMissionRequest request, {
    String? loadingMessage,
  }) async {
    FormData formData = FormData.fromMap({
      "signatureFile": MultipartFile.fromBytes(
        request.imageData,
        filename: "signature.jpg",
        contentType: DioMediaType("image", "jpeg"),
      ),
    });

    return api.post(
      path: '/mission/${request.missionId}/sign',
      body: formData,
      headers: {"Content-Type": "multipart/form-data"},
      loadingMessage: loadingMessage,
    );
  }

  Future<Either<ApiError, AppResponse>> uploadDocument(
    UploadDocMissionRequest request, {
    String? loadingMessage,
  }) async {
    FormData formData = FormData.fromMap({
      'CustomerId': request.customerId,
      'Title': request.title,
      'File': MultipartFile.fromBytes(
        request.imageData,
        filename: "doc.jpg",
        contentType: DioMediaType("image", "jpeg"),
      ),
    });

    return api.post(
      path: '/mission/${request.missionId}/documents',
      body: formData,
      headers: {"Content-Type": "multipart/form-data"},
      loadingMessage: loadingMessage,
    );
  }

  Future<Either<ApiError, AppResponse<MissionActionType>>> checkMissionStatus(
    CheckMissionStatusRequest request, {
    String? loadingMessage,
  }) => api.post<MissionActionType>(
    path: '/mission/${request.missionId}/status-check',
    body: request.toJson(),
    loadingMessage: loadingMessage,
    fromJson: (actionType) => MissionActionType.values[actionType],
  );

  Future<Either<ApiError, AppResponse>> startMission(StartMissionRequest request, {String? loadingMessage}) =>
      api.post(path: '/mission/${request.missionId}/start', body: request.toJson(), loadingMessage: loadingMessage);

  Future<Either<ApiError, AppResponse>> manualEnd(ManualEndRequest request, {String? loadingMessage}) => api.post(
    path: '/mission/${request.missionId}/manual-end',
    body: request.toJson(),
    loadingMessage: loadingMessage,
  );
}
