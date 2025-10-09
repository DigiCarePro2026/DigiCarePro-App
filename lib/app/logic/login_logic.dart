import 'package:digi_care_pro/app/data/api/api_models/login.dart';
import 'package:digi_care_pro/app/data/repositories/account_repository.dart';
import 'package:digi_care_pro/app/ui/widgets/snack.dart';
import 'package:digi_care_pro/app/utils/globals.dart';
import 'package:digi_care_pro/app/utils/loading_handler.dart';
import 'package:get/get.dart';

class LoginLogic extends GetxController {

  login({required String email, required String password}) async {
    LoadingHandler.showLoading('Logging in ...');

    LoginRequest request = LoginRequest(email: email, password: password);

    var result = await AccountRepository.get().login(request);

    Get.back();

    result.fold((error){
      snackError(message: error.message);
    }, (response){
      logger.i(response.toString());
    });
  }
}
