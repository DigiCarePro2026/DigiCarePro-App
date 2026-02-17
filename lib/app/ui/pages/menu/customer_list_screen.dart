import 'package:digi_care_pro/app/data/enum/page_status.dart';
import 'package:digi_care_pro/app/data/models/customer.dart';
import 'package:digi_care_pro/app/logic/customers_logic.dart';
import 'package:digi_care_pro/app/routes/app_routes.dart';
import 'package:digi_care_pro/app/ui/theme/app_colors.dart';
import 'package:digi_care_pro/app/ui/theme/app_dimens.dart';
import 'package:digi_care_pro/app/ui/theme/app_theme.dart';
import 'package:digi_care_pro/app/ui/widgets/app_popup_menu.dart';
import 'package:digi_care_pro/app/ui/widgets/search_bar_widget.dart';
import 'package:digi_care_pro/app/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:popup_menu_plus/popup_menu_plus.dart';

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
                        /* if (index == logic.customers.length - 1 && logic.paging.totalCount! > logic.customers.length) {
                          //detect end

                          logic.paging.page++;
                          logic.pageStatus = PageStatus.loadMore;

                          logic.getCustomers();
                        }*/

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
    final GlobalKey moreKey = GlobalKey();

    PopupMenu menu = PopupMenu(
      context: context,
      config: MenuConfig(
        backgroundColor: Theme.of(context).colorScheme.primary,
        lineColor: Color(0x33FFFFFF),
        highlightColor: Color(0x33FFFFFF),
      ),
      items: [
        PopUpMenuItem(
          title: 'call'.tr,
          image: Padding(
            padding: const EdgeInsets.all(4.0),
            child: SvgPicture.asset('assets/icons/call.svg', color: Theme.of(context).colorScheme.onPrimary),
          ),
          textStyle: Theme.of(context).textTheme.bodySmall!.copyWith(color: Theme.of(context).colorScheme.onPrimary),
        ),
        PopUpMenuItem(
          title: 'add_mission'.tr,
          image: Icon(Icons.traffic, color: Colors.white),
        ),
      ],
      onClickMenu: (item) {},
      onShow: () {},
      onDismiss: () {},
    );

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
                          child: SvgPicture.asset(
                            'assets/icons/user.svg',
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                        SizedBox(width: 12),
                        Text(customer.getFullName(), style: Theme.of(context).textTheme.labelLarge),
                      ],
                    ),
                  ),
                  AppPopupMenu(
                    items: [
                      if(customer.mobile != null || customer.phone != null)
                      AppPopupMenuItem(
                        title: 'call'.tr,
                        icon: SvgPicture.asset('assets/icons/call.svg', color: Colors.white),
                        onTap: () {
                          makeCall(customer.mobile ?? customer.phone!);
                        },
                      ),
                      AppPopupMenuItem(
                        title: 'add_mission'.tr,
                        icon: SvgPicture.asset('assets/icons/calendar-add.svg', color: Colors.white),
                        onTap: () {
                          Get.toNamed(Routes.CREATE_MISSION, arguments: customer.id);
                        },
                      ),
                    ],
                    child: SvgPicture.asset('assets/icons/more-hor.svg'),
                  ),
                ],
              ),
              SizedBox(height: 12),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SvgPicture.asset('assets/icons/location.svg', width: 16, color: Theme.of(context).disabledColor),
                  SizedBox(width: 8),
                  Expanded(child: Text(customer.address ?? '', style: Theme.of(context).textTheme.titleMedium)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
