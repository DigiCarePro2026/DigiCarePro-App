import 'package:get/get.dart';

enum LeaveType {
  vocation(1),
  personal(2),
  sick(3);

  final int code;

  const LeaveType(this.code);
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
