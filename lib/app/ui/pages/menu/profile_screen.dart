import 'package:digi_care_pro/app/logic/profile_logic.dart';
import 'package:digi_care_pro/app/routes/app_pages.dart';
import 'package:digi_care_pro/app/routes/app_routes.dart';
import 'package:digi_care_pro/app/ui/theme/app_colors.dart';
import 'package:digi_care_pro/app/ui/theme/app_dimens.dart';
import 'package:digi_care_pro/app/ui/widgets/confirm_dialog.dart';
import 'package:digi_care_pro/app/ui/widgets/secondary_button.dart';
import 'package:digi_care_pro/app/utils/dialog_handler.dart';
import 'package:digi_care_pro/app/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  ProfileLogic logic = ProfileLogic();

  @override
  void initState() {
    super.initState();

    Get.put(logic);
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProfileLogic>(
      builder: (logic) {
        return Scaffold(
          body: Padding(
            padding: const EdgeInsets.all(bodyPadding),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CircleAvatar(radius: 24, backgroundImage: AssetImage('assets/images/profile-sample.jpg')),
                      SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(logic.profile.fullName, style: Theme.of(context).textTheme.labelLarge),
                            SizedBox(height: 6),
                            Text(
                              logic.profile.email,
                              style: Theme.of(
                                context,
                              ).textTheme.labelMedium!.copyWith(color: Theme.of(context).colorScheme.primary),
                            ),
                          ],
                        ),
                      ),
                      InkWell(
                        borderRadius: BorderRadius.circular(12),
                        onTap: () => Get.toNamed(Routes.EMPLOYEE_PROFILE),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SvgPicture.asset(
                            'assets/icons/edit.svg',
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 32),
                  Text('DigiCare'.tr, style: Theme.of(context).textTheme.titleMedium),
                  SizedBox(height: 8),
                  Container(
                    decoration: BoxDecoration(
                      border: BoxBorder.all(color: Theme.of(context).dividerColor, width: 1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        InkWell(
                          onTap: () => Get.toNamed(Routes.EMPLOYEE_LIST),
                          borderRadius: BorderRadius.circular(12),
                          child: Padding(
                            padding: const EdgeInsets.all(profileItemPadding),
                            child: Row(
                              children: [
                                SvgPicture.asset('assets/icons/employee.svg', color: Color(0xFF56B8E4)),
                                SizedBox(width: 12),
                                Expanded(
                                  child: Text('employee_list'.tr, style: Theme.of(context).textTheme.labelMedium),
                                ),
                                SvgPicture.asset(
                                  'assets/icons/arrow-right.svg',
                                  color: Theme.of(context).disabledColor,
                                ),
                              ],
                            ),
                          ),
                        ),
                        Divider(
                          height: 1,
                          color: Theme.of(context).dividerColor,
                          indent: profileItemPadding,
                          endIndent: profileItemPadding,
                        ),
                        InkWell(
                          onTap: () => Get.toNamed(Routes.REQUESTS),
                          borderRadius: BorderRadius.circular(12),
                          child: Padding(
                            padding: const EdgeInsets.all(profileItemPadding),
                            child: Row(
                              children: [
                                SvgPicture.asset('assets/icons/calendar.svg', color: Color(0xFFF99234)),
                                SizedBox(width: 12),
                                Expanded(child: Text('requests'.tr, style: Theme.of(context).textTheme.labelMedium)),
                                SvgPicture.asset(
                                  'assets/icons/arrow-right.svg',
                                  color: Theme.of(context).disabledColor,
                                ),
                              ],
                            ),
                          ),
                        ),
                        Divider(
                          height: 1,
                          color: Theme.of(context).dividerColor,
                          indent: profileItemPadding,
                          endIndent: profileItemPadding,
                        ),
                        InkWell(
                          onTap: () => Get.toNamed(Routes.TIMESHEET),
                          borderRadius: BorderRadius.circular(12),
                          child: Padding(
                            padding: const EdgeInsets.all(profileItemPadding),
                            child: Row(
                              children: [
                                SvgPicture.asset('assets/icons/time-square.svg', color: Color(0xFF59BBB4)),
                                SizedBox(width: 12),
                                Expanded(child: Text('timesheet'.tr, style: Theme.of(context).textTheme.labelMedium)),
                                SvgPicture.asset(
                                  'assets/icons/arrow-right.svg',
                                  color: Theme.of(context).disabledColor,
                                ),
                              ],
                            ),
                          ),
                        ),
                        Divider(
                          height: 1,
                          color: Theme.of(context).dividerColor,
                          indent: profileItemPadding,
                          endIndent: profileItemPadding,
                        ),
                        InkWell(
                          onTap: () {},
                          borderRadius: BorderRadius.circular(12),
                          child: Padding(
                            padding: const EdgeInsets.all(profileItemPadding),
                            child: Row(
                              children: [
                                SvgPicture.asset('assets/icons/money-send.svg', color: Color(0xFFF4B5A5)),
                                SizedBox(width: 12),
                                Expanded(child: Text('payroll'.tr, style: Theme.of(context).textTheme.labelMedium)),
                                SvgPicture.asset(
                                  'assets/icons/arrow-right.svg',
                                  color: Theme.of(context).disabledColor,
                                ),
                              ],
                            ),
                          ),
                        ),
                        Divider(
                          height: 1,
                          color: Theme.of(context).dividerColor,
                          indent: profileItemPadding,
                          endIndent: profileItemPadding,
                        ),
                        InkWell(
                          onTap: () => Get.toNamed(Routes.SUPPORT),
                          borderRadius: BorderRadius.circular(12),
                          child: Padding(
                            padding: const EdgeInsets.all(profileItemPadding),
                            child: Row(
                              children: [
                                SvgPicture.asset('assets/icons/support.svg', color: Color(0xFFA685DB)),
                                SizedBox(width: 12),
                                Expanded(child: Text('support'.tr, style: Theme.of(context).textTheme.labelMedium)),
                                SvgPicture.asset(
                                  'assets/icons/arrow-right.svg',
                                  color: Theme.of(context).disabledColor,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 24),
                  Text('account'.tr, style: Theme.of(context).textTheme.titleMedium),
                  SizedBox(height: 8),
                  Container(
                    decoration: BoxDecoration(
                      border: BoxBorder.all(color: Theme.of(context).dividerColor, width: 1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        InkWell(
                          onTap: () => Get.toNamed(Routes.CHANGE_PASSWORD),
                          borderRadius: BorderRadius.circular(12),
                          child: Padding(
                            padding: const EdgeInsets.all(profileItemPadding),
                            child: Row(
                              children: [
                                SvgPicture.asset('assets/icons/lock.svg', color: Color(0xFFF6353D)),
                                SizedBox(width: 12),
                                Expanded(
                                  child: Text('change_password'.tr, style: Theme.of(context).textTheme.labelMedium),
                                ),
                                SvgPicture.asset(
                                  'assets/icons/arrow-right.svg',
                                  color: Theme.of(context).disabledColor,
                                ),
                              ],
                            ),
                          ),
                        ),
                        Divider(
                          height: 1,
                          color: Theme.of(context).dividerColor,
                          indent: profileItemPadding,
                          endIndent: profileItemPadding,
                        ),
                        InkWell(
                          onTap: () {},
                          borderRadius: BorderRadius.circular(12),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4, horizontal: profileItemPadding),
                            child: Row(
                              children: [
                                SvgPicture.asset('assets/icons/notif.svg', color: Color(0xFF45B19D)),
                                SizedBox(width: 12),
                                Expanded(
                                  child: Text('remind_mission'.tr, style: Theme.of(context).textTheme.labelMedium),
                                ),
                                Switch(
                                  value: logic.profile.receiveNotifications,
                                  onChanged: (value) {
                                    logic.changeEmployeeSettings(value);
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 24),
                  Text('more'.tr, style: Theme.of(context).textTheme.titleMedium),
                  SizedBox(height: 8),
                  Container(
                    decoration: BoxDecoration(
                      border: BoxBorder.all(color: Theme.of(context).dividerColor, width: 1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        InkWell(
                          onTap: () => Get.toNamed(Routes.CHANGE_LANGUAGE),
                          borderRadius: BorderRadius.circular(12),
                          child: Padding(
                            padding: const EdgeInsets.all(profileItemPadding),
                            child: Row(
                              children: [
                                SvgPicture.asset('assets/icons/language.svg', color: Color(0xFF4798F0)),
                                SizedBox(width: 12),
                                Expanded(
                                  child: Text('change_language'.tr, style: Theme.of(context).textTheme.labelMedium),
                                ),
                                SvgPicture.asset(
                                  'assets/icons/arrow-right.svg',
                                  color: Theme.of(context).disabledColor,
                                ),
                              ],
                            ),
                          ),
                        ),
                        Divider(
                          height: 1,
                          color: Theme.of(context).dividerColor,
                          indent: profileItemPadding,
                          endIndent: profileItemPadding,
                        ),
                        InkWell(
                          onTap: () {
                            showSOSBottomSheet();
                          },
                          borderRadius: BorderRadius.circular(12),
                          child: Padding(
                            padding: const EdgeInsets.all(profileItemPadding),
                            child: Row(
                              children: [
                                SvgPicture.asset('assets/icons/calendar.svg', color: Color(0xFFB744D4)),
                                SizedBox(width: 12),
                                Expanded(child: Text('sos'.tr, style: Theme.of(context).textTheme.labelMedium)),
                                SvgPicture.asset(
                                  'assets/icons/arrow-right.svg',
                                  color: Theme.of(context).disabledColor,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 32),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      InkWell(
                        borderRadius: BorderRadius.circular(8),
                        onTap: () {
                          DialogHandler.showConfirm(
                            title: 'log_out'.tr,
                            message: 'logout_message'.tr,
                            buttons: [
                              DialogButtonModel(
                                label: 'logout'.tr,
                                labelColor: AppColors.red,
                                onTap: () {
                                  logic.logout();
                                },
                              ),
                            ],
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(left: 32, right: 32, top: 12.0, bottom: 12),
                          child: Wrap(
                            alignment: WrapAlignment.center,
                            children: [
                              SvgPicture.asset('assets/icons/logout.svg', color: AppColors.red),
                              SizedBox(width: 16),
                              Text(
                                'logout'.tr,
                                style: Theme.of(context).textTheme.labelMedium!.copyWith(color: AppColors.red),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  showSOSBottomSheet() async {
    return await showModalBottomSheet(
      context: Get.context!,
      isScrollControlled: true,
      useSafeArea: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom + MediaQuery.of(context).padding.bottom,
            left: 16,
            right: 16,
            top: 20,
          ),
          child: StatefulBuilder(
            builder: (context, setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('sos'.tr, style: Theme.of(context).textTheme.headlineMedium),
                  const SizedBox(height: 16),
                  _sosItem(icon: 'assets/icons/police.svg', title: 'police'.tr, callNumber: '110'),
                  _sosItem(icon: 'assets/icons/ambulance.svg', title: 'ambulance'.tr, callNumber: '112'),
                  _sosItem(icon: 'assets/icons/doctor.svg', title: 'doctor'.tr, callNumber: '116117'),
                  _sosItem(icon: 'assets/icons/company.svg', title: 'company'.tr, callNumber: '022824066802'),
                  SecondaryButton(label: 'cancel'.tr, onPressed: () => Navigator.pop(context, null)),
                  const SizedBox(height: 20),
                ],
              );
            },
          ),
        );
      },
    );
  }

  Widget _sosItem({required String icon, required String title, required String callNumber}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Card.filled(
        child: InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: () {
            makeCall(callNumber);
          },
          child: Padding(
            padding: const EdgeInsets.all(cardPadding),
            child: Row(children: [SvgPicture.asset(icon,width:36,), SizedBox(width: 16), Text(title, style: Theme.of(context).textTheme.labelLarge,)]),
          ),
        ),
      ),
    );
  }
}
