import 'package:digi_care_pro/app/data/enum/page_status.dart';
import 'package:digi_care_pro/app/data/models/message.dart';
import 'package:digi_care_pro/app/data/models/paging_model.dart';
import 'package:digi_care_pro/app/data/repositories/notification_repository.dart';
import 'package:digi_care_pro/app/logic/main_logic.dart';
import 'package:digi_care_pro/app/ui/widgets/snack.dart';
import 'package:get/get.dart';

enum MessagesTab { inbox, sent }

class NotificationsLogic extends GetxController {
  PageStatus? pageStatus;
  PagingModel paging = PagingModel(page: 1, pageSize: 50);
  List<Message> messages = [];
  MessagesTab selectedTab = MessagesTab.inbox;
  bool isLoadingMore = false;
  bool hasMore = true;

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
    if (!reset && (isLoadingMore || !hasMore)) return;

    if (reset) {
      isLoadingMore = false;
      hasMore = true;
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
        final newItems = response.data!.messages;
        final existingIds = messages.map((m) => m.id).toSet();

        paging.totalCount = response.data!.pagingModel.totalCount;

        final uniqueNewItems = newItems.where((m) => !existingIds.contains(m.id)).toList();

        pageStatus = PageStatus.loaded;
        messages.addAll(uniqueNewItems);

        if (paging.totalCount != null) {
          hasMore = messages.length < paging.totalCount!;
        } else {
          hasMore = uniqueNewItems.isNotEmpty;
        }

        if (newItems.isNotEmpty && uniqueNewItems.isEmpty) {
          hasMore = false;
        }

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

  Future<bool> markAsRead({required String messageId}) async {
    final result = await NotificationRepository.get().markAsRead(messageId: messageId);

    return result.fold(
      (error) {
        snackError(message: error.message);
        return false;
      },
      (_) {
        if (Get.isRegistered<MainLogic>()) {
          final mainLogic = Get.find<MainLogic>();
          mainLogic.decrementUnreadMessageCount();
        }

        snackSuccess(message: 'message_marked_as_read'.tr);
        return true;
      },
    );
  }
}
