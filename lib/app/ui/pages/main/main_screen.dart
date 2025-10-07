import 'package:digi_care_pro/app/ui/pages/main/home_screen.dart';
import 'package:digi_care_pro/app/ui/pages/menu/profile_screen.dart';
import 'package:digi_care_pro/app/ui/pages/mission/missions_screen.dart';
import 'package:digi_care_pro/app/ui/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class MainScreen extends StatefulWidget {
  int currentPage = 0;

  final List<Widget> _pages = [HomeScreen(), MissionsScreen(), ProfileScreen()];

  MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _appBarTitle(),
        actionsPadding: EdgeInsets.only(right: 16),
        actions: [
          InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: () {},
            child: Container(
              height: 32,
              decoration: BoxDecoration(
                border: BoxBorder.all(color: Theme.of(context).colorScheme.outline, width: 1),
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
                    SizedBox(width: 8),
                    Container(
                      decoration: BoxDecoration(color: AppColors.red, shape: BoxShape.circle),
                      constraints: BoxConstraints(minWidth: 16, minHeight: 16),
                      child: Center(
                        child: Text(
                          '23',
                          style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(width: 12),
          CircleAvatar(radius: 16, backgroundImage: AssetImage('assets/images/profile-sample.jpg')),
        ],
      ),
      body: Column(
        children: [
          Expanded(child: widget._pages[widget.currentPage]),
          Divider(height: 1, color: Theme.of(context).dividerColor),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: widget.currentPage,
        onDestinationSelected: (index) {
          setState(() {
            widget.currentPage = index;
          });
        },
        destinations: [
          NavigationDestination(
            icon: SvgPicture.asset('assets/icons/dashboard.svg', color: Theme.of(context).colorScheme.onSurface),
            selectedIcon: SvgPicture.asset('assets/icons/dashboard.svg', color: Theme.of(context).colorScheme.primary),
            label: 'dashboard'.tr,
          ),
          NavigationDestination(
            icon: SvgPicture.asset('assets/icons/missions.svg', color: Theme.of(context).colorScheme.onSurface),
            selectedIcon: SvgPicture.asset('assets/icons/missions.svg', color: Theme.of(context).colorScheme.primary),
            label: 'missions'.tr,
          ),
          NavigationDestination(
            icon: SvgPicture.asset('assets/icons/user.svg', color: Theme.of(context).colorScheme.onSurface),
            selectedIcon: SvgPicture.asset('assets/icons/user.svg', color: Theme.of(context).colorScheme.primary),
            label: 'profile'.tr,
          ),
        ],
      ),
    );
  }

  _appBarTitle() {
    switch (widget.currentPage) {
      case 0:
        return Text('dashboard'.tr);

      case 1:
        return Text('missions'.tr);

      case 2:
        return Text('profile'.tr);
    }
  }
}
