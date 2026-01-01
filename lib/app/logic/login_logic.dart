import 'dart:io';

import 'package:digi_care_pro/app/data/api/api_models/login.dart';
import 'package:digi_care_pro/app/data/api/api_models/pre_login.dart';
import 'package:digi_care_pro/app/data/api/api_models/register_device.dart';
import 'package:digi_care_pro/app/data/api/api_provider.dart';
import 'package:digi_care_pro/app/data/repositories/account_repository.dart';
import 'package:digi_care_pro/app/routes/app_routes.dart';
import 'package:digi_care_pro/app/ui/widgets/snack.dart';
import 'package:digi_care_pro/app/utils/dialog_handler.dart';
import 'package:digi_care_pro/app/utils/utils.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class LoginLogic extends GetxController {
  getCompaniesAndLogin({required String email, required String password}) async {
    PreLoginRequest request = PreLoginRequest(email: email);

    DialogHandler.showLoading('loading_message_login'.tr);

    var result = await AccountRepository.get().preLogin(request);

    DialogHandler.hideLoading();

    result.fold(
      (error) {
        snackError(message: error.message);
      },
      (response) {
        if (response.data!.companies.length > 1) {
          snackSuccess(message: 'multi company');
        } else {
          login(email: email, password: password);
        }
      },
    );
  }

  login({required String email, required String password}) async {
    LoginRequest request = LoginRequest(email: email, password: password);

    DialogHandler.showLoading('loading_message_login'.tr);

    var result = await AccountRepository.get().login(request);

    result.fold(
      (error) {
        DialogHandler.hideLoading();

        snackError(message: error.message);
      },
      (response) async {
        DialogHandler.hideLoading();

        AccountRepository.get().saveLoginInfo(response.data!);

        ApiProvider().setToken(response.data?.accessToken);

        TextInput.finishAutofillContext();

        if (!kIsWeb) {
          await _registerDevice();
        }

        await _getProfile();

        // snackSuccess(message: response.message);
      },
    );
  }

  _registerDevice() async {
    String? deviceId = await getDeviceUniqueId();

    if (Platform.isAndroid) {
      final String? fbToken = await FirebaseMessaging.instance.getToken();

      debugPrint('firebase token : $fbToken');

      var result = await AccountRepository.get().registerDevice(
        RegisterDeviceRequest(deviceId: deviceId, deviceType: Platform.isAndroid ? 'Android' : 'Ios', token: fbToken),
      );

      result.fold((error) {}, (response) {});
    }
  }

  _getProfile() async {
    DialogHandler.showLoading('loading_message_get_profile'.tr);

    var result = await AccountRepository.get().getProfile();

    DialogHandler.hideLoading();

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
