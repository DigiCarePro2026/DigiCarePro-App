import 'package:digi_care_pro/app/data/models/support_employee.dart';
import 'package:digi_care_pro/app/logic/employee_list_logic.dart';
import 'package:digi_care_pro/app/ui/theme/app_dimens.dart';
import 'package:digi_care_pro/app/ui/widgets/search_bar_widget.dart';
import 'package:digi_care_pro/app/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class EmployeeListScreen extends StatefulWidget {
  const EmployeeListScreen({super.key});

  @override
  State<EmployeeListScreen> createState() => _EmployeeListScreenState();
}

class _EmployeeListScreenState extends State<EmployeeListScreen> {
  EmployeeListLogic logic = EmployeeListLogic();

  @override
  void initState() {
    Get.put(logic);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<EmployeeListLogic>(
      builder: (logic) {
        return Scaffold(
          appBar: AppBar(title: Text('employee_list'.tr)),
          body: Stack(
            children: [
              if (logic.employees.isEmpty) Center(child: CircularProgressIndicator()),
              if (logic.employees.isNotEmpty)
              ListView.builder(
                itemCount: logic.employees.length,
                itemBuilder: (ctx, index) => _buildEmployeeItem(logic.employees[index]),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildEmployeeItem(SupportEmployee employee) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, bottom: 8),
      child: Card.filled(
        child: Padding(
          padding: const EdgeInsets.all(cardPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        CircleAvatar(radius: 24, backgroundImage: AssetImage('assets/images/profile-sample.jpg')),
                        SizedBox(width: 12),
                        Text(employee.fullName, style: Theme.of(context).textTheme.labelLarge),
                      ],
                    ),
                  ),
                  PopupMenuButton(
                    icon: SvgPicture.asset('assets/icons/more-hor.svg'),
                    onSelected: (value) {
                      if (value == 'call') {
                       makeCall(employee.mobile ?? '');
                      }
                    },
                    itemBuilder: (ctx) {
                      return [PopupMenuItem(value: 'call', child: Text('call'.tr))];
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
