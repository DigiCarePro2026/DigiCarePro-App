import 'package:digi_care_pro/app/logic/employee_profile_logic.dart';
import 'package:digi_care_pro/app/ui/theme/app_dimens.dart';
import 'package:digi_care_pro/app/ui/widgets/app_text_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EmployeeProfileScreen extends StatefulWidget {
  const EmployeeProfileScreen({super.key});

  @override
  State<EmployeeProfileScreen> createState() => _EmployeeProfileScreenState();
}

class _EmployeeProfileScreenState extends State<EmployeeProfileScreen> {
  EmployeeProfileLogic logic = EmployeeProfileLogic();

  @override
  void initState() {
    Get.put(logic);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<EmployeeProfileLogic>(
      builder: (logic) {
        return Scaffold(
          appBar: AppBar(title: Text('employee_profile'.tr)),
          body: Stack(
            children: [
              if (logic.employee == null) Container(),

              if (logic.employee != null)
                Padding(
                  padding: const EdgeInsets.all(bodyPadding),
                  child: Column(
                    children: [
                      AppTextField(
                        title: 'firstname'.tr,
                        controller: TextEditingController(text: logic.employee!.firstName),
                        enabled: false,
                      ),
                      SizedBox(height: fieldSpace),
                      AppTextField(
                        title: 'lastname'.tr,
                        controller: TextEditingController(text: logic.employee!.lastName),
                        enabled: false,
                      ),
                    ],
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
