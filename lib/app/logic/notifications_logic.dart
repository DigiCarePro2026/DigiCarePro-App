import 'package:digi_care_pro/app/data/enum/page_status.dart';
import 'package:digi_care_pro/app/data/models/message.dart';
import 'package:digi_care_pro/app/data/models/paging_model.dart';
import 'package:digi_care_pro/app/data/repositories/notification_repository.dart';
import 'package:digi_care_pro/app/ui/widgets/snack.dart';
import 'package:get/get.dart';

enum MessagesTab { inbox, sent }

class NotificationsLogic extends GetxController {
  PageStatus? pageStatus;
  PagingModel paging = PagingModel(page: 1, pageSize: 50);
  List<Message> messages = [];
  MessagesTab selectedTab = MessagesTab.inbox;
  bool isLoadingMore = false;

  @override
  void onReady() {
    super.onReady();
    getMessages(reset: true);
  }

  void changeTab(MessagesTab tab) {
    selectedTab = tab;
    getMessages(reset: true);
  }

  Future<void> getMessages({bool reset = false}) async {
    if (!reset && isLoadingMore) return;

    if (reset) {
      isLoadingMore = false;
      paging = PagingModel(page: 1, pageSize: 50);
      messages.clear();
      pageStatus = PageStatus.loading;
    } else {
      isLoadingMore = true;
      paging.page++;
    }

    update();

    var result = selectedTab == MessagesTab.inbox
        ? await NotificationRepository.get().getInboxMessages(
            pagingModel: paging,
          )
        : await NotificationRepository.get().getSentMessages(
            pagingModel: paging,
          );

    result.fold(
      (error) {
        if (!reset) {
          paging.page--;
        }
        snackError(message: error.message);
      },
      (response) {
        pageStatus = PageStatus.loaded;
        messages.addAll(response.data!.messages);

        if (messages.isEmpty) {
          pageStatus = PageStatus.empty;
        }

        update();
      },
    );

    isLoadingMore = false;
    update();
  }

  Future<void> refreshCurrentTab() async {
    await getMessages(reset: true);
  }

  markAsRead({required String messageId}) {
    NotificationRepository.get().markAsRead(messageId: messageId);
  }
}
