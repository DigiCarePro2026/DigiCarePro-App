import 'package:digi_care_pro/app/data/enum/page_status.dart';
import 'package:digi_care_pro/app/data/models/message.dart';
import 'package:digi_care_pro/app/logic/notifications_logic.dart';
import 'package:digi_care_pro/app/ui/theme/app_dimens.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  NotificationsLogic logic = NotificationsLogic();

  @override
  void initState() {
    Get.put(logic);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<NotificationsLogic>(
      builder: (logic) {
        return Scaffold(
          appBar: AppBar(title: Text('notifications'.tr)),
          body: Stack(
            children: [
              if (logic.pageStatus == PageStatus.loading) Center(child: CircularProgressIndicator()),
              if(logic.pageStatus == PageStatus.empty) Center(child: Text('empty_message'.tr,style: Theme.of(context).textTheme.titleMedium),),
              if (logic.pageStatus == PageStatus.loaded)
              ListView.builder(
                itemCount: logic.messages.length,
                itemBuilder: (ctx, index) {
                  if(index == logic.messages.length - 1){
                    logic.paging.page ++;

                    logic.getMessages();
                  }

                  return MessageItem(message: logic.messages[index]);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}

class MessageItem extends StatefulWidget {
  final Message message;

  const MessageItem({super.key, required this.message});

  @override
  State<MessageItem> createState() => _MessageItemState();
}

class _MessageItemState extends State<MessageItem> {
  bool isExpanded = false;
  static const double cardPadding = 16.0;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, bottom: 8),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        child: Card(
          child: InkWell(
            borderRadius: BorderRadius.circular(cardRadius),
            onTap: () {
              setState(() {
                isExpanded = !isExpanded;
              });
            },
            child: Padding(
              padding: const EdgeInsets.all(cardPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.message.subject, style: Theme.of(context).textTheme.headlineMedium),
                  const SizedBox(height: 12),
                  AnimatedCrossFade(
                    firstChild: Text(
                      widget.message.body!.length > 200 ? widget.message.body!.substring(0, 200) : widget.message.body!,
                      style: Theme.of(context).textTheme.bodyMedium,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    secondChild: Text(widget.message.body!, style: Theme.of(context).textTheme.bodyMedium),
                    crossFadeState: isExpanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
                    duration: const Duration(milliseconds: 300),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [Text(widget.message.sentAt, style: Theme.of(context).textTheme.titleSmall)],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
