import 'package:digi_care_pro/app/ui/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

snackError({required message}) {
  Get.rawSnackbar(
    snackStyle: SnackStyle.FLOATING,
    snackPosition: SnackPosition.TOP,
    margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
    backgroundColor: Colors.transparent,
    messageText: CustomSnackbarContent(
      message: message,
      backgroundColor: AppColors.red,
    ),
  );
}

snackSuccess({required message}) {
  Get.rawSnackbar(
    snackStyle: SnackStyle.FLOATING,
    snackPosition: SnackPosition.TOP,
    margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
    backgroundColor: Colors.transparent,
    messageText: CustomSnackbarContent(
      message: message,
      backgroundColor: AppColors.green,
    ),
  );
}

class CustomSnackbarContent extends StatelessWidget {
  final String message;
  final Color backgroundColor;

  CustomSnackbarContent({
    required this.message,
    required this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 5,
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min, // Wrap content width
        children: [
          Icon(Icons.error, color: Colors.white),
          SizedBox(width: 10),
          Flexible(
            child: Text(
              message,
              style: TextStyle(color: Colors.white),
              maxLines: null, // 👈 اجازه نمایش چند خط
              overflow: TextOverflow.visible, // 👈 متن بریده نشه
              softWrap: true, // 👈 متن در صورت طولانی بودن، wrap بشه
            ),
          ),
        ],
      ),
    );
  }
}
