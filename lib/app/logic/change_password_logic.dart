import 'package:digi_care_pro/app/data/api/api_models/change_password.dart';
import 'package:digi_care_pro/app/data/repositories/account_repository.dart';
import 'package:digi_care_pro/app/ui/widgets/snack.dart';
import 'package:get/get.dart';

class ChangePasswordLogic extends GetxController {
  changePassword({required String currentPassword, required String newPassword}) async {
    ChangePasswordRequest request = ChangePasswordRequest(currentPassword: currentPassword, newPassword: newPassword);

    var result = await AccountRepository.get().changePassword(request);

    result.fold(
      (error) {
        snackError(message: error.message);
      },
      (response) {
        Get.back();

        snackSuccess(message: response.message);
      },
    );
  }
}
