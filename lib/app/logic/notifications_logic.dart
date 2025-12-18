import 'package:digi_care_pro/app/data/enum/page_status.dart';
import 'package:digi_care_pro/app/data/models/message.dart';
import 'package:digi_care_pro/app/data/models/paging_model.dart';
import 'package:digi_care_pro/app/data/repositories/notification_repository.dart';
import 'package:digi_care_pro/app/ui/widgets/snack.dart';
import 'package:get/get.dart';

class NotificationsLogic extends GetxController {

  PageStatus? pageStatus;
  PagingModel paging = PagingModel(page: 1, pageSize: 50);
  List<Message> messages = [];

  @override
  void onReady() {
    super.onReady();
    getMessages();
  }

  getMessages() async {
    pageStatus = PageStatus.loading;
    var result = await NotificationRepository.get().getMessages(
      pagingModel: paging,
    );

    result.fold(
      (error) {
        snackError(message: error.message);
      },
      (response) {
        pageStatus = PageStatus.loaded;

        messages.addAll(response.data!.messages);

        if(messages.isEmpty){
          pageStatus = PageStatus.empty;
        }

        update();
      },
    );
  }

  markAsRead({required String messageId}){
    NotificationRepository.get().markAsRead(messageId: messageId);
  }
}
