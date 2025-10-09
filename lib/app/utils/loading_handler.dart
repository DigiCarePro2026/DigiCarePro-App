import 'package:digi_care_pro/app/ui/widgets/loading.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoadingHandler {
  static showLoading(String message) {
    showDialog(
      context: Get.context!,
      barrierDismissible: false,
      builder: (context) => LoadingScreen(message: message),
    );
  }
}
