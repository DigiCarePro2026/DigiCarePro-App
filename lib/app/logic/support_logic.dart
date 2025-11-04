import 'package:digi_care_pro/app/data/api/api_models/send_message.dart';
import 'package:digi_care_pro/app/data/repositories/notification_repository.dart';
import 'package:digi_care_pro/app/ui/widgets/snack.dart';
import 'package:get/get.dart';

class SupportLogic extends GetxController {
  sendMessage({required String subject, required String body}) async {
    var result = await NotificationRepository.get().sendMessage(
      SendMessageRequest(subject: subject, body: body),
      loadingMessage: 'loading_send_message'.tr,
    );

    Get.back();

    result.fold(
      (error) {
        snackError(message: error.message);
      },
      (response) {
        Get.back();
        snackSuccess(message: response.message ?? 'message_send_success'.tr);
      },
    );
  }
}
