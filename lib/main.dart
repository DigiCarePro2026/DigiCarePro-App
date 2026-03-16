import 'package:digi_care_pro/app/data/constants/pref_key.dart';
import 'package:digi_care_pro/app/ui/theme/app_theme.dart';
import 'package:digi_care_pro/config/translations/app_translations.dart';
import 'package:digi_care_pro/app/logic/main_logic.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'app/data/pref.dart';
import 'app/routes/app_pages.dart';
import 'app/routes/app_routes.dart';
import 'app/service/notification_service.dart';
import 'app/utils/hardware_button_combo_listener.dart';
import 'app/utils/mission_event_bus.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Pref.init();
  HardwareButtonComboListener().startListening();
  _initFirebaseServices();

  await NotificationService.init();

  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    _handleIncomingMessageCount(message);
    NotificationService.show(message);
  });

  Get.put(MissionEventBus());

  runApp(const MyApp());
}

void _handleIncomingMessageCount(RemoteMessage message) {
  final data = message.data;
  final type = (data['type'] ?? data['eventType'] ?? '').toString().toLowerCase();
  final route = (data['route'] ?? '').toString().toLowerCase();

  final isMessagePush =
      type.contains('message') ||
      route.contains('message') ||
      data.containsKey('messageId');

  if (isMessagePush) {
    if (Get.isRegistered<MainLogic>()) {
      Get.find<MainLogic>().incrementUnreadMessageCount();
    }
    return;
  }

  if (!Get.isRegistered<MainLogic>() || !Get.isRegistered<MissionEventBus>()) {
    return;
  }

  final isMissionTabActive = Get.find<MainLogic>().selectedPage == 1;
  if (isMissionTabActive) {
    Get.find<MissionEventBus>().sendUpdate(true);
  }
}

_initFirebaseServices() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  FirebaseMessaging messaging = FirebaseMessaging.instance;

  await messaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'DigiCarePro',
      debugShowCheckedModeBanner: false,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      translations: AppTranslations(),
      supportedLocales: [Locale('en', 'US'), Locale('fr', 'FR'), Locale('de', 'DE')],
      locale: Locale(Pref.getString(PrefKey.locale) ?? 'de'),
      themeMode: ThemeMode.light,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      builder: (context, child) {
        final bg = Theme.of(context).scaffoldBackgroundColor;
        final onLightBg = ThemeData.estimateBrightnessForColor(bg) == Brightness.light;

        SystemChrome.setSystemUIOverlayStyle(
          SystemUiOverlayStyle(
            systemNavigationBarColor: bg,
            systemNavigationBarIconBrightness: onLightBg ? Brightness.dark : Brightness.light,
            systemNavigationBarDividerColor: bg,
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: onLightBg ? Brightness.dark : Brightness.light,
          ),
        );

        return child!;
      },
      initialRoute: Pref.getString(PrefKey.accessToken) == null ? Routes.LOGIN : Routes.HOME,
      getPages: AppPages.pages,
    );
  }
}
