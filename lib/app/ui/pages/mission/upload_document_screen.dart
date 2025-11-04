import 'dart:io';

import 'package:camera/camera.dart';
import 'package:digi_care_pro/app/logic/upload_document_logic.dart';
import 'package:digi_care_pro/app/ui/theme/app_dimens.dart';
import 'package:digi_care_pro/app/ui/widgets/app_text_area_field.dart';
import 'package:digi_care_pro/app/ui/widgets/camera_capture_widget.dart';
import 'package:digi_care_pro/app/ui/widgets/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UploadDocumentScreen extends StatefulWidget {
  UploadDocumentScreen({super.key, required this.missionId, required this.customerId});

  String missionId, customerId;

  @override
  State<UploadDocumentScreen> createState() => _UploadDocumentScreenState();
}

class _UploadDocumentScreenState extends State<UploadDocumentScreen> {
  UploadDocumentLogic logic = UploadDocumentLogic();

  TextEditingController titleController = TextEditingController();
  XFile? capturedFile;

  @override
  void initState() {
    Get.put(logic);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<UploadDocumentLogic>(
      builder: (logic) {
        return Scaffold(
          appBar: AppBar(title: Text('upload_document'.tr)),
          body: Padding(
            padding: const EdgeInsets.all(bodyPadding),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  CameraCaptureWidget(
                    callback: (file) {
                      setState(() {
                        capturedFile = file;
                      });
                    },
                  ),
                  SizedBox(height: fieldSpace),
                  AppTextAreaField(title: 'short_title'.tr, controller: titleController),
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
              enabled: capturedFile != null,
              label: 'upload'.tr,
              onPressed: () async {
                final bytes = await capturedFile!.readAsBytes();

                logic.upload(widget.missionId, widget.customerId, titleController.text, bytes.toList());
              },
            ),
          ),
        );
      },
    );
  }
}
