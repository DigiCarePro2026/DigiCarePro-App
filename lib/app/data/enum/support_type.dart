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
        return 'Mission'.tr;
      case SupportType.customer:
        return 'Customer'.tr;
      case SupportType.payment:
        return 'Payment'.tr;
      case SupportType.application:
        return 'Application'.tr;
    }
  }
}