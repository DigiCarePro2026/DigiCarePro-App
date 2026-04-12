import 'package:digi_care_pro/app/logic/change_password_logic.dart';
import 'package:digi_care_pro/app/ui/theme/app_dimens.dart';
import 'package:digi_care_pro/app/ui/widgets/app_text_field.dart';
import 'package:digi_care_pro/app/ui/widgets/primary_button.dart';
import 'package:digi_care_pro/app/ui/widgets/snack.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  ChangePasswordLogic logic = ChangePasswordLogic();

  final TextEditingController _currentPassController = TextEditingController();
  final TextEditingController _newPassController = TextEditingController();
  final TextEditingController _confirmNewPassController = TextEditingController();

  @override
  void initState() {
    Get.put(logic);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ChangePasswordLogic>(
      builder: (logic) {
        return Scaffold(
          appBar: AppBar(title: Text('change_password'.tr), centerTitle: true),
          body: Padding(
            padding: const EdgeInsets.all(bodyPadding),
            child: Column(
              children: [
                AppTextField(
                  controller: _currentPassController,
                  title: 'current_password'.tr,
                  keyboardType: TextInputType.visiblePassword,
                ),
                SizedBox(height: 16),
                AppTextField(
                  controller: _newPassController,
                  title: 'new_password'.tr,
                  keyboardType: TextInputType.visiblePassword,
                ),
                SizedBox(height: 16),
                AppTextField(
                  controller: _confirmNewPassController,
                  title: 'confirm_password'.tr,
                  keyboardType: TextInputType.visiblePassword,
                ),
              ],
            ),
          ),
          bottomNavigationBar: Padding(
            padding: EdgeInsets.only(
              left: bodyPadding,
              right: bodyPadding,
              bottom: bodyPadding + MediaQuery.of(context).padding.bottom,
            ),
            child: PrimaryButton(
              label: 'change_password'.tr,
              onPressed: () {
                if (_currentPassController.text.isEmpty ||
                    _newPassController.text.isEmpty ||
                    _confirmNewPassController.text.isEmpty) {
                  snackError(message: 'all_fields_are_required'.tr);

                  return;
                }

                if (_newPassController.text != _confirmNewPassController.text) {
                  snackError(message: 'check_repeat_pass_message'.tr);
                  return;
                }

                logic.changePassword(
                  currentPassword: _currentPassController.text,
                  newPassword: _newPassController.text,
                );
              },
            ),
          ),
        );
      },
    );
  }
}
