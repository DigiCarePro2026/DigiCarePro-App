import 'dart:io';

import 'package:digi_care_pro/app/data/api/api_models/login.dart';
import 'package:digi_care_pro/app/data/api/api_models/register_device.dart';
import 'package:digi_care_pro/app/data/api/api_provider.dart';
import 'package:digi_care_pro/app/data/repositories/account_repository.dart';
import 'package:digi_care_pro/app/routes/app_routes.dart';
import 'package:digi_care_pro/app/ui/widgets/snack.dart';
import 'package:digi_care_pro/app/utils/globals.dart';
import 'package:digi_care_pro/app/utils/dialog_handler.dart';
import 'package:digi_care_pro/app/utils/utils.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';

class LoginLogic extends GetxController {
  login({required String email, required String password}) async {
    LoginRequest request = LoginRequest(email: email, password: password);

    var result = await AccountRepository.get().login(request, loadingMessage: 'loading_message_login'.tr);

    result.fold(
      (error) {
        snackError(message: error.message);
      },
      (response) async {
        AccountRepository.get().saveLoginInfo(response.data!);

        ApiProvider().setToken(response.data?.accessToken);

        await _registerDevice();
        await _getProfile();

        snackSuccess(message: response.message);
      },
    );
  }

  _registerDevice() async {
    String? deviceId = await getDeviceUniqueId();
    final String? fbToken = await FirebaseMessaging.instance.getToken();

    var result = await AccountRepository.get().registerDevice(
      RegisterDeviceRequest(deviceId: deviceId, deviceType: Platform.isAndroid ? 'Android' : 'Ios', token: fbToken),
    );

    result.fold((error) {}, (response) {});
  }

  _getProfile() async {
    var result = await AccountRepository.get().getProfile(loadingMessage: 'loading_message_get_profile'.tr);

    result.fold(
      (error) {
        snackError(message: error.message);
      },
      (response) {
        AccountRepository.get().saveProfileInfo(response.data!.toProfile());

        Get.offAllNamed(Routes.HOME);
      },
    );
  }
}
