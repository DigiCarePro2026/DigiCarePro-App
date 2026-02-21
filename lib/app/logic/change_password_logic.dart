import 'package:digi_care_pro/app/data/api/api_models/change_password.dart';
import 'package:digi_care_pro/app/data/repositories/account_repository.dart';
import 'package:digi_care_pro/app/ui/widgets/snack.dart';
import 'package:digi_care_pro/app/utils/dialog_handler.dart';
import 'package:get/get.dart';

class ChangePasswordLogic extends GetxController {
  changePassword({required String currentPassword, required String newPassword}) async {
    DialogHandler.showLoading('loading_default_message'.tr);

    ChangePasswordRequest request = ChangePasswordRequest(currentPassword: currentPassword, newPassword: newPassword);

    var result = await AccountRepository.get().changePassword(request);

    DialogHandler.hideLoading();

    result.fold(
      (error) {
        snackError(message: 'password_validation_message'.tr);
      },
      (response) {
        // hideLoading() closes asynchronously; delay page pop so we close this screen, not the loading dialog.
        Future.delayed(const Duration(milliseconds: 200), () {
          Get.back(result: true);
          snackSuccess(message: response.message);
        });
      },
    );
  }
}
