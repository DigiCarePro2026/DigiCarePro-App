import 'package:digi_care_pro/app/ui/theme/app_colors.dart';
import 'package:digi_care_pro/app/ui/theme/app_dimens.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class MissionDetailsScreen extends StatefulWidget {
  const MissionDetailsScreen({super.key});

  @override
  State<MissionDetailsScreen> createState() => _MissionDetailsScreenState();
}

class _MissionDetailsScreenState extends State<MissionDetailsScreen> {
  List<MenuModel> menu = [
    MenuModel(title: 'routing'.tr, icon: 'assets/icons/routing.svg', color: AppColors.routingColor),
    MenuModel(title: 'call'.tr, icon: 'assets/icons/call.svg', color: AppColors.callColor),
    MenuModel(title: 'upload_document'.tr, icon: 'assets/icons/upload.svg', color: AppColors.uploadColor),
    MenuModel(title: 'add_mission'.tr, icon: 'assets/icons/add-mission.svg', color: AppColors.addMissionColor),
    MenuModel(title: 'customer_signature'.tr, icon: 'assets/icons/signature.svg', color: AppColors.signatureColor),
    MenuModel(title: 'submit_report'.tr, icon: 'assets/icons/report.svg', color: AppColors.reportColor),
    MenuModel(title: 'delay_report'.tr, icon: 'assets/icons/delay-report.svg', color: AppColors.delayReportColor),

  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            height: 250,
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
              SizedBox(height: Get.width < 400 ? 40 : 70),
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
              SizedBox(height: Get.width < 400 ? 100 : 130),
              Padding(
                padding: const EdgeInsets.only(left: 24, right: 24),
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
                              CircleAvatar(radius: 32, backgroundImage: AssetImage('assets/images/profile-sample.jpg')),
                              SizedBox(width: 12),
                              Text('Mostafa Babaie', style: Theme.of(context).textTheme.headlineLarge),
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
                              Text('Max Mustermann Musterstraße 12', style: Theme.of(context).textTheme.titleMedium),
                            ],
                          ),
                          SizedBox(height: 8),
                          Row(
                            children: [
                              SvgPicture.asset(
                                'assets/icons/calendar2.svg',
                                color: Theme.of(context).disabledColor,
                                width: 16,
                              ),
                              SizedBox(width: 8),
                              Text('2025/01/25', style: Theme.of(context).textTheme.titleMedium),
                              SizedBox(width: 32),
                              SvgPicture.asset(
                                'assets/icons/clock.svg',
                                color: Theme.of(context).disabledColor,
                                width: 16,
                              ),
                              SizedBox(width: 8),
                              Text('15:25', style: Theme.of(context).textTheme.titleMedium),
                              SizedBox(width: 4),
                              SvgPicture.asset(
                                'assets/icons/arrow-long-right.svg',
                                color: Theme.of(context).disabledColor,
                              ),
                              SizedBox(width: 4),
                              Text('17:00', style: Theme.of(context).textTheme.titleMedium),
                            ],
                          ),
                          SizedBox(height: 12),
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
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 10, right: 10),
                  child: GridView.builder(
                    itemCount: menu.length,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3, // 👈 سه ستون
                      mainAxisSpacing: 8, // فاصله عمودی بین آیتم‌ها
                      crossAxisSpacing: 0, // فاصله افقی بین آیتم‌ها
                      childAspectRatio: 1, // نسبت عرض به ارتفاع آیتم‌ها
                    ),
                    itemBuilder: (ctx, index) => _buildItem(menu[index]),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  _buildItem(MenuModel menu) {
    return InkWell(
      borderRadius: BorderRadius.circular(cardRadius),
      onTap: () {},
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: menu.color.withAlpha(30),
              borderRadius: BorderRadius.circular(cardRadius),
            ),
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: SvgPicture.asset(menu.icon, color: menu.color, width: 32),
            ),
          ),
          SizedBox(height: 12),
          Text(menu.title, style: Theme.of(context).textTheme.labelMedium),
          SizedBox(height: 8),
        ],
      ),
    );
  }
}

class MenuModel {
  final String title;
  final String icon;
  final Color color;

  MenuModel({required this.title, required this.icon, required this.color});
}
