import 'package:digi_care_pro/app/data/enum/support_type.dart';
import 'package:digi_care_pro/app/data/models/message_receiver.dart';
import 'package:digi_care_pro/app/logic/support_logic.dart';
import 'package:digi_care_pro/app/ui/theme/app_dimens.dart';
import 'package:digi_care_pro/app/ui/widgets/app_dropdown_field.dart';
import 'package:digi_care_pro/app/ui/widgets/app_text_area_field.dart';
import 'package:digi_care_pro/app/ui/widgets/app_text_field.dart';
import 'package:digi_care_pro/app/ui/widgets/primary_button.dart';
import 'package:digi_care_pro/app/ui/widgets/snack.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SupportScreen extends StatefulWidget {
  const SupportScreen({super.key});

  @override
  State<SupportScreen> createState() => _SupportScreenState();
}

class _SupportScreenState extends State<SupportScreen> {
  SupportLogic logic = SupportLogic();

  bool isSupportMode = true;
  String? selectedSubject;
  String? selectedReceiver;
  TextEditingController subjectController = TextEditingController();
  TextEditingController bodyController = TextEditingController();

  @override
  void initState() {
    Get.put(logic);
    final args = Get.arguments;
    if (args is Map && args['mode'] == 'message') {
      isSupportMode = false;
      logic.getReceivers();
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SupportLogic>(
      builder: (logic) {
        return Scaffold(
          appBar: AppBar(title: Text(isSupportMode ? 'support'.tr : 'send_message'.tr)),
          body: GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () {
              FocusScope.of(context).unfocus();
            },
            child: Padding(
              padding: const EdgeInsets.all(bodyPadding),
              child: Column(
                children: [
                  if (isSupportMode)
                    AppTextField(
                      title: 'subject'.tr,
                      controller: subjectController,
                    )
                  else
                    AppDropdownField<SupportType>(
                      title: 'subject'.tr,
                      onChanged: (item) {
                        selectedSubject = item!.title;
                      },
                      items: SupportType.values
                          .where((st) => st != SupportType.payment)
                          .map((st) {
                        return DropdownMenuItem<SupportType>(
                          value: st,
                          child: Text(st.title, style: Theme.of(context).textTheme.labelMedium),
                        );
                      }).toList(),
                    ),
                  SizedBox(height: fieldSpace),
                  if (!isSupportMode) ...[
                    AppDropdownField<MessageReceiver>(
                      title: 'receiver'.tr,
                      onChanged: (item) {
                        selectedReceiver = item!.id;
                      },
                      items: logic.receivers.map((st) {
                        return DropdownMenuItem<MessageReceiver>(
                          value: st,
                          child: Text(st.fullName, style: Theme.of(context).textTheme.labelMedium),
                        );
                      }).toList(),
                    ),
                    SizedBox(height: fieldSpace),
                  ],
                  AppTextAreaField(title: 'description'.tr, controller: bodyController),
                ],
              ),
            ),
          ),
          bottomSheet: Padding(
            padding: EdgeInsets.only(
              left: bodyPadding,
              right: bodyPadding,
              bottom: bodyPadding + MediaQuery.of(context).padding.bottom,
            ),
            child: PrimaryButton(
              label: 'send'.tr,
              onPressed: () {
                if (isSupportMode && subjectController.text.trim().isEmpty) {
                  snackError(message: 'subject_required'.tr);

                  return;
                }

                if (!isSupportMode && selectedSubject == null) {
                  snackError(message: 'subject_required'.tr);

                  return;
                }

                if (bodyController.text.length < 5) {
                  snackError(message: 'support_body_length_validation'.tr);

                  return;
                }

                logic.sendMessage(
                  subject: isSupportMode ? subjectController.text.trim() : selectedSubject!,
                  receiverId: isSupportMode ? null : selectedReceiver,
                  body: bodyController.text,
                );
              },
            ),
          ),
        );
      },
    );
  }
}
