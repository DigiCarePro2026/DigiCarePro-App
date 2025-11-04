import 'package:digi_care_pro/app/data/models/message.dart';
import 'package:digi_care_pro/app/data/models/paging_model.dart';
import 'package:digi_care_pro/app/data/repositories/notification_repository.dart';
import 'package:digi_care_pro/app/ui/widgets/snack.dart';
import 'package:get/get.dart';

class NotificationsLogic extends GetxController {

  PagingModel paging = PagingModel(page: 1, pageSize: 50);
  List<Message> messages = [];

  @override
  void onReady() {
    super.onReady();
    getMessages();
  }

  getMessages() async {
    var result = await NotificationRepository.get().getMessages(
      pagingModel: paging,
    );

    result.fold(
      (error) {
        snackError(message: error.message);
      },
      (response) {
        messages.addAll(response.data!.messages);

        update();
      },
    );
  }
}
