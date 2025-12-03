import 'package:digi_care_pro/app/ui/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

enum LeaveStatus {
  pending(0),
  approved(1),
  rejected(2),
  canceled(3);

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
      case LeaveStatus.canceled:
        return 'canceled'.tr;
    }
  }

  Color get color {
    switch (this) {
      case LeaveStatus.pending:
        return Colors.blueGrey;
      case LeaveStatus.approved:
        return AppColors.green;
      case LeaveStatus.rejected:
        return AppColors.red;
      case LeaveStatus.canceled:
        return Colors.orange;
    }
  }
}
