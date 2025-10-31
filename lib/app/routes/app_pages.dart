import 'package:digi_care_pro/app/data/models/mission.dart';
import 'package:digi_care_pro/app/ui/pages/account/change_password_screen.dart';
import 'package:digi_care_pro/app/ui/pages/account/forget_password_screen.dart';
import 'package:digi_care_pro/app/ui/pages/account/login_screen.dart';
import 'package:digi_care_pro/app/ui/pages/main/main_screen.dart';
import 'package:digi_care_pro/app/ui/pages/main/notifications_screen.dart';
import 'package:digi_care_pro/app/ui/pages/menu/change_language_screen.dart';
import 'package:digi_care_pro/app/ui/pages/menu/customer_list_screen.dart';
import 'package:digi_care_pro/app/ui/pages/menu/employee_list_screen.dart';
import 'package:digi_care_pro/app/ui/pages/menu/employee_profile_screen.dart';
import 'package:digi_care_pro/app/ui/pages/menu/leave_request_screen.dart';
import 'package:digi_care_pro/app/ui/pages/menu/requests_screen.dart';
import 'package:digi_care_pro/app/ui/pages/menu/support_screen.dart';
import 'package:digi_care_pro/app/ui/pages/mission/create_mission_screen.dart';
import 'package:digi_care_pro/app/ui/pages/mission/mission_details_screen.dart';
import 'package:digi_care_pro/app/ui/pages/mission/signature_screen.dart';
import 'package:digi_care_pro/app/ui/pages/mission/upload_document_screen.dart';
import 'package:get/get.dart';
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
      name: Routes.FORGET_PASSWORD,
      page: () => const ForgetPasswordScreen(),
    ),
    GetPage(
      name: Routes.MISSION_DETAILS,
      page: () =>  MissionDetailsScreen(mission: Get.arguments as Mission,),
    ),
    GetPage(
      name: Routes.MISSION_UPLOAD_DOC,
      page: () => const UploadDocumentScreen(),
    ),
    GetPage(
      name: Routes.CREATE_MISSION,
      page: () => CreateMissionScreen(customerId: Get.arguments as String,),
    ),
    GetPage(
      name: Routes.MISSION_SIGNATURE,
      page: () => const SignatureScreen(),
    ),
    GetPage(
      name: Routes.EMPLOYEE_PROFILE,
      page: () => const EmployeeProfileScreen(),
    ),
    GetPage(
      name: Routes.EMPLOYEE_LIST,
      page: () => const EmployeeListScreen(),
    ),
    GetPage(
      name: Routes.CHANGE_PASSWORD,
      page: () => const ChangePasswordScreen(),
    ),
    GetPage(
      name: Routes.CHANGE_LANGUAGE,
      page: () => const ChangeLanguageScreen(),
    ),
    GetPage(
      name: Routes.NOTIFICATIONS,
      page: () => const NotificationsScreen(),
    ),
    GetPage(
      name: Routes.REQUESTS,
      page: () => const RequestsScreen(),
    ),
    GetPage(
      name: Routes.LEAVE_REQUEST,
      page: () => const LeaveRequestScreen(),
    ),
    GetPage(
      name: Routes.SUPPORT,
      page: () => const SupportScreen(),
    ),
  ];
}