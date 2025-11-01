import 'package:digi_care_pro/app/data/api/api_models/reset_password.dart';
import 'package:digi_care_pro/app/data/repositories/account_repository.dart';
import 'package:digi_care_pro/app/routes/app_routes.dart';
import 'package:digi_care_pro/app/ui/widgets/snack.dart';
import 'package:get/get.dart';

class ResetPasswordLogic extends GetxController {
  callApi({required String email, required String code, required String newPassword}) async {
    ResetPasswordRequest request = ResetPasswordRequest(
      email: email,
      code: code,
      newPassword: newPassword,
      confirmPassword: newPassword,
    );

    var result = await AccountRepository.get().resetPassword(request);

    result.fold(
      (error) {
        snackError(message: error.message);
      },
      (response) {
        Get.offAllNamed(Routes.LOGIN);

        snackSuccess(message: response.message);
      },
    );
  }
}
