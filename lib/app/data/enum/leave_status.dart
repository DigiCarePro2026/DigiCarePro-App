import 'package:get/get.dart';

enum LeaveStatus {
  pending(0),
  approved(1),
  rejected(2);

  final int code;

  const LeaveStatus(this.code);
}

extension LeaveStatusExtension on LeaveStatus {
  String get title {
    switch (this) {
      case LeaveStatus.pending:
        return 'pending'.tr;
      case LeaveStatus.approved:
        return 'approved'.tr;
      case LeaveStatus.rejected:
        return 'rejected'.tr;
    }
  }
}
