import 'package:digi_care_pro/app/data/enum/mission_type.dart';
import 'package:digi_care_pro/app/ui/theme/app_colors.dart';
import 'package:digi_care_pro/app/ui/theme/app_dimens.dart';
import 'package:digi_care_pro/app/ui/widgets/animated_search_bar.dart';
import 'package:digi_care_pro/app/ui/widgets/calendar_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MissionsScreen extends StatefulWidget {
  const MissionsScreen({super.key});

  @override
  State<MissionsScreen> createState() => _MissionsScreenState();
}

class _MissionsScreenState extends State<MissionsScreen> {
  MissionType _selectedMissionType = MissionType.all;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Stack(
              children: [
                PositionedDirectional(top: 8, end: 10, child: AnimatedSearchField()),
                CalendarWidget(
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
          SliverList(delegate: SliverChildBuilderDelegate(childCount: 20, (ctx, index) => _buildMissionItem(index))),
        ],
      ),
    );
  }

  Widget _buildMissionItem(int index) {
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
                  Expanded(child: Text('Mostafa Babaie', style: Theme.of(context).textTheme.labelLarge)),
                  InkWell(
                    borderRadius: BorderRadius.circular(24),
                    onTap: () {},
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SvgPicture.asset('assets/icons/more-hor.svg'),
                    ),
                  ),
                ],
              ),
              Text('Max Mustermann Musterstraße 12', style: Theme.of(context).textTheme.titleMedium),
              Row(
                children: [
                  Text('2025/07/10', style: Theme.of(context).textTheme.titleMedium),
                  SizedBox(width: 12),
                  Text('14:00', style: Theme.of(context).textTheme.titleMedium),
                  SizedBox(width: 4),
                  SvgPicture.asset('assets/icons/arrow-long-right.svg', color: Theme.of(context).disabledColor),
                  SizedBox(width: 4),
                  Text('15:30', style: Theme.of(context).textTheme.titleMedium),
                ],
              ),
              Divider(height: 12, thickness: 0.5, color: Theme.of(context).dividerColor),

              Row(
                children: [
                  if (index % 3 == 1) Expanded(child: Text('Todo', style: Theme.of(context).textTheme.titleSmall!.copyWith(color: AppColors.missionNew))),
                  if (index % 3 == 2) Expanded(child: Text('In progress', style: Theme.of(context).textTheme.titleSmall!.copyWith(color: AppColors.missionInProgress))),
                  if (index % 3 == 0) Expanded(child: Text('Done', style: Theme.of(context).textTheme.titleSmall!.copyWith(color: AppColors.missionDone))),
                  SvgPicture.asset('assets/icons/arrow-right.svg', color: Theme.of(context).disabledColor),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

class _ChipsHeaderDelegate extends SliverPersistentHeaderDelegate {
  final MissionType selectedMissionType;
  final Function(MissionType) onMissionTypeSelected;

  _ChipsHeaderDelegate({required this.selectedMissionType, required this.onMissionTypeSelected});

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: Theme.of(context).colorScheme.surface,
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

  Widget _buildChipsItem(BuildContext context, {required MissionType missionType}) {
    return Padding(
      padding: EdgeInsetsDirectional.only(end: 10.0),
      child: InkWell(
        borderRadius: BorderRadius.circular(24),
        onTap: () {
          onMissionTypeSelected(missionType);
        },
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: Theme.of(context).colorScheme.primary.withAlpha(150), width: 0.5),
            borderRadius: BorderRadius.circular(24),
            color: selectedMissionType == missionType
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.surface,
          ),
          child: Padding(
            padding: const EdgeInsets.only(top: 8, bottom: 8, right: 12, left: 12),
            child: Text(
              missionType.title,
              style: Theme.of(context).textTheme.labelSmall!.copyWith(
                color: selectedMissionType == missionType
                    ? Theme.of(context).colorScheme.onPrimary
                    : Theme.of(context).colorScheme.primary.withAlpha(150),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  double get maxExtent => 64.0; // Adjust based on chip height + padding

  @override
  double get minExtent => 64.0; // Same as maxExtent to prevent shrinking

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return oldDelegate is _ChipsHeaderDelegate && (oldDelegate.selectedMissionType != selectedMissionType);
  }
}
