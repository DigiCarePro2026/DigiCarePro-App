import 'package:digi_care_pro/app/data/enum/mission_action_type.dart';
import 'package:digi_care_pro/app/data/models/mission.dart';
import 'package:digi_care_pro/app/logic/mission_details_logic.dart';
import 'package:digi_care_pro/app/ui/theme/app_colors.dart';
import 'package:digi_care_pro/app/ui/theme/app_dimens.dart';
import 'package:digi_care_pro/app/ui/widgets/secondary_button.dart';
import 'package:digi_care_pro/app/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class MissionDetailsScreen extends StatefulWidget {
  MissionDetailsScreen({super.key, required this.mission});

  Mission mission;

  @override
  State<MissionDetailsScreen> createState() => _MissionDetailsScreenState();
}

class _MissionDetailsScreenState extends State<MissionDetailsScreen> {
  @override
  void initState() {
    Get.put(MissionDetailsLogic(widget.mission));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MissionDetailsLogic>(
      builder: (logic) {
        return Scaffold(
          body: Stack(
            children: [
              Container(
                width: double.infinity,
                height: MediaQuery.of(context).padding.top + 170,
                color: Theme.of(context).colorScheme.primary,
                child: Image.asset(
                  'assets/images/bg-customer-detail-header.png',
                  color: Theme.of(context).colorScheme.surface,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity,
                ),
              ),
              Column(
                children: [
                  SizedBox(height: MediaQuery.of(context).padding.top),
                  Stack(
                    alignment: AlignmentDirectional.centerStart,
                    children: [
                      Row(
                        children: [
                          SizedBox(width: 16),
                          InkWell(
                            borderRadius: BorderRadius.circular(20),
                            onTap: () => Get.back(),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Icon(Icons.arrow_back_ios, color: Theme.of(context).colorScheme.onPrimary),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'mission_details'.tr,
                            style: Theme.of(
                              context,
                            ).appBarTheme.titleTextStyle!.copyWith(color: Theme.of(context).colorScheme.onPrimary),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
              Column(
                children: [
                  SizedBox(height: MediaQuery.of(context).padding.top + 50),
                  Padding(
                    padding: const EdgeInsets.only(left: 20, right: 20),
                    child: SizedBox(
                      width: double.infinity,
                      child: Card.filled(
                        elevation: 4,
                        child: Padding(
                          padding: const EdgeInsets.all(cardPadding + 8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  /*CircleAvatar(
                                    radius: 32,
                                    backgroundImage: NetworkImage(logic.mission.customerAvatar ?? ''),
                                  ),*/
                                  Container(
                                    width: 42,
                                    height: 42,
                                    padding: EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: Theme.of(context).colorScheme.outline,
                                      borderRadius: BorderRadius.circular(50),
                                    ),
                                    child: SvgPicture.asset(
                                      'assets/icons/user.svg',
                                      color: Theme.of(context).colorScheme.primary,
                                    ),
                                  ),
                                  SizedBox(width: 12),
                                  Expanded(
                                    child: Text(
                                      logic.mission.customerName ?? '',
                                      style: Theme.of(context).textTheme.headlineLarge,
                                    ),
                                  ),
                                  SizedBox(width: 12),
                                  Container(
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: BoxBorder.all(color: Theme.of(context).dividerColor, width: 1),
                                    ),
                                    child: InkWell(
                                      borderRadius: BorderRadius.circular(30),
                                      onTap: (){
                                        makeCall(logic.mission.customerPhone ?? '');
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: SvgPicture.asset(
                                          'assets/icons/call.svg',
                                          width: 16,
                                          height: 16,
                                          colorFilter: ColorFilter.mode(AppColors.callColor, BlendMode.srcIn),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 12),
                                  Container(
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: BoxBorder.all(color: Theme.of(context).dividerColor, width: 1),
                                    ),
                                    child: InkWell(
                                      borderRadius: BorderRadius.circular(30),
                                      onTap: (){
                                        openNavigation(logic.mission.customerLatitude ?? 0, logic.mission.customerLongitude ?? 0);
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: SvgPicture.asset(
                                          'assets/icons/navigation.svg',
                                          width: 16,
                                          height: 16,
                                          colorFilter: ColorFilter.mode(AppColors.routingColor, BlendMode.srcIn),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 12),
                              Row(
                                children: [
                                  SvgPicture.asset(
                                    'assets/icons/location.svg',
                                    color: Theme.of(context).disabledColor,
                                    width: 16,
                                  ),
                                  SizedBox(width: 8),
                                  Text(
                                    logic.mission.customerAddress ?? '',
                                    style: Theme.of(context).textTheme.titleMedium,
                                  ),
                                ],
                              ),
                              SizedBox(height: 8),
                              InkWell(
                                borderRadius: BorderRadius.circular(8),
                                onTap: (){
                                  logic.showChangeDateAndTimeBottomSheet();
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(8.0),
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).dividerColor.withAlpha(100),
                                    borderRadius: BorderRadius.circular(8)
                                  ),
                                  child: Row(
                                    children: [
                                      SvgPicture.asset(
                                        'assets/icons/calendar2.svg',
                                        color: Theme.of(context).disabledColor,
                                        width: 16,
                                      ),
                                      SizedBox(width: 8),
                                      Text(
                                        logic.mission.plannedStartDateTime!.substring(0, 10),
                                        style: Theme.of(context).textTheme.titleMedium,
                                      ),
                                      SizedBox(width: 32),
                                      SvgPicture.asset(
                                        'assets/icons/clock.svg',
                                        color: Theme.of(context).disabledColor,
                                        width: 16,
                                      ),
                                      SizedBox(width: 8),
                                      Text(
                                        logic.mission.plannedStartDateTime!.substring(11, 16),
                                        style: Theme.of(context).textTheme.titleMedium,
                                      ),
                                      SizedBox(width: 4),
                                      SvgPicture.asset(
                                        'assets/icons/arrow-long-right.svg',
                                        color: Theme.of(context).disabledColor,
                                      ),
                                      SizedBox(width: 4),
                                      Text(
                                        logic.mission.plannedEndDateTime!.substring(11, 16),
                                        style: Theme.of(context).textTheme.titleMedium,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              /* SizedBox(height: 12),
                              Row(
                                children: [
                                  SvgPicture.asset(
                                    'assets/icons/payment.svg',
                                    color: Theme.of(context).disabledColor,
                                    width: 16,
                                  ),
                                  SizedBox(width: 8),
                                  Text('120 €', style: Theme.of(context).textTheme.titleMedium),
                                ],
                              ),*/
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),

                  if (!logic.isLocationServiceOk)
                    Padding(
                      padding: const EdgeInsets.only(
                        top: bodyPadding,
                        bottom: bodyPadding,
                        left: bodyPadding * 2,
                        right: bodyPadding * 2,
                      ),
                      child: SecondaryButton(
                        label: 'Location access',
                        onPressed: () {
                          logic.checkMissionStatus(true);
                        },
                      ),
                    )
                  else
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 24, right: 24),
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              if (logic.actionType != null && logic.actionType == MissionActionType.done)
                                Padding(
                                  padding: const EdgeInsets.only(top: 24),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(cardRadius),
                                      border: BoxBorder.all(color: Theme.of(context).colorScheme.primary, width: 2),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          SvgPicture.asset('assets/icons/check.svg', width: 22),
                                          SizedBox(width: 8),
                                          Text(logic.actionType!.title, style: Theme.of(context).textTheme.labelLarge),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              if (logic.actionType != null && logic.actionType == MissionActionType.canceled)
                                Padding(
                                  padding: const EdgeInsets.only(top: 24),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(cardRadius),
                                      border: BoxBorder.all(color: Theme.of(context).colorScheme.primary, width: 2),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          SvgPicture.asset('assets/icons/cancel.svg',color: AppColors.red, width: 22),
                                          SizedBox(width: 8),
                                          Text(logic.actionType!.title, style: Theme.of(context).textTheme.labelLarge),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              if (logic.actionType != null && logic.actionType != MissionActionType.done)
                                Padding(
                                  padding: const EdgeInsets.only(top: 24),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(cardRadius),
                                      border: BoxBorder.all(color: Theme.of(context).colorScheme.primary, width: 2),
                                    ),
                                    child: InkWell(
                                      onTap: () => logic.handleActionTap(),
                                      child: Padding(
                                        padding: const EdgeInsets.all(16.0),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              logic.actionType!.title,
                                              style: Theme.of(context).textTheme.labelLarge,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              GridView.builder(
                                itemCount: logic.menuItems.length,
                                shrinkWrap: true,
                                physics: BouncingScrollPhysics(),
                                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2, // 👈 سه ستون
                                  mainAxisSpacing: 16, // فاصله عمودی بین آیتم‌ها
                                  crossAxisSpacing: 16, // فاصله افقی بین آیتم‌ها
                                  childAspectRatio: 1.2, // نسبت عرض به ارتفاع آیتم‌ها
                                ),
                                itemBuilder: (ctx, index) => _buildItem(logic.menuItems[index]),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  _buildItem(MenuModel menu) {
    return Container(
      decoration: BoxDecoration(color: menu.color.withAlpha(30), borderRadius: BorderRadius.circular(cardRadius)),
      child: InkWell(
        borderRadius: BorderRadius.circular(cardRadius),
        onTap: menu.callback,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(menu.icon, color: menu.color, width: 32),
              SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: Text(
                  menu.title,
                  style: Theme.of(context).textTheme.labelMedium,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MenuModel {
  final String title;
  final String icon;
  final Color color;
  final VoidCallback? callback;

  MenuModel({required this.title, required this.icon, required this.color, this.callback});
}
