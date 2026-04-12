import 'package:digi_care_pro/app/data/api/api_provider.dart';
import 'package:digi_care_pro/app/data/constants/pref_key.dart';
import 'package:digi_care_pro/app/data/pref.dart';
import 'package:digi_care_pro/app/ui/theme/app_dimens.dart';
import 'package:digi_care_pro/app/ui/widgets/app_text_field.dart';
import 'package:digi_care_pro/app/ui/widgets/primary_button.dart';
import 'package:digi_care_pro/config/app_config.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SetBaseUrlScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SetBaseUrlScreenState();
}

class _SetBaseUrlScreenState extends State<SetBaseUrlScreen> {
  final TextEditingController _urlController = TextEditingController(text: defaultServerUrl);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Change Server url')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(bodyPadding),
          child: Column(
            children: [
              Expanded(
                child: Column(
                  children: [AppTextField(controller: _urlController, title: 'Server url')],
                ),
              ),
              PrimaryButton(
                label: 'save'.tr,
                onPressed: () {
                  Pref.setString(PrefKey.baseUrl, _urlController.text);

                  ApiProvider().setBaseUrl(_urlController.text);

                  Get.back();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
