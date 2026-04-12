import 'package:digi_care_pro/app/data/models/change_settings.dart';
import 'package:digi_care_pro/app/data/models/profile.dart';
import 'package:digi_care_pro/app/data/repositories/account_repository.dart';
import 'package:digi_care_pro/app/data/repositories/employee_repository.dart';
import 'package:digi_care_pro/app/routes/app_routes.dart';
import 'package:digi_care_pro/app/ui/widgets/snack.dart';
import 'package:digi_care_pro/app/utils/dialog_handler.dart';
import 'package:get/get.dart';

class ProfileLogic extends GetxController {
  late Profile profile;

  @override
  onInit() {
    super.onInit();

    _fetchProfile();
  }

  _fetchProfile() {
    profile = AccountRepository.get().fetchProfile();

    update();
  }

  changeEmployeeSettings(bool value) async {
    // DialogHandler.showLoading('change_employee_settings_message'.tr);

    var result = await EmployeeRepository.get().changeSettings(ChangeSettingsRequest(receiveNotifications: value));

    // DialogHandler.hideLoading();

    result.fold((error) {}, (response) {
      profile.receiveNotifications = value;

      // AccountRepository.get(). fixme: update pref

      snackSuccess(message: response.message!);
    });

    update();
  }

  logout() {
    AccountRepository.get().logout();

    Get.offAllNamed(Routes.LOGIN);
  }

  requestDeleteAccount() async {
    var result = await EmployeeRepository.get().deactivateAccount();

    result.fold((error) {}, (response) {
      logout();
    });
  }
}
