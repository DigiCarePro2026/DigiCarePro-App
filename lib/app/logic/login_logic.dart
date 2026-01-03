import 'dart:io';

import 'package:digi_care_pro/app/data/api/api_models/login.dart';
import 'package:digi_care_pro/app/data/api/api_models/pre_login.dart';
import 'package:digi_care_pro/app/data/api/api_models/register_device.dart';
import 'package:digi_care_pro/app/data/api/api_provider.dart';
import 'package:digi_care_pro/app/data/models/company.dart';
import 'package:digi_care_pro/app/data/repositories/account_repository.dart';
import 'package:digi_care_pro/app/routes/app_routes.dart';
import 'package:digi_care_pro/app/ui/theme/app_dimens.dart';
import 'package:digi_care_pro/app/ui/widgets/primary_button.dart';
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

    result.fold(
      (error) {
        DialogHandler.hideLoading();

        snackError(message: error.message);
      },
      (response) {
        if (response.data!.companies.length > 1) {
          DialogHandler.hideLoading();

          Future.delayed(Duration(milliseconds: 200), () async {
            Company? selectedCompany = await showCompaniesBottomSheet(response.data!.companies);

            if (selectedCompany != null) {
              login(email: email, password: password, companyId: selectedCompany.companyId);
            }
          });
        } else {
          login(email: email, password: password, companyId: response.data!.companies.first.companyId);
        }
      },
    );
  }

  Future<Company?> showCompaniesBottomSheet(List<Company> companies) async {
    Company? selectedCompany;

    return await showModalBottomSheet(
      context: Get.context!,
      isScrollControlled: true,
      useSafeArea: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom + MediaQuery.of(context).padding.bottom,
            left: 16,
            right: 16,
            top: 20,
          ),
          child: StatefulBuilder(
            builder: (context, setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('chose_company'.tr, style: Theme.of(context).textTheme.headlineMedium),
                  const SizedBox(height: 8),
                  Text('chose_company_caption'.tr, style: Theme.of(context).textTheme.bodyMedium),
                  const SizedBox(height: 16),

                  RadioGroup<Company>(
                    groupValue: selectedCompany,
                    onChanged: (Company? value) {
                      setState(() {
                        selectedCompany = value;
                      });
                    },
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: companies.length,
                      itemBuilder: (ctx, index) {
                        return RadioListTile<Company>(
                          title: Text(companies[index].companyName),
                          value: companies[index],
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                  PrimaryButton(
                    label: 'login'.tr,
                    onPressed: () {
                      Navigator.pop(context, selectedCompany);
                    },
                  ),
                  const SizedBox(height: 20),
                ],
              );
            },
          ),
        );
      },
    );
  }

  login({required String email, required String password, required String companyId}) async {
    LoginRequest request = LoginRequest(email: email, password: password, companyId: companyId);

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
