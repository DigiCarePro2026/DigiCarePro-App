import 'package:digi_care_pro/app/data/enum/mission_status.dart';
import 'package:digi_care_pro/app/data/models/mission.dart';
import 'package:digi_care_pro/app/logic/missions_logic.dart';
import 'package:digi_care_pro/app/routes/app_routes.dart';
import 'package:digi_care_pro/app/ui/theme/app_colors.dart';
import 'package:digi_care_pro/app/ui/theme/app_dimens.dart';
import 'package:digi_care_pro/app/ui/widgets/app_popup_menu.dart';
import 'package:digi_care_pro/app/ui/widgets/calendar_widget.dart';
import 'package:digi_care_pro/app/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class MissionsScreen extends StatefulWidget {
  MissionsScreen({super.key});

  @override
  State<MissionsScreen> createState() => _MissionsScreenState();
}

class _MissionsScreenState extends State<MissionsScreen> {
  MissionsLogic logic = MissionsLogic();

  @override
  void initState() {
    super.initState();

    Get.put(logic);
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MissionsLogic>(
      builder: (logic) {
        return Scaffold(
          body: RefreshIndicator(
            onRefresh: () => logic.getMissions(showLoading: false),
            child: CustomScrollView(
              physics: const AlwaysScrollableScrollPhysics(
                parent: BouncingScrollPhysics(),
              ),
              slivers: [
                SliverToBoxAdapter(
                  child: Stack(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: CalendarWidget(
                          selectionMode: CalendarSelectionMode.single,
                          // initialDate: DateTime.now(),
                          activeMinMaxMonth: 2,
                          onDateSelected: (date, isChangedMonth) {
                            if (isChangedMonth) {
                              logic.changeMonth(date!);
                            } else {
                              logic.innerFilterMissions(
                                day: date?.day,
                                missionType: logic.selectedMissionType,
                              );
                            }
                          },
                          events: logic.groupMissionsByDate(),
                        ),
                      ),
                    ],
                  ),
                ),
                SliverPersistentHeader(
                  pinned: true,
                  delegate: _ChipsHeaderDelegate(
                    selectedMissionType: logic.selectedMissionType,
                    count: logic.missionCountInDateFilter,
                    onMissionTypeSelected: (missionType) {
                      setState(() {
                        logic.innerFilterMissions(
                          day: logic.selectedDay,
                          missionType: missionType,
                        );
                      });
                    },
                  ),
                ),
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    childCount: logic.filteredMissions.length,
                    (ctx, index) =>
                        _buildMissionItem(logic.filteredMissions[index]),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildMissionItem(Mission mission) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, bottom: 8),
      child: Stack(
        children: [
          Positioned.fill(
            child: Align(
              alignment: Alignment.centerLeft,
              child: Container(
                width: 50,
                decoration: BoxDecoration(
                  color: MissionStatus.fromCode(mission.status!).color,
                  borderRadius: BorderRadius.circular(cardRadius),
                ),
              ),
            ),
          ),
          Card.filled(
            margin: EdgeInsets.only(left: 4),
            child: InkWell(
              borderRadius: BorderRadius.circular(cardRadius),
              onTap: () async {
                bool needRefresh = await Get.toNamed(
                  Routes.MISSION_DETAILS,
                  arguments: mission,
                );

                if (needRefresh) {
                  logic.getMissions();
                }
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
                              Container(
                                width: 32,
                                height: 32,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: MissionStatus.fromCode(
                                    mission.status!,
                                  ).color,
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: SvgPicture.asset(
                                    MissionStatus.fromCode(
                                      mission.status!,
                                    ).icon,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              SizedBox(width: 12),
                              Text(
                                mission.customerName ?? '',
                                style: Theme.of(context).textTheme.labelLarge,
                              ),
                            ],
                          ),
                        ),
                        AppPopupMenu(
                          items: [
                            AppPopupMenuItem(
                              title: 'call'.tr,
                              icon: SvgPicture.asset(
                                'assets/icons/call.svg',
                                color: Colors.white,
                              ),
                              onTap: () {
                                makeCall(mission.customerPhone ?? '');
                              },
                            ),
                            AppPopupMenuItem(
                              title: 'routing'.tr,
                              icon: SvgPicture.asset(
                                'assets/icons/navigation.svg',
                                color: Colors.white,
                              ),
                              onTap: () {
                                openNavigation(
                                  mission.customerLatitude ?? 0,
                                  mission.customerLongitude ?? 0,
                                );
                              },
                            ),
                            AppPopupMenuItem(
                              title: 'add_mission'.tr,
                              icon: SvgPicture.asset(
                                'assets/icons/calendar-add.svg',
                                color: Colors.white,
                              ),
                              onTap: () async {
                                bool result = await Get.toNamed(
                                  Routes.CREATE_MISSION,
                                  arguments: mission.customerId!,
                                );

                                if (result) {
                                  logic.getMissions();
                                }
                              },
                            ),
                          ],
                          child: SvgPicture.asset('assets/icons/more-hor.svg'),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SvgPicture.asset(
                          'assets/icons/location.svg',
                          color: Theme.of(context).disabledColor,
                          width: 16,
                        ),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            mission.customerAddress ?? '',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    Row(
                      children: [
                        SvgPicture.asset(
                          'assets/icons/calendar2.svg',
                          color: Theme.of(context).disabledColor,
                          width: 16,
                        ),
                        SizedBox(width: 2),
                        Text(
                          mission.plannedStartDateTime!.substring(0, 10),
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        SizedBox(width: 16),
                        SvgPicture.asset(
                          'assets/icons/clock.svg',
                          color: Theme.of(context).disabledColor,
                          width: 16,
                        ),
                        SizedBox(width: 2),
                        Text(
                          mission.plannedStartDateTime!.substring(11, 16),
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        SvgPicture.asset(
                          'assets/icons/arrow-long-right.svg',
                          color: Theme.of(context).disabledColor,
                        ),
                        Expanded(
                          child: Text(
                            mission.plannedEndDateTime!.substring(11, 16),
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                        ),
                        InkWell(
                          borderRadius: BorderRadius.circular(8),
                          onTap: () {
                            logic.showChangeDateAndTimeBottomSheet(mission);
                          },
                          child: Container(
                            width: 28,
                            height: 28,
                            padding: EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: Theme.of(context).cardTheme.color,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: SvgPicture.asset(
                              'assets/icons/pen.svg',
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                        ),
                      ],
                    ),
                    /*Divider(height: 12, thickness: 0.5, color: Theme.of(context).dividerColor),
                    Row(
                      children: [
                        SvgPicture.asset(
                          MissionStatus.fromCode(mission.status!).icon,
                          width: 14,
                          color: MissionStatus.fromCode(mission.status!).color,
                        ),
                        SizedBox(width: 4),
                        Text(
                          MissionStatus.fromCode(mission.status!).title,
                          style: Theme.of(
                            context,
                          ).textTheme.titleSmall!.copyWith(color: MissionStatus.fromCode(mission.status!).color),
                        ),
                      ],
                    ),*/
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ChipsHeaderDelegate extends SliverPersistentHeaderDelegate {
  final MissionStatus selectedMissionType;
  final Function(MissionStatus) onMissionTypeSelected;
  final int count;

  _ChipsHeaderDelegate({
    required this.selectedMissionType,
    required this.onMissionTypeSelected,
    required this.count,
  });

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Container(
      color: Theme.of(context).colorScheme.surface,
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: bodyPadding),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        physics: BouncingScrollPhysics(),
        child: Row(
          children: [
            _buildChipsItem(
              context,
              missionType: MissionStatus.all,
              count: count,
            ),
            _buildChipsItem(context, missionType: MissionStatus.draft),
            _buildChipsItem(context, missionType: MissionStatus.inProgress),
            // _buildChipsItem(context, missionType: MissionStatus.completed),
          ],
        ),
      ),
    );
  }

  Widget _buildChipsItem(
    BuildContext context, {
    required MissionStatus missionType,
    int? count,
  }) {
    return Padding(
      padding: EdgeInsetsDirectional.only(end: 10.0),
      child: InkWell(
        borderRadius: BorderRadius.circular(24),
        onTap: () {
          onMissionTypeSelected(missionType);
        },
        child: Container(
          constraints: BoxConstraints(minWidth: 75),
          decoration: BoxDecoration(
            border: Border.all(
              color: selectedMissionType == missionType
                  ? missionType.color
                  : Theme.of(context).colorScheme.outline,
              width: 1,
            ),
            borderRadius: BorderRadius.circular(12),
            color: selectedMissionType == missionType
                ? missionType.color.withAlpha(25)
                : Colors.transparent,
          ),
          child: Padding(
            padding: const EdgeInsets.only(
              top: 8,
              bottom: 8,
              right: 8,
              left: 8,
            ),
            child: Column(
              children: [
                if (missionType == MissionStatus.all)
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.red,
                      shape: BoxShape.circle,
                    ),
                    constraints: BoxConstraints(minWidth: 20, minHeight: 20),
                    child: Center(
                      child: Text(
                        count.toString(),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                if (missionType != MissionStatus.all)
                  SvgPicture.asset(
                    missionType.icon,
                    color: selectedMissionType == missionType
                        ? missionType.color
                        : Theme.of(context).colorScheme.primary.withAlpha(150),
                  ),
                SizedBox(height: 4),
                Text(
                  missionType.title,
                  style: Theme.of(context).textTheme.labelSmall!.copyWith(
                    color: selectedMissionType == missionType
                        ? missionType.color
                        : Theme.of(context).colorScheme.primary.withAlpha(150),
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
  double get maxExtent => /*Get.width < 400 ? 79 : */ 79; // Adjust based on chip height + padding

  @override
  double get minExtent => /*Get.width < 400 ? 79 :*/ 79; // Same as maxExtent to prevent shrinking

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return oldDelegate is _ChipsHeaderDelegate &&
        (oldDelegate.selectedMissionType != selectedMissionType ||
            oldDelegate.count != count);
  }
}
