import 'package:digi_care_pro/app/ui/theme/app_dimens.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('notifications'.tr)),
      body: ListView.builder(
        itemCount: 16,
        itemBuilder: (ctx, index) => NewsItem(index: index),
      ),
    );
  }
}

class NewsItem extends StatefulWidget {
  final int index;
  const NewsItem({super.key, required this.index});

  @override
  State<NewsItem> createState() => _NewsItemState();
}

class _NewsItemState extends State<NewsItem> {
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
            onTap: (){
              setState(() {
                isExpanded = !isExpanded;
              });
            },
            child: Padding(
              padding: const EdgeInsets.all(cardPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'How Families Manage Health and Daily Support',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 12),
                  AnimatedCrossFade(
                    firstChild: Text(
                      'A new app called CareConnect is making waves in the digital health space, offering an all-in-one solution for families, caregivers, and healthcare professionals. The app simplifies care coordination by combining features like medication reminders, health tracking, appointment scheduling, and secure messaging — all in a single, easy-to-use platform.',
                      style: Theme.of(context).textTheme.bodyMedium,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    secondChild: Text(
                      'A new app called CareConnect is making waves in the digital health space, offering an all-in-one solution for families, caregivers, and healthcare professionals. The app simplifies care coordination by combining features like medication reminders, health tracking, appointment scheduling, and secure messaging — all in a single, easy-to-use platform.',
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
                      Text('2025/07/10 11:34', style: Theme.of(context).textTheme.titleSmall),
                    ],
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
