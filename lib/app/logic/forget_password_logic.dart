import 'package:digi_care_pro/app/data/api/api_models/forget_password.dart';
import 'package:digi_care_pro/app/data/repositories/account_repository.dart';
import 'package:digi_care_pro/app/routes/app_routes.dart';
import 'package:digi_care_pro/app/ui/widgets/snack.dart';
import 'package:get/get.dart';

class ForgetPasswordLogic extends GetxController {
  callApi({required String email}) async {
    ForgetPasswordRequest request = ForgetPasswordRequest(email: email);

    var result = await AccountRepository.get().forgetPassword(request, loadingMessage: 'loading_default_message'.tr);

    result.fold((error) {
      snackError(message: error.message);
    }, (response) {
      snackSuccess(message: response.message);

      Get.toNamed(Routes.RESET_PASSWORD, arguments: email);
    });
  }
}
