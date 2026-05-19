import 'dart:async';
import 'dart:io';

import 'package:digi_care_pro/app/data/api/api_models/register_device.dart';
import 'package:digi_care_pro/app/data/constants/pref_key.dart';
import 'package:digi_care_pro/app/data/pref.dart';
import 'package:digi_care_pro/app/data/repositories/account_repository.dart';
import 'package:digi_care_pro/app/utils/utils.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';

class DeviceRegistrationService {
  static StreamSubscription<String>? _tokenRefreshSubscription;
  static String? _lastRegisteredToken;
  static bool _isRegistering = false;

  static void start() {
    _tokenRefreshSubscription ??=
        FirebaseMessaging.instance.onTokenRefresh.listen((token) {
      debugPrint('firebase token refreshed : $token');
      registerCurrentDevice(firebaseToken: token);
    });
  }

  static Future<void> registerCurrentDevice({String? firebaseToken}) async {
    if (kIsWeb || (!Platform.isAndroid && !Platform.isIOS)) {
      return;
    }

    if (Pref.getString(PrefKey.accessToken) == null) {
      debugPrint('register device skipped : user is not logged in');
      return;
    }

    if (_isRegistering) {
      return;
    }

    _isRegistering = true;

    try {
      final token = firebaseToken ?? await _getFirebaseMessagingToken();

      debugPrint('firebase token : $token');

      if (token == null || token.isEmpty) {
        debugPrint('register device skipped : firebase token is empty');
        return;
      }

      if (token == _lastRegisteredToken) {
        debugPrint('register device skipped : token already registered');
        return;
      }

      final deviceId = await getDeviceUniqueId();

      final result = await AccountRepository.get().registerDevice(
        RegisterDeviceRequest(
          deviceId: deviceId,
          deviceType: Platform.isAndroid ? 'Android' : 'iOS',
          token: token,
        ),
      );

      result.fold(
        (error) => debugPrint('register device failed : ${error.message}'),
        (response) {
          _lastRegisteredToken = token;
          debugPrint('register device succeeded');
        },
      );
    } catch (error) {
      debugPrint('register device error : $error');
    } finally {
      _isRegistering = false;
    }
  }

  static Future<String?> _getFirebaseMessagingToken() async {
    if (Platform.isIOS) {
      String? apnsToken;

      for (var attempt = 0; attempt < 20; attempt++) {
        apnsToken = await FirebaseMessaging.instance.getAPNSToken();
        debugPrint('apns token attempt ${attempt + 1} : $apnsToken');

        if (apnsToken != null && apnsToken.isNotEmpty) {
          break;
        }

        await Future.delayed(const Duration(milliseconds: 500));
      }

      if (apnsToken == null || apnsToken.isEmpty) {
        return null;
      }
    }

    return FirebaseMessaging.instance.getToken();
  }
}
