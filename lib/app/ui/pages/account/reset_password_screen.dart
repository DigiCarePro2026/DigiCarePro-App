import 'package:digi_care_pro/app/logic/reset_password_logic.dart';
import 'package:digi_care_pro/app/ui/theme/app_dimens.dart';
import 'package:digi_care_pro/app/ui/widgets/app_text_field.dart';
import 'package:digi_care_pro/app/ui/widgets/primary_button.dart';
import 'package:digi_care_pro/app/ui/widgets/snack.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ResetPasswordScreen extends StatefulWidget {
  ResetPasswordScreen({super.key, required this.email,});

  String email;

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {

  ResetPasswordLogic logic = ResetPasswordLogic();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _codeController = TextEditingController();
  final TextEditingController _newPassController = TextEditingController();
  final TextEditingController _confirmNewPassController = TextEditingController();

  @override
  void initState() {
    Get.put(logic);

    _emailController.text = widget.email;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ResetPasswordLogic>(builder: (logic) {
      return Scaffold(
        appBar: AppBar(title: Text('forget_password'.tr), centerTitle: true),
        body: Padding(
          padding: const EdgeInsets.all(bodyPadding),
          child: Column(
            children: [
              AppTextField(
                enabled: false,
                controller: _emailController,
                title: 'email'.tr,
                keyboardType: TextInputType.emailAddress,
              ),
              SizedBox(height: fieldSpace),
              AppTextField(
                controller: _codeController,
                title: 'verification_code'.tr,
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: fieldSpace),
              AppTextField(
                controller: _newPassController,
                title: 'new_password'.tr,
                keyboardType: TextInputType.visiblePassword,
              ),
              SizedBox(height: fieldSpace),
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
            bottom: bodyPadding + MediaQuery
                .of(context)
                .padding
                .bottom,
          ),
          child: PrimaryButton(
            label: 'reset_password'.tr,
            onPressed: () {
              if(_codeController.text.isEmpty || _newPassController.text.isEmpty || _confirmNewPassController.text.isEmpty){
                snackError(message: 'all_fields_are_required'.tr);
                return;
              }

              if (_newPassController.text != _confirmNewPassController.text) {
                snackError(message: 'check_repeat_pass_message'.tr);
                return;
              }

              logic.callApi(email: _emailController.text, code: _codeController.text, newPassword: _newPassController.text);
            },
          ),
        ),
      );
    });
  }
}
