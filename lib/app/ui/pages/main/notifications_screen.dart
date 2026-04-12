import 'package:digi_care_pro/app/data/enum/page_status.dart';
import 'package:digi_care_pro/app/data/models/message.dart';
import 'package:digi_care_pro/app/logic/notifications_logic.dart';
import 'package:digi_care_pro/app/routes/app_routes.dart';
import 'package:digi_care_pro/app/ui/theme/app_dimens.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen>
    with SingleTickerProviderStateMixin {
  NotificationsLogic logic = NotificationsLogic();
  late final TabController tabController;

  @override
  void initState() {
    Get.put(logic);
    tabController = TabController(length: 2, vsync: this);

    super.initState();
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<NotificationsLogic>(
      builder: (logic) {
        return Scaffold(
          appBar: AppBar(
            title: Text('notifications'.tr),
            actions: [
              InkWell(
                customBorder: CircleBorder(),
                onTap: () async {
                  bool result = await Get.toNamed(
                    Routes.SUPPORT,
                    arguments: {'mode': 'message'},
                  );

                  if (result) {
                    logic.refreshCurrentTab();
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SvgPicture.asset('assets/icons/message-edit.svg'),
                ),
              ),
              SizedBox(width: 12),
            ],
            bottom: TabBar(
              controller: tabController,
              dividerColor: Colors.transparent,
              indicatorSize: TabBarIndicatorSize.tab,
              indicatorColor: Theme.of(context).primaryColor,
              indicatorWeight: 3,
              labelStyle: TextStyle(fontSize: 18),
              onTap: (index) {
                final tab = index == 0 ? MessagesTab.inbox : MessagesTab.sent;
                logic.changeTab(tab);
              },
              tabs: [
                Tab(text: 'inbox_messages'.tr),
                Tab(text: 'sent_messages'.tr),
              ],
            ),
          ),
          body: Stack(
            children: [
              if (logic.pageStatus == PageStatus.loading)
                Center(child: CircularProgressIndicator()),
              if (logic.pageStatus == PageStatus.empty)
                Center(
                  child: Text(
                    'empty_message'.tr,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
              if (logic.pageStatus == PageStatus.loaded)
                ListView.builder(
                  itemCount: logic.messages.length,
                  itemBuilder: (ctx, index) {
                    if (index == logic.messages.length - 1) {
                      logic.getMessages();
                    }

                    return MessageItem(
                      message: logic.messages[index],
                      isInbox: logic.selectedTab == MessagesTab.inbox,
                      readCallback: (String messageId) async {
                        return logic.markAsRead(messageId: messageId);
                      },
                    );
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
  final bool isInbox;
  final Future<bool> Function(String messageId) readCallback;

  const MessageItem({
    super.key,
    required this.message,
    required this.isInbox,
    required this.readCallback,
  });

  @override
  State<MessageItem> createState() => _MessageItemState();
}

class _MessageItemState extends State<MessageItem> {
  bool isExpanded = false;
  static const double cardPadding = 16.0;
  static const Color unreadAccent = Color(0xFF1B5E20);

  @override
  Widget build(BuildContext context) {
    final isUnread = !widget.message.isRead;

    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, bottom: 8),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        child: Stack(
          children: [
            Card(
              color: isUnread
                  ? unreadAccent.withValues(alpha: 0.08)
                  : Theme.of(context).colorScheme.surface,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(cardRadius),
                side: BorderSide(
                  color: isUnread
                      ? unreadAccent.withValues(alpha: 0.35)
                      : Theme.of(context).dividerColor,
                ),
              ),
              child: InkWell(
                borderRadius: BorderRadius.circular(cardRadius),
                onTap: () async {
                  if (isUnread) {
                    final marked = await widget.readCallback.call(widget.message.id);
                    if (marked) {
                      widget.message.isRead = true;
                    }
                  }

                  setState(() {
                    isExpanded = !isExpanded;
                  });
                },
                child: Padding(
                  padding: const EdgeInsets.all(cardPadding),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          if (isUnread) ...[
                            Container(
                              width: 10,
                              height: 10,
                              decoration: const BoxDecoration(
                                color: unreadAccent,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 8),
                          ],
                          Expanded(
                            child: Text(
                              widget.isInbox
                                  ? '${'sender'.tr}: ${widget.message.senderName ?? '-'}'
                                  : '${'receiver'.tr}: ${widget.message.receiverName ?? '-'}',
                              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                fontWeight: isUnread ? FontWeight.w700 : FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        widget.message.subject,
                        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontWeight: isUnread ? FontWeight.w800 : FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 12),
                      AnimatedCrossFade(
                        firstChild: Text(
                          widget.message.body!.length > 200
                              ? widget.message.body!.substring(0, 200)
                              : widget.message.body!,
                          style: Theme.of(context).textTheme.bodyMedium,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        secondChild: Text(
                          widget.message.body!,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        crossFadeState: isExpanded
                            ? CrossFadeState.showSecond
                            : CrossFadeState.showFirst,
                        duration: const Duration(milliseconds: 300),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            widget.message.sentAt,
                            style: Theme.of(context).textTheme.titleSmall,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            if (isUnread)
              Positioned.fill(
                child: IgnorePointer(
                  child: CustomPaint(
                    painter: _DottedRoundedBorderPainter(
                      color: unreadAccent,
                      strokeWidth: 2.2,
                      radius: cardRadius,
                      dashWidth: 7,
                      dashGap: 4,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _DottedRoundedBorderPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  final double radius;
  final double dashWidth;
  final double dashGap;

  const _DottedRoundedBorderPainter({
    required this.color,
    required this.strokeWidth,
    required this.radius,
    required this.dashWidth,
    required this.dashGap,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    final rect = Offset.zero & size;
    final rrect = RRect.fromRectAndRadius(rect, Radius.circular(radius));
    final path = Path()..addRRect(rrect);

    for (final metric in path.computeMetrics()) {
      double distance = 0;
      while (distance < metric.length) {
        final next = (distance + dashWidth).clamp(0, metric.length).toDouble();
        canvas.drawPath(metric.extractPath(distance, next), paint);
        distance += dashWidth + dashGap;
      }
    }
  }

  @override
  bool shouldRepaint(covariant _DottedRoundedBorderPainter oldDelegate) {
    return oldDelegate.color != color ||
        oldDelegate.strokeWidth != strokeWidth ||
        oldDelegate.radius != radius ||
        oldDelegate.dashWidth != dashWidth ||
        oldDelegate.dashGap != dashGap;
  }
}
