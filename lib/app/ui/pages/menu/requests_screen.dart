import 'package:digi_care_pro/app/data/enum/leave_status.dart';
import 'package:digi_care_pro/app/data/enum/leave_type.dart';
import 'package:digi_care_pro/app/data/models/day_off.dart';
import 'package:digi_care_pro/app/logic/requests_logic.dart';
import 'package:digi_care_pro/app/routes/app_routes.dart';
import 'package:digi_care_pro/app/ui/theme/app_colors.dart';
import 'package:digi_care_pro/app/ui/theme/app_dimens.dart';
import 'package:digi_care_pro/app/ui/widgets/app_dropdown_field.dart';
import 'package:digi_care_pro/app/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class RequestsScreen extends StatefulWidget {
  const RequestsScreen({super.key});

  @override
  State<RequestsScreen> createState() => _RequestsScreenState();
}

class _RequestsScreenState extends State<RequestsScreen> {
  RequestsLogic logic = RequestsLogic();

  @override
  void initState() {
    Get.put(logic);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<RequestsLogic>(
      builder: (logic) {
        return Scaffold(
          appBar: AppBar(title: Text('requests'.tr), centerTitle: true),
          body: logic.requests.isEmpty
              ? Center(child: Text('empty_message'.tr, style: Theme.of(context).textTheme.titleMedium))
              : Padding(
                padding: const EdgeInsets.all(bodyPadding),
                child: Column(
                  children: [
                    AppDropdownField<String>(
                      value: logic.selectedMonth ?? (logic.months.isEmpty ? '' : logic.months[0]),
                      title: 'timesheet_month_title'.tr,
                      items: logic.months.map((m) => DropdownMenuItem<String>(value: m, child: Text(m))).toList(),
                      onChanged: (item) {
                        logic.selectedMonth = item;

                        logic.getRequests();
                      },
                    ),
                    SizedBox(height: 12),
                    Expanded(
                      child: ListView.builder(
                          itemCount: logic.requests.length,
                          itemBuilder: (ctx, index) => _buildItem(logic.requests[index]),
                        ),
                    ),
                  ],
                ),
              ),
          floatingActionButton: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              borderRadius: BorderRadius.circular(cardRadius),
            ),
            child: InkWell(
              onTap: () async {
                bool update = await Get.toNamed(Routes.LEAVE_REQUEST);

                if (update) {
                  logic.getRequests();
                }
              },
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Wrap(
                  runAlignment: WrapAlignment.center,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    SvgPicture.asset('assets/icons/plus.svg', color: Theme.of(context).colorScheme.onPrimary),
                    SizedBox(width: 12),
                    Text(
                      'New Request',
                      style: Theme.of(context).textTheme.labelMedium!.copyWith(
                        color: Theme.of(context).colorScheme.onPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildItem(DayOff request) {
    return Card.filled(
      child: InkWell(
        borderRadius: BorderRadius.circular(cardRadius),
        onTap: () {},
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
                        Text(formatDateShort(request.startDate), style: Theme.of(context).textTheme.labelLarge),
                        SizedBox(width: 4),
                        SvgPicture.asset('assets/icons/arrow-long-right.svg', color: Theme.of(context).disabledColor),
                        SizedBox(width: 4),
                        Text(formatDateShort(request.endDate), style: Theme.of(context).textTheme.labelLarge),
                      ],
                    ),
                  ),
                  if (request.status != LeaveStatus.canceled)
                    PopupMenuButton(
                      icon: SvgPicture.asset('assets/icons/more-hor.svg'),
                      onSelected: (value) {
                        if (value == 'cancel') {
                          logic.cancelRequest(request.id);
                        }
                      },
                      itemBuilder: (ctx) {
                        return [PopupMenuItem(value: 'cancel', child: Text('cancel'.tr))];
                      },
                    ),
                ],
              ),
              Text(request.description ?? '', style: Theme.of(context).textTheme.titleMedium),
              Row(
                children: [
                  Text('Reason:', style: Theme.of(context).textTheme.titleMedium),
                  SizedBox(width: 12),
                  Text(LeaveType.values[request.leaveType - 1].title, style: Theme.of(context).textTheme.titleMedium),
                ],
              ),
              Divider(height: 12, thickness: 0.5, color: Theme.of(context).dividerColor),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      request.status.title,
                      style: Theme.of(context).textTheme.titleSmall!.copyWith(color: request.status.color),
                    ),
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
