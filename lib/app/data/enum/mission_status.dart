import 'dart:ui';

import 'package:digi_care_pro/app/ui/theme/app_colors.dart';
import 'package:get/get.dart';

enum MissionStatus {
  all(0),
  draft(1),
  inProgress(2),
  completed(3);

  final int code;

  const MissionStatus(this.code);

  factory MissionStatus.fromCode(int code) {
    return MissionStatus.values.firstWhere(
          (e) => e.code == code,
      orElse: () => MissionStatus.draft,
    );
  }
}

extension MissionStatusExtension on MissionStatus {
  String get icon {
    switch (this) {
      case MissionStatus.all:
        return '';

      case MissionStatus.draft:
        return 'assets/icons/todo-status.svg';

      case MissionStatus.inProgress:
        return 'assets/icons/progress.svg';

      case MissionStatus.completed:
        return 'assets/icons/check-linear.svg';
    }
  }

  String get title {
    switch (this) {
      case MissionStatus.all:
        return 'all'.tr;

      case MissionStatus.draft:
        return 'mission_status_todo'.tr;

      case MissionStatus.inProgress:
        return 'mission_status_in_progress'.tr;

      case MissionStatus.completed:
        return 'mission_status_done'.tr;
    }
  }

  Color get color {
    switch (this) {
      case MissionStatus.all:
        return AppColors.allMissions;

      case MissionStatus.draft:
        return AppColors.missionNew;

      case MissionStatus.inProgress:
        return AppColors.missionInProgress;

      case MissionStatus.completed:
        return AppColors.missionDone;
    }
  }
}
