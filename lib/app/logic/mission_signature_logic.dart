import 'package:digi_care_pro/app/data/api/api_models/signature_mission.dart';
import 'package:digi_care_pro/app/data/enum/mission_status.dart';
import 'package:digi_care_pro/app/data/models/mission.dart';
import 'package:digi_care_pro/app/data/repositories/mission_repository.dart';
import 'package:digi_care_pro/app/ui/widgets/snack.dart';
import 'package:get/get.dart';

class MissionSignatureLogic extends GetxController {
  bool isSubmitting = false;

  upload(
    String missionId,
    bool completeWithoutSignature,
    List<int>? byteData,
  ) async {
    if (isSubmitting) return;

    isSubmitting = true;
    update();

    var result = await MissionRepository.get().uploadSignature(
      SignatureMissionRequest(
        missionId: missionId,
        completeWithoutSignature: completeWithoutSignature,
        imageData: byteData,
      ),
      loadingMessage: 'uploading_signature'.tr,
    );

    await result.fold(
      (error) async {
        if (error.isTimeout) {
          final verified = await _verifySignatureUpload(
            missionId: missionId,
            completeWithoutSignature: completeWithoutSignature,
          );

          if (verified) {
            return;
          }
        }

        snackError(message: error.message);
      },
      (response) async {
        Get.back(result: true);
        snackSuccess(message: response.message);
      },
    );

    isSubmitting = false;
    update();
  }

  Future<bool> _verifySignatureUpload({
    required String missionId,
    required bool completeWithoutSignature,
  }) async {
    final verification = await MissionRepository.get().getMissionDetails(
      missionId,
    );

    return verification.fold((_) => false, (response) {
      final mission = response.data;
      if (_isMissionSignatureConfirmed(
        mission: mission,
        completeWithoutSignature: completeWithoutSignature,
      )) {
        Get.back(result: true);
        snackSuccess(message: 'signature_submitted_verified'.tr);
        return true;
      }

      return false;
    });
  }

  bool _isMissionSignatureConfirmed({
    required Mission? mission,
    required bool completeWithoutSignature,
  }) {
    if (mission == null) return false;

    final isCompleted = mission.status == MissionStatus.completed.code;
    final hasSignature = (mission.signaturePath ?? '').isNotEmpty;

    if (completeWithoutSignature) {
      return isCompleted;
    }

    return hasSignature || isCompleted;
  }
}
