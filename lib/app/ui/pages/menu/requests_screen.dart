import 'package:digi_care_pro/app/routes/app_routes.dart';
import 'package:digi_care_pro/app/ui/theme/app_colors.dart';
import 'package:digi_care_pro/app/ui/theme/app_dimens.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class RequestsScreen extends StatefulWidget {
  const RequestsScreen({super.key});

  @override
  State<RequestsScreen> createState() => _RequestsScreenState();
}

class _RequestsScreenState extends State<RequestsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('requests'.tr), centerTitle: true),
      body: ListView.builder(
          itemCount: 15,
          itemBuilder: (ctx, index) => _buildItem(index)),
      floatingActionButton: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary,
          borderRadius: BorderRadius.circular(cardRadius),
        ),
        child: InkWell(
          onTap: (){
            Get.toNamed(Routes.LEAVE_REQUEST);
          },
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Wrap(
              runAlignment: WrapAlignment.center,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                SvgPicture.asset('assets/icons/plus.svg', color: Theme.of(context).colorScheme.onPrimary,),
                SizedBox(width: 12),
                Text('New Request', style: Theme.of(context).textTheme.labelMedium!.copyWith(color: Theme.of(context).colorScheme.onPrimary, fontWeight: FontWeight.bold),)
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildItem(int index) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, bottom: 8),
      child: Card.filled(
        child: InkWell(
          borderRadius: BorderRadius.circular(cardRadius),
          onTap: () {
          },
          child: Padding(
            padding: const EdgeInsets.all(cardPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          Text('Oct 20', style: Theme.of(context).textTheme.labelLarge),
                          SizedBox(width: 4),
                          SvgPicture.asset('assets/icons/arrow-long-right.svg', color: Theme.of(context).disabledColor),
                          SizedBox(width: 4),
                          Text(' Oct 25', style: Theme.of(context).textTheme.labelLarge),
                        ],
                      ),
                    ),
                    PopupMenuButton(
                      icon: SvgPicture.asset('assets/icons/more-hor.svg'),
                      onSelected: (value) {
                        if (value == 'remove') {
                          print('Remove selected');
                        }
                      },
                      itemBuilder: (ctx) {
                        return [
                          PopupMenuItem(value: 'remove', child: Text('remove'.tr)),
                        ];
                      },
                    ),
                  ],
                ),
                Text('Description of request', style: Theme.of(context).textTheme.titleMedium),
                Row(
                  children: [
                    Text('Reason:', style: Theme.of(context).textTheme.titleMedium),
                    SizedBox(width: 12),
                    Text('Sick', style: Theme.of(context).textTheme.titleMedium),
                  ],
                ),
                Divider(height: 12, thickness: 0.5, color: Theme.of(context).dividerColor),
                Row(
                  children: [
                    if (index % 2 == 1)
                      Expanded(
                        child: Text(
                          'Approved',
                          style: Theme.of(context).textTheme.titleSmall!.copyWith(color: AppColors.green),
                        ),
                      ),
                    if (index % 2 == 0)
                      Expanded(
                        child: Text(
                          'Rejected',
                          style: Theme.of(context).textTheme.titleSmall!.copyWith(color: AppColors.red),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
