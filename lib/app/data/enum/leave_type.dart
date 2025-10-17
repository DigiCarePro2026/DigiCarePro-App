import 'package:get/get.dart';

enum LeaveType{
  personal,
  vocation,
  sick,
}

extension LeaveTypeExtension on LeaveType {
  String get title {
    switch (this) {
      case LeaveType.personal:
        return 'personal'.tr;
      case LeaveType.vocation:
        return 'vocation'.tr;
      case LeaveType.sick:
        return 'sick'.tr;
    }
  }
}