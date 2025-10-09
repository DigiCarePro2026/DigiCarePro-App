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
              SizedBox(height: 70),
              Row(
                children: [
                  SizedBox(width: 12),
                  InkWell(
                    borderRadius: BorderRadius.circular(20),
                    onTap: () => Get.back(),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SvgPicture.asset(
                        'assets/icons/arrow-left.svg',
                        color: Theme.of(context).colorScheme.onPrimary,
                      ),
                    ),
                  ),
                  SizedBox(width: 16),
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
          Column(
            children: [
              SizedBox(height: 130),
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
                          Text('Mostafa Babaie', style: Theme.of(context).textTheme.headlineLarge),
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
            ],
          ),
        ],
      ),
    );
  }
}
