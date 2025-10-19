import 'package:get/get.dart';

enum CancelMissionType{
  sickness,
  unplannedLeave,
  customerCancellation,
  other;
}

extension CancelMissionTypeExtension on CancelMissionType {
  String get title {
    switch (this) {
      case CancelMissionType.sickness:
        return 'sickness'.tr;
      case CancelMissionType.unplannedLeave:
        return 'unplanned_leave'.tr;
      case CancelMissionType.customerCancellation:
        return 'customer_cancellation'.tr;
      case CancelMissionType.other:
        return 'other'.tr;
    }
  }
}