import 'package:digi_care_pro/app/ui/theme/app_colors.dart';
import 'package:digi_care_pro/app/ui/theme/app_dimens.dart';
import 'package:digi_care_pro/app/ui/widgets/search_bar_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class CustomerListScreen extends StatefulWidget {
  const CustomerListScreen({super.key});

  @override
  State<CustomerListScreen> createState() => _CustomerListScreenState();
}

class _CustomerListScreenState extends State<CustomerListScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SearchBarWidget(hintText: 'customer_list_search_hint'.tr, onChange: (term) {}),
          Expanded(child: ListView.builder(itemCount: 16, itemBuilder: (ctx, index) => _buildCustomerItem(index))),
        ],
      ),
    );
  }

  Widget _buildCustomerItem(int index) {
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
                      } else if (value == 'add_mission') {
                        print('add mission selected');
                      }
                    },
                    itemBuilder: (ctx) {
                      return [
                        PopupMenuItem(value: 'call', child: Text('call'.tr)),
                        PopupMenuItem(value: 'add_mission', child: Text('add_mission'.tr)),
                      ];
                    },
                  ),
                ],
              ),
              SizedBox(height: 12),
              Row(
                children: [
                  SvgPicture.asset('assets/icons/location.svg', width: 16, color: Theme.of(context).disabledColor),
                  SizedBox(width: 8),
                  Text('Max Mustermann Musterstraße 12', style: Theme.of(context).textTheme.titleMedium),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
