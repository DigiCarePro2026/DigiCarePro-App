import 'package:digi_care_pro/app/data/api/api_models/send_message.dart';
import 'package:digi_care_pro/app/data/repositories/notification_repository.dart';
import 'package:digi_care_pro/app/ui/widgets/snack.dart';
import 'package:digi_care_pro/app/utils/dialog_handler.dart';
import 'package:get/get.dart';

class SupportLogic extends GetxController {
  sendMessage({required String subject, required String body}) async {
    DialogHandler.showLoading('loading_send_message'.tr);

    var result = await NotificationRepository.get().sendMessage(
      SendMessageRequest(subject: subject, body: body),
    );

    DialogHandler.hideLoading();

    result.fold(
      (error) {
        snackError(message: error.message);
      },
      (response) {
        Future.delayed(Duration(milliseconds: 200), (){
          Get.back();
          snackSuccess(message: response.message ?? 'message_send_success'.tr);
        });
      },
    );
  }
}
