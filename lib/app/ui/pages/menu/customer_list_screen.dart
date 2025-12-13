import 'package:digi_care_pro/app/data/enum/page_status.dart';
import 'package:digi_care_pro/app/data/models/customer.dart';
import 'package:digi_care_pro/app/logic/customers_logic.dart';
import 'package:digi_care_pro/app/routes/app_routes.dart';
import 'package:digi_care_pro/app/ui/theme/app_colors.dart';
import 'package:digi_care_pro/app/ui/theme/app_dimens.dart';
import 'package:digi_care_pro/app/ui/theme/app_theme.dart';
import 'package:digi_care_pro/app/ui/widgets/search_bar_widget.dart';
import 'package:digi_care_pro/app/utils/utils.dart';
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
          body: Column(
            children: [
              SearchBarWidget(hintText: 'customer_list_search_hint'.tr, onChange: logic.onSearchChanged),
              Expanded(
                child: Stack(
                  children: [
                    if (logic.pageStatus == PageStatus.loading) Center(child: CircularProgressIndicator()),
                    if (logic.pageStatus == PageStatus.empty)
                      Center(child: Text('empty_message'.tr, style: Theme.of(context).textTheme.titleMedium)),
                    ListView.builder(
                      itemCount: logic.customers.length,
                      itemBuilder: (ctx, index) {
                        if (index == logic.customers.length - 1 && logic.paging.totalCount! > logic.customers.length) {
                          //detect end

                          logic.paging.page++;
                          logic.pageStatus = PageStatus.loadMore;

                          logic.getCustomers();
                        }

                        return _buildCustomerItem(logic.customers[index]);
                      },
                    ),
                    if (logic.pageStatus == PageStatus.loadMore)
                      Positioned(bottom: 0, left: 0, right: 0, child: LinearProgressIndicator()),
                  ],
                ),
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
                        Container(
                          width: 24,
                          height: 24,
                          padding: EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.outline,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: SvgPicture.asset('assets/icons/user.svg', color: Theme.of(context).colorScheme.primary,),
                        ),
                        SizedBox(width: 12),
                        Text(customer.getFullName(), style: Theme.of(context).textTheme.labelLarge),
                      ],
                    ),
                  ),
                  PopupMenuButton(
                    icon: SvgPicture.asset('assets/icons/more-hor.svg'),
                    onSelected: (value) {
                      if (value == 'call') {
                        makeCall(customer.mobile ?? customer.phone!);
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
