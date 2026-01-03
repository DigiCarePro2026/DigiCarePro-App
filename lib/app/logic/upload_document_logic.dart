import 'package:digi_care_pro/app/data/api/api_models/signature_mission.dart';
import 'package:digi_care_pro/app/data/api/api_models/upload_doc_mission.dart';
import 'package:digi_care_pro/app/data/repositories/mission_repository.dart';
import 'package:digi_care_pro/app/ui/widgets/snack.dart';
import 'package:digi_care_pro/app/utils/dialog_handler.dart';
import 'package:get/get.dart';

class UploadDocumentLogic extends GetxController {
  upload(String missionId, String customerId, String? title,  List<int> byteData) async {
    DialogHandler.showLoading('uploading_document'.tr);

    var result = await MissionRepository.get().uploadDocument(
      UploadDocMissionRequest(missionId: missionId, imageData: byteData, customerId: customerId, title: title),
      loadingMessage: 'Uploading document',
    );

    DialogHandler.hideLoading();

    result.fold(
      (error) {
        snackError(message: error.message);
      },
      (response) {
        Future.delayed(Duration(milliseconds: 200), (){
          Get.back();

          snackSuccess(message: response.message);
        });
      },
    );
  }
}
