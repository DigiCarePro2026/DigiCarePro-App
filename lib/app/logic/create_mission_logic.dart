import 'package:digi_care_pro/app/data/models/create_mission.dart';
import 'package:digi_care_pro/app/data/repositories/mission_repository.dart';
import 'package:digi_care_pro/app/ui/widgets/snack.dart';
import 'package:digi_care_pro/app/utils/dialog_handler.dart';
import 'package:digi_care_pro/app/utils/mission_event_bus.dart';
import 'package:get/get.dart';

class CreateMissionLogic extends GetxController {
  final String customerId;

  CreateMissionLogic(this.customerId);

  createMission({required String date, required String startTime, required String endTime, String? comment}) async {
    DialogHandler.showLoading('loading_default_message'.tr);

    var result = await MissionRepository.get().createMission(
      CreateMissionRequest(
        customerId: customerId,
        date: date,
        startTime: startTime,
        endTime: endTime,
        comment: comment,
      ),
    );

    DialogHandler.hideLoading();

    Future.delayed(Duration(milliseconds: 200), () {
      result.fold(
        (error) {
          snackError(message: error.message);
        },
        (response) {
          MissionEventBus eventBus = Get.find();
          eventBus.sendUpdate(true);

          Get.back();
          snackSuccess(message: response.message);
        },
      );
    });
  }
}
