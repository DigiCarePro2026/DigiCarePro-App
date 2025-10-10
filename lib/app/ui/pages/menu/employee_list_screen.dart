import 'package:digi_care_pro/app/ui/theme/app_dimens.dart';
import 'package:digi_care_pro/app/ui/widgets/search_bar_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class EmployeeListScreen extends StatefulWidget {
  const EmployeeListScreen({super.key});

  @override
  State<EmployeeListScreen> createState() => _EmployeeListScreenState();
}

class _EmployeeListScreenState extends State<EmployeeListScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('employee_list'.tr),),
      body: Column(
        children: [
          SearchBarWidget(hintText: 'employee_list_search_hint'.tr, onChange: (term) {}),
          Expanded(child: ListView.builder(itemCount: 16, itemBuilder: (ctx, index) => _buildEmployeeItem(index))),
        ],
      ),
    );
  }

  Widget _buildEmployeeItem(int index) {
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
                        Text('Mostafa Babaie', style: Theme.of(context).textTheme.labelLarge),
                      ],
                    ),
                  ),
                  PopupMenuButton(
                    icon: SvgPicture.asset('assets/icons/more-hor.svg'),
                    onSelected: (value) {
                      if (value == 'call') {
                        print('call selected');
                      }
                    },
                    itemBuilder: (ctx) {
                      return [
                        PopupMenuItem(value: 'call', child: Text('call'.tr)),
                      ];
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
