import 'package:digi_care_pro/app/data/enum/support_type.dart';
import 'package:digi_care_pro/app/logic/support_logic.dart';
import 'package:digi_care_pro/app/ui/theme/app_dimens.dart';
import 'package:digi_care_pro/app/ui/widgets/app_dropdown_field.dart';
import 'package:digi_care_pro/app/ui/widgets/app_text_area_field.dart';
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

  String? selectedSubject;
  TextEditingController bodyController = TextEditingController();

  @override
  void initState() {
    Get.put(logic);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SupportLogic>(builder: (logic) {
      return Scaffold(
        appBar: AppBar(title: Text('support'.tr)),
        body: Padding(
          padding: const EdgeInsets.all(bodyPadding),
          child: Column(
            children: [
              AppDropdownField<SupportType>(
                title: 'subject'.tr,
                onChanged: (item) {
                  selectedSubject = item!.title;
                },
                items: SupportType.values.map((st) {
                  return DropdownMenuItem<SupportType>(
                    value: st,
                    child: Text(
                      st.title,
                      style: Theme
                          .of(context)
                          .textTheme
                          .labelMedium,
                    ),
                  );
                }).toList(),
              ),
              SizedBox(height: fieldSpace),
              AppTextAreaField(title: 'description'.tr, controller: bodyController,)
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
            label: 'send'.tr,
            onPressed: () {
              if(selectedSubject != null){
                logic.sendMessage(subject: selectedSubject!, body: bodyController.text);
              }else{
                snackError(message: 'subject_required'.tr);
              }
            },
          ),
        ),
      );
    });
  }
}
