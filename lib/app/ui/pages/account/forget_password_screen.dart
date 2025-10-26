import 'package:digi_care_pro/app/logic/forget_password_logic.dart';
import 'package:digi_care_pro/app/ui/theme/app_dimens.dart';
import 'package:digi_care_pro/app/ui/widgets/app_text_field.dart';
import 'package:digi_care_pro/app/ui/widgets/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ForgetPasswordScreen extends StatefulWidget {
  const ForgetPasswordScreen({super.key});

  @override
  State<ForgetPasswordScreen> createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {

  ForgetPasswordLogic logic = ForgetPasswordLogic();
  final TextEditingController _emailController = TextEditingController(text: 'admin@digicarepro.com');

  @override
  void initState() {
    Get.put(ForgetPasswordLogic());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ForgetPasswordLogic>(builder: (logic) {
      return Scaffold(
        appBar: AppBar(title: Text('forget_password'.tr), centerTitle: true),
        body: Padding(
          padding: const EdgeInsets.all(bodyPadding),
          child: Column(
            children: [
              AppTextField(
                controller: _emailController,
                title: 'email'.tr,
                keyboardType: TextInputType.emailAddress,
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
            label: 'submit'.tr,
            onPressed: () {
              logic.callApi(email: _emailController.text);
            },
          ),
        ),
      );
    });
  }
}
