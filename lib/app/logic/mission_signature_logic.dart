import 'package:digi_care_pro/app/data/api/api_models/signature_mission.dart';
import 'package:digi_care_pro/app/data/repositories/mission_repository.dart';
import 'package:digi_care_pro/app/ui/widgets/snack.dart';
import 'package:get/get.dart';

class MissionSignatureLogic extends GetxController {
  upload(String missionId, List<int> byteData) async {
    var result = await MissionRepository.get().uploadSignature(
      SignatureMissionRequest(missionId: missionId, imageData: byteData),
      loadingMessage: 'Uploading signature',
    );

    Get.back();

    result.fold(
      (error) {
        snackError(message: error.message);
      },
      (response) {
        snackSuccess(message: response.message);
      },
    );
  }
}
