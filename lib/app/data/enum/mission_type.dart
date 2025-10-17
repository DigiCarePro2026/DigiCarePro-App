import 'package:get/get.dart';

enum MissionType{
  all,
  todo,
  inProgress,
  done;
}

extension MissionTypeExtension on MissionType {
  String get title {
    switch (this) {
      case MissionType.all:
        return 'all'.tr;
      case MissionType.todo:
        return 'todo'.tr;
      case MissionType.inProgress:
        return 'in_progress'.tr;
      case MissionType.done:
        return 'done'.tr;
    }
  }
}