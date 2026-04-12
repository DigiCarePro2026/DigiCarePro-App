import 'package:digi_care_pro/config/translations/de_DE.dart';
import 'package:digi_care_pro/config/translations/fr_FR.dart';
import 'package:get/get_navigation/src/root/internacionalization.dart';

import 'en_US.dart';

class AppTranslations extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
    'en': enUS,
    'fr': frFR,
    'de': deDE,
    'en_US': enUS,
    'fr_FR': frFR,
    'de_DE': deDE,
  };
}
