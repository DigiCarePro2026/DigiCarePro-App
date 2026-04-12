import 'package:digi_care_pro/app/ui/widgets/confirm_dialog.dart';
import 'package:digi_care_pro/app/ui/widgets/loading.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DialogHandler {
  static showLoading(String message) {
    if (Get.isDialogOpen == true) return;

    Get.dialog(
      LoadingScreen(message: message),
      barrierDismissible: false,
      routeSettings: const RouteSettings(name: 'loading_dialog'),
    );
  }

  static hideLoading() {
    return Future.microtask(() {
      final navigator = Get.rawRoute?.navigator;
      if (navigator == null) return;

      navigator.popUntil((route) {
        // تا وقتی loading_dialog هست، pop کن
        if (route.settings.name == 'loading_dialog') {
          return false;
        }

        // به اولین route غیر loading که رسیدیم، stop
        return true;
      });
    });
  }

  static showConfirm({required String title, required String message, required List<DialogButtonModel> buttons}) {
    showDialog(
      context: Get.context!,
      barrierColor: Colors.black.withAlpha(65),
      builder: (context) => FrostedGlassDialog(title: title, message: message, buttons: buttons),
    );
  }
}
