import 'package:digi_care_pro/app/ui/theme/app_dimens.dart';
import 'package:digi_care_pro/app/ui/widgets/app_text_field.dart';
import 'package:digi_care_pro/app/ui/widgets/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final TextEditingController _currentPassController = TextEditingController();
  final TextEditingController _newPassController = TextEditingController();
  final TextEditingController _confirmNewPassController = TextEditingController();

  @override
  Widget build(BuildContext context) {
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
        padding: const EdgeInsets.all(bodyPadding),
        child: PrimaryButton(
          label: 'change_password'.tr,
          onPressed: () {
            // TODO: Handle password change logic
          },
        ),
      ),
    );
  }
}
