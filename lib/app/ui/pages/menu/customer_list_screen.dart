import 'package:digi_care_pro/app/data/models/customer.dart';
import 'package:digi_care_pro/app/logic/customers_logic.dart';
import 'package:digi_care_pro/app/routes/app_routes.dart';
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
  CustomersLogic logic = CustomersLogic();

  @override
  void initState() {
    Get.put(logic);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CustomersLogic>(
      builder: (logic) {
        return Scaffold(
          body: Stack(
            children: [
              if (logic.customers.isEmpty) Center(child: CircularProgressIndicator()),
              if (logic.customers.isNotEmpty)
                Column(
                  children: [
                    SearchBarWidget(hintText: 'customer_list_search_hint'.tr, onChange: (term) {}),
                    Expanded(
                      child: ListView.builder(
                        itemCount: logic.customers.length,
                        itemBuilder: (ctx, index) => _buildCustomerItem(logic.customers[index]),
                      ),
                    ),
                  ],
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCustomerItem(Customer customer) {
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
                        CircleAvatar(radius: 24, backgroundImage: NetworkImage(customer.profileImageUrl ?? '')),
                        SizedBox(width: 12),
                        Text(customer.getFullName(), style: Theme.of(context).textTheme.labelLarge),
                      ],
                    ),
                  ),
                  PopupMenuButton(
                    icon: SvgPicture.asset('assets/icons/more-hor.svg'),
                    onSelected: (value) {
                      if (value == 'call') {
                        logic.makeCall(customer.mobile ?? customer.phone!);
                      } else if (value == 'add_mission') {
                        Get.toNamed(Routes.CREATE_MISSION, arguments: customer.id);
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
                  Text(customer.address ?? '', style: Theme.of(context).textTheme.titleMedium),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
