import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:url_launcher/url_launcher.dart';

Future<bool> isNetworkAvailable() => InternetConnectionChecker.instance.hasConnection;

makeCall(String phoneNumber) async {
  final Uri launchUri = Uri(scheme: 'tel', path: phoneNumber);
  await launchUrl(launchUri);
}

openNavigation(double lat, double lng) async {
  final Uri googleMapsUri = Uri.parse('https://www.google.com/maps/dir/?api=1&destination=$lat,$lng');
  await launchUrl(googleMapsUri, mode: LaunchMode.externalApplication);
}

String formatDateShort(String dateString) {
  final date = DateTime.parse(dateString);

  const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];

  final month = months[date.month - 1];
  final day = date.day.toString();

  return '$month $day';
}

Future<String?> getDeviceUniqueId() async {
  final deviceInfo = DeviceInfoPlugin();

  if (kIsWeb) {
    final webInfo = await deviceInfo.webBrowserInfo;

    return webInfo.userAgent;
  }

  if (Platform.isAndroid) {
    final androidInfo = await deviceInfo.androidInfo;
    return androidInfo.id;
  }

  if (Platform.isIOS) {
    final iosInfo = await deviceInfo.iosInfo;
    return iosInfo.identifierForVendor;
  }

  return null;
}


TimeOfDay? parseTime(String? isoString) {
  if (isoString == null) return null;
  try {
    final dt = DateTime.parse(isoString);
    return TimeOfDay(hour: dt.hour, minute: dt.minute);
  } catch (e) {
    return null;
  }
}
