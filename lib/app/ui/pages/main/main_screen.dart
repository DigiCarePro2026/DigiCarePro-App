import 'package:digi_care_pro/app/data/models/customer.dart';
import 'package:digi_care_pro/app/logic/main_logic.dart';
import 'package:digi_care_pro/app/routes/app_routes.dart';
import 'package:digi_care_pro/app/ui/pages/menu/customer_list_screen.dart';
import 'package:digi_care_pro/app/ui/pages/menu/profile_screen.dart';
import 'package:digi_care_pro/app/ui/pages/mission/missions_screen.dart';
import 'package:digi_care_pro/app/ui/theme/app_colors.dart';
import 'package:digi_care_pro/app/ui/widgets/animated_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class MainScreen extends StatefulWidget {
  int currentPage = 1;

  List<Widget> _pages = [];

  MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  MainLogic logic = MainLogic();

  Function(Customer?)? onCustomerSelected;

  @override
  void initState() {
    Get.put(logic);
    logic.setSelectedPage(widget.currentPage);

    widget._pages = [CustomerListScreen(), MissionsScreen(), ProfileScreen()];

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MainLogic>(
      builder: (logic) {
        return Scaffold(
          appBar: AppBar(
            title: _appBarTitle(),
            centerTitle: false,
            actionsPadding: EdgeInsets.only(right: 16),

            actions: [
              InkWell(
                borderRadius: BorderRadius.circular(16),
                onTap: () async {
                  await Get.toNamed(Routes.NOTIFICATIONS);
                  logic.getUnreadMessagesCount();
                },
                child: Container(
                  height: 32,
                  decoration: BoxDecoration(
                    border: BoxBorder.all(
                      color: Theme.of(context).colorScheme.outline,
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Wrap(
                      alignment: WrapAlignment.center,
                      children: [
                        SvgPicture.asset(
                          'assets/icons/notification.svg',
                          width: 16,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                        SizedBox(width: logic.unSeenMessageCount > 0 ? 8 : 0),
                        Visibility(
                          visible: logic.unSeenMessageCount > 0,
                          child: Container(
                            decoration: BoxDecoration(
                              color: AppColors.red,
                              shape: BoxShape.circle,
                            ),
                            constraints: BoxConstraints(
                              minWidth: 16,
                              minHeight: 16,
                            ),
                            child: Center(
                              child: Text(
                                logic.unSeenMessageCount.toString(),
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              // SizedBox(width: 12),
              // CircleAvatar(radius: 16, backgroundImage: AssetImage('assets/images/profile-sample.jpg')),
            ],
          ),
          body: Column(
            children: [
              Expanded(
                child: IndexedStack(
                  index: widget.currentPage,
                  children: widget._pages,
                ),
              ),
              Divider(height: 1, color: Theme.of(context).dividerColor),
            ],
          ),
          bottomNavigationBar: NavigationBar(
            selectedIndex: widget.currentPage,
            onDestinationSelected: (index) {
              setState(() {
                widget.currentPage = index;
              });
              logic.setSelectedPage(index);
            },
            destinations: [
              NavigationDestination(
                icon: SvgPicture.asset(
                  'assets/icons/users.svg',
                  color: Theme.of(context).colorScheme.onSurface,
                ),
                selectedIcon: SvgPicture.asset(
                  'assets/icons/users.svg',
                  color: Theme.of(context).colorScheme.primary,
                ),
                label: 'customer_list'.tr,
              ),
              NavigationDestination(
                icon: SvgPicture.asset(
                  'assets/icons/missions.svg',
                  color: Theme.of(context).colorScheme.onSurface,
                ),
                selectedIcon: SvgPicture.asset(
                  'assets/icons/missions.svg',
                  color: Theme.of(context).colorScheme.primary,
                ),
                label: 'missions'.tr,
              ),
              NavigationDestination(
                icon: SvgPicture.asset(
                  'assets/icons/user.svg',
                  color: Theme.of(context).colorScheme.onSurface,
                ),
                selectedIcon: SvgPicture.asset(
                  'assets/icons/user.svg',
                  color: Theme.of(context).colorScheme.primary,
                ),
                label: 'profile'.tr,
              ),
            ],
          ),
        );
      },
    );
  }

  _appBarTitle() {
    switch (widget.currentPage) {
      case 0:
        return Text('customer_list'.tr);

      case 1:
        return AnimatedSearchField(employeeCustomers: logic.employeeCustomers);

      case 2:
        return Text('profile'.tr);
    }
  }
}
