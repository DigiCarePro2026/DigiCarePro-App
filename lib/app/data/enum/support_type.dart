import 'package:get/get.dart';

enum SupportType{
  mission,
  customer,
  payment,
  application,
}

extension SupportTypeExtension on SupportType {
  String get title {
    switch (this) {
      case SupportType.mission:
        return 'support_mission'.tr;
      case SupportType.customer:
        return 'support_customer'.tr;
      case SupportType.payment:
        return 'support_payment'.tr;
      case SupportType.application:
        return 'support_application'.tr;
    }
  }
}