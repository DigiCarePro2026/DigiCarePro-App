import 'dart:ffi';

import 'package:digi_care_pro/app/data/api/api_models/send_message.dart';
import 'package:digi_care_pro/app/data/models/message_receiver.dart';
import 'package:digi_care_pro/app/data/repositories/notification_repository.dart';
import 'package:digi_care_pro/app/ui/widgets/snack.dart';
import 'package:digi_care_pro/app/utils/dialog_handler.dart';
import 'package:get/get.dart';

class SupportLogic extends GetxController {
  List<MessageReceiver> receivers = [];

  @override
  onReady() {
    super.onReady();

    _getReceivers();
  }

  _getReceivers() async {
    var result = await NotificationRepository.get().getReceivers();

    result.fold((error) {}, (response) {
      receivers.clear();

      receivers.add(MessageReceiver(id: null, fullName: 'company'.tr));
      receivers.addAll(response.data!);

      update();
    });
  }

  sendMessage({required String subject, String? receiverId, required String body}) async {
    DialogHandler.showLoading('loading_send_message'.tr);

    var result = await NotificationRepository.get().sendMessage(
      SendMessageRequest(subject: subject, receiverId: receiverId, body: body),
    );

    DialogHandler.hideLoading();

    result.fold(
      (error) {
        snackError(message: error.message);
      },
      (response) {
        Future.delayed(Duration(milliseconds: 200), () {
          Get.back();
          snackSuccess(message: response.message ?? 'message_send_success'.tr);
        });
      },
    );
  }
}
