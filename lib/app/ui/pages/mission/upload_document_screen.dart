import 'package:digi_care_pro/app/ui/theme/app_dimens.dart';
import 'package:digi_care_pro/app/ui/widgets/app_text_area_field.dart';
import 'package:digi_care_pro/app/ui/widgets/camera_capture_widget.dart';
import 'package:digi_care_pro/app/ui/widgets/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UploadDocumentScreen extends StatefulWidget {
  const UploadDocumentScreen({super.key});

  @override
  State<UploadDocumentScreen> createState() => _UploadDocumentScreenState();
}

class _UploadDocumentScreenState extends State<UploadDocumentScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('upload_document'.tr),),
      body: Padding(
        padding: const EdgeInsets.all(bodyPadding),
        child: SingleChildScrollView(
          child: Column(
            children: [
              CameraCaptureWidget(callback: (file){
                debugPrint('CameraCaptureWidget : ${file.path}');
                //fixme
              },),
              SizedBox(height: fieldSpace),
              AppTextAreaField(title: 'short_title'.tr),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.only(
          left: bodyPadding,
          right: bodyPadding,
          bottom: bodyPadding + MediaQuery.of(context).padding.bottom,
        ),
        child: PrimaryButton(
          label: 'upload'.tr,
          onPressed: () {

          },
        ),
      ),
    );
  }
}
