import 'package:digi_care_pro/app/ui/pages/account/login_screen.dart';
import 'package:digi_care_pro/app/ui/pages/main/main_screen.dart';
import 'package:digi_care_pro/app/ui/pages/mission/mission_details_screen.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';

import 'app_routes.dart';

class AppPages {
  static final pages = [
    GetPage(
      name: Routes.HOME,
      page: () =>  MainScreen(),
    ),
    GetPage(
      name: Routes.LOGIN,
      page: () => const LoginScreen(),
    ),
    GetPage(
      name: Routes.MISSION_DETAILS,
      page: () => const MissionDetailsScreen(),
    ),
  ];
}