import 'package:get/get.dart';

enum MissionActionType{
  autoStart(1),
  manualStart(2),
  sign(3),
  done(4);

  final int code;

  const MissionActionType(this.code);
}

extension MissionActionTypeExtension on MissionActionType {
  String get title {
    switch (this) {
      case MissionActionType.autoStart:
        return 'auto_start'.tr;
      case MissionActionType.manualStart:
        return 'manual_start'.tr;
      case MissionActionType.sign:
        return 'sign'.tr;
      case MissionActionType.done:
        return 'done'.tr;
    }
  }
}