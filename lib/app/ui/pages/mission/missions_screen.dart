import 'package:digi_care_pro/app/data/enum/mission_type.dart';
import 'package:digi_care_pro/app/logic/missions_logic.dart';
import 'package:digi_care_pro/app/routes/app_routes.dart';
import 'package:digi_care_pro/app/ui/theme/app_colors.dart';
import 'package:digi_care_pro/app/ui/theme/app_dimens.dart';
import 'package:digi_care_pro/app/ui/widgets/calendar_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class MissionsScreen extends StatefulWidget {
  const MissionsScreen({super.key});

  @override
  State<MissionsScreen> createState() => _MissionsScreenState();
}

class _MissionsScreenState extends State<MissionsScreen> {

  MissionsLogic logic = MissionsLogic();
  MissionType _selectedMissionType = MissionType.all;

  @override
  void initState() {
    super.initState();

    Get.put(logic);
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MissionsLogic>(builder: (logic) {
      return Scaffold(
        body: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: CalendarWidget(
                      selectionMode: CalendarSelectionMode.single,
                      activeMinMaxMonth: 2,
                      onDateSelected: (date) => print("Selected: $date"),
                      events: {
                        DateTime(2025, 10, 10): [
                          Event(
                            title: "Meeting",
                            startTime: TimeOfDay(hour: 9, minute: 0),
                            endTime: TimeOfDay(hour: 10, minute: 0),
                          ),
                          Event(
                            title: "Meeting",
                            startTime: TimeOfDay(hour: 9, minute: 0),
                            endTime: TimeOfDay(hour: 10, minute: 0),
                          ),
                          Event(
                            title: "Meeting",
                            startTime: TimeOfDay(hour: 9, minute: 0),
                            endTime: TimeOfDay(hour: 10, minute: 0),
                          ),
                          Event(
                            title: "Meeting",
                            startTime: TimeOfDay(hour: 9, minute: 0),
                            endTime: TimeOfDay(hour: 10, minute: 0),
                          ),
                          Event(
                            title: "Meeting",
                            startTime: TimeOfDay(hour: 9, minute: 0),
                            endTime: TimeOfDay(hour: 10, minute: 0),
                          ),
                        ],
                      },
                    ),
                  ),
                ],
              ),
            ),
            SliverPersistentHeader(
              pinned: true,
              delegate: _ChipsHeaderDelegate(
                selectedMissionType: _selectedMissionType,
                onMissionTypeSelected: (missionType) {
                  setState(() {
                    _selectedMissionType = missionType;
                  });
                },
              ),
            ),
            SliverList(delegate: SliverChildBuilderDelegate(
                childCount: 20, (ctx, index) => _buildMissionItem(index))),
          ],
        ),
      );
    });
  }

  Widget _buildMissionItem(int index) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, bottom: 8),
      child: Card.filled(
        child: InkWell(
          borderRadius: BorderRadius.circular(cardRadius),
          onTap: () {
            Get.toNamed(Routes.MISSION_DETAILS);
          },
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
                          CircleAvatar(radius: 16, backgroundImage: AssetImage(
                              'assets/images/profile-sample.jpg')),
                          SizedBox(width: 12),
                          Text('Mostafa Babaie', style: Theme
                              .of(context)
                              .textTheme
                              .labelLarge),
                        ],
                      ),
                    ),
                    PopupMenuButton(
                      icon: SvgPicture.asset('assets/icons/more-hor.svg'),
                      onSelected: (value) {
                        // عمل مورد نظر برای هر آیتم
                        if (value == 'edit') {
                          print('Edit selected');
                        } else if (value == 'delete') {
                          print('Delete selected');
                        } else if (value == 'share') {
                          print('Share selected');
                        }
                      },
                      itemBuilder: (ctx) {
                        return [
                          PopupMenuItem(value: 'call', child: Text('call'.tr)),
                          PopupMenuItem(value: 'routing', child: Text(
                              'routing'.tr)),
                          PopupMenuItem(value: 'add_mission', child: Text(
                              'add_mission'.tr)),
                        ];
                      },
                    ),
                  ],
                ),
                Row(
                  children: [
                    SvgPicture.asset(
                      'assets/icons/location.svg',
                      color: Theme
                          .of(context)
                          .disabledColor,
                      width: 16,
                    ),
                    SizedBox(width: 8),
                    Text(
                      'Max Mustermann Musterstraße 12',
                      style: Theme
                          .of(
                        context,
                      )
                          .textTheme
                          .titleMedium,
                    ),
                  ],
                ),
                SizedBox(height: 8),
                Row(
                  children: [
                    SvgPicture.asset(
                      'assets/icons/calendar2.svg',
                      color: Theme
                          .of(context)
                          .disabledColor,
                      width: 16,
                    ),
                    SizedBox(width: 8),
                    Text(
                      '2025/01/25',
                      style: Theme
                          .of(
                        context,
                      )
                          .textTheme
                          .titleMedium,
                    ),
                    SizedBox(width: 32),
                    SvgPicture.asset(
                      'assets/icons/clock.svg',
                      color: Theme
                          .of(context)
                          .disabledColor,
                      width: 16,
                    ),
                    SizedBox(width: 8),
                    Text(
                      '15:25',
                      style: Theme
                          .of(
                        context,
                      )
                          .textTheme
                          .titleMedium,
                    ),
                    SizedBox(width: 4),
                    SvgPicture.asset(
                      'assets/icons/arrow-long-right.svg',
                      color: Theme
                          .of(context)
                          .disabledColor,
                    ),
                    SizedBox(width: 4),
                    Text(
                      '17:00',
                      style: Theme
                          .of(
                        context,
                      )
                          .textTheme
                          .titleMedium,
                    ),
                  ],
                ),
                Divider(height: 12, thickness: 0.5, color: Theme
                    .of(context)
                    .dividerColor),
                Row(
                  children: [
                    if (index % 3 == 1)
                      Expanded(
                        child: Text(
                          'Todo',
                          style: Theme
                              .of(context)
                              .textTheme
                              .titleSmall!
                              .copyWith(color: AppColors.missionNew),
                        ),
                      ),
                    if (index % 3 == 2)
                      Expanded(
                        child: Text(
                          'In progress',
                          style: Theme
                              .of(context)
                              .textTheme
                              .titleSmall!
                              .copyWith(color: AppColors.missionInProgress),
                        ),
                      ),
                    if (index % 3 == 0)
                      Expanded(
                        child: Text(
                          'Done',
                          style: Theme
                              .of(context)
                              .textTheme
                              .titleSmall!
                              .copyWith(color: AppColors.missionDone),
                        ),
                      ),
                    InkWell(
                      borderRadius: BorderRadius.circular(24),
                      onTap: () {},
                      child: SvgPicture.asset(
                          'assets/icons/arrow-right.svg', color: Theme
                          .of(context)
                          .disabledColor),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ChipsHeaderDelegate extends SliverPersistentHeaderDelegate {
  final MissionType selectedMissionType;
  final Function(MissionType) onMissionTypeSelected;

  _ChipsHeaderDelegate(
      {required this.selectedMissionType, required this.onMissionTypeSelected});

  @override
  Widget build(BuildContext context, double shrinkOffset,
      bool overlapsContent) {
    return Container(
      color: Theme
          .of(context)
          .colorScheme
          .surface,
      padding: const EdgeInsets.all(bodyPadding),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        physics: BouncingScrollPhysics(),
        child: Row(
          children: [
            _buildChipsItem(context, missionType: MissionType.all),
            _buildChipsItem(context, missionType: MissionType.todo),
            _buildChipsItem(context, missionType: MissionType.inProgress),
            _buildChipsItem(context, missionType: MissionType.done),
          ],
        ),
      ),
    );
  }

  Widget _buildChipsItem(BuildContext context,
      {required MissionType missionType}) {
    return Padding(
      padding: EdgeInsetsDirectional.only(end: 10.0),
      child: InkWell(
        borderRadius: BorderRadius.circular(24),
        onTap: () {
          onMissionTypeSelected(missionType);
        },
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: Theme
                .of(context)
                .colorScheme
                .primary
                .withAlpha(200), width: 1),
            borderRadius: BorderRadius.circular(24),
            color: selectedMissionType == missionType
                ? Theme
                .of(context)
                .colorScheme
                .primary
                : Theme
                .of(context)
                .colorScheme
                .surface,
          ),
          child: Padding(
            padding: const EdgeInsets.only(
                top: 0, bottom: 0, right: 12, left: 12),
            child: Row(
              children: [
                Text(
                  missionType.title,
                  style: Theme
                      .of(context)
                      .textTheme
                      .labelSmall!
                      .copyWith(
                    color: selectedMissionType == missionType
                        ? Theme
                        .of(context)
                        .colorScheme
                        .onPrimary
                        : Theme
                        .of(context)
                        .colorScheme
                        .primary
                        .withAlpha(150),
                  ),
                ),
                if (missionType == MissionType.all) SizedBox(width: 16),
                if (missionType == MissionType.all)
                  Container(
                    decoration: BoxDecoration(
                        color: AppColors.red, shape: BoxShape.circle),
                    constraints: BoxConstraints(minWidth: 20, minHeight: 20),
                    child: Center(
                      child: Text(
                        '23',
                        style: TextStyle(color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                if (missionType != MissionType.all)
                  Container(
                    decoration: BoxDecoration(
                        color: AppColors.red, shape: BoxShape.circle),
                    constraints: BoxConstraints(minWidth: 0, minHeight: 20),
                    child: Center(
                      child: Text(
                        '',
                        style: TextStyle(color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  double get maxExtent =>
      Get.width < 400 ? 63 : 64; // Adjust based on chip height + padding

  @override
  double get minExtent =>
      Get.width < 400 ? 63 : 64; // Same as maxExtent to prevent shrinking

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return oldDelegate is _ChipsHeaderDelegate &&
        (oldDelegate.selectedMissionType != selectedMissionType);
  }
}
