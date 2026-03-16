import 'dart:async';
import 'package:digi_care_pro/app/ui/widgets/confirm_dialog.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';

import 'dialog_handler.dart';

class LocationService {
  LocationService._privateConstructor();

  static final LocationService instance = LocationService._privateConstructor();
  static const Duration _defaultCacheTtl = Duration(minutes: 2);
  Position? _cachedLocation;
  DateTime? _cachedLocationExpiresAt;
  bool _isWarmingUp = false;

  /// --- INTERNAL HELPERS ---

  Future<bool> _checkAndRequestPermission({BuildContext? context}) async {
    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.denied) {
      // کاربر مجوز را رد کرده
      if (context != null) {
        _showPermissionDeniedDialog(context);
      }
      return false;
    }

    if (permission == LocationPermission.deniedForever) {
      // کاربر همیشه رد کرده -> باید او را به تنظیمات هدایت کنیم
      if (context != null) {
        final open = await _showOpenSettingsDialog(
          context,
          title: 'permission_denied_forever'.tr,
          message: 'permission_denied_forever_desc'.tr,
        );

        if (open == true) await Geolocator.openAppSettings();
      }
      return false;
    }

    // permission == whileInUse || always
    return true;
  }

  Future<bool> _ensureLocationServiceEnabled({BuildContext? context}) async {
    bool enabled = await Geolocator.isLocationServiceEnabled();
    if (!enabled && context != null) {
      final open = await _showOpenSettingsDialog(context, title: 'location_service_off'.tr, message: 'turn_on_gps'.tr);
      if (open == true) await Geolocator.openLocationSettings();
      enabled = await Geolocator.isLocationServiceEnabled();
    }
    return enabled;
  }

  Future<void> _showPermissionDeniedDialog(BuildContext context) {
    return DialogHandler.showConfirm(
      title: 'location_perm_denied'.tr,
      message: 'location_perm_denied_desc'.tr,
      buttons: [
        DialogButtonModel(
          label: 'ok'.tr,
          onTap: () {
            Navigator.pop(context);
          },
        ),
      ],
    );
  }

  Future<bool?> _showOpenSettingsDialog(BuildContext context, {required String title, required String message}) {
    final completer = Completer<bool?>();

    DialogHandler.showConfirm(
      title: title,
      message: message,
      buttons: [
        DialogButtonModel(
          label: 'open_settings'.tr,
          onTap: () async {
            await Geolocator.openAppSettings();
            if (!completer.isCompleted) completer.complete(true);
            Navigator.pop(context);
          },
        ),
      ],
    );

    return completer.future;
  }

  /// --- PUBLIC API ---

  /// اطمینان از اینکه هم سرویس روشن است و هم مجوزها داده شده‌اند.
  /// اگر context داده شود، در صورت نیاز دیالوگ نشان می‌دهد / کاربر را به تنظیمات هدایت می‌کند.
  Future<bool> ensurePermissionAndService({BuildContext? context}) async {
    final okPerm = await _checkAndRequestPermission(context: context);
    if (!okPerm) return false;

    final okService = await _ensureLocationServiceEnabled(context: context);
    if (!okService) return false;

    return true;
  }

  Future<Position?> getCurrentLocation({
    BuildContext? context,
    LocationAccuracy accuracy = LocationAccuracy.best,
    Duration? timeLimit,
    bool forceRefresh = false,
    bool allowCached = true,
    Duration cacheTtl = _defaultCacheTtl,
  }) async {
    final cached = getCachedLocation();
    if (!forceRefresh && allowCached && cached != null) {
      return cached;
    }

    final ready = await ensurePermissionAndService(context: context);
    if (!ready) return null;

    try {
      Position? position;
      if (timeLimit != null) {
        position = await Geolocator
            .getCurrentPosition(desiredAccuracy: accuracy)
            .timeout(timeLimit);
      } else {
        position = await Geolocator.getCurrentPosition(
          desiredAccuracy: accuracy,
        );
      }

      _cacheLocation(position, ttl: cacheTtl);
      return position;
    } on TimeoutException {
      return allowCached ? cached : null;
    } catch (e) {
      // handle other errors if needed
      return allowCached ? cached : null;
    }
  }

  Position? getCachedLocation() {
    if (_cachedLocation == null || _cachedLocationExpiresAt == null) {
      return null;
    }
    if (DateTime.now().isAfter(_cachedLocationExpiresAt!)) {
      return null;
    }
    return _cachedLocation;
  }

  void _cacheLocation(Position position, {Duration ttl = _defaultCacheTtl}) {
    _cachedLocation = position;
    _cachedLocationExpiresAt = DateTime.now().add(ttl);
  }

  Future<void> warmUpLocationCache({
    Duration ttl = const Duration(minutes: 5),
  }) async {
    if (_isWarmingUp) return;

    final hasValidCache = getCachedLocation() != null;
    if (hasValidCache) return;

    _isWarmingUp = true;
    try {
      final position = await getCurrentLocation(
        context: null,
        accuracy: LocationAccuracy.medium,
        timeLimit: const Duration(seconds: 5),
        allowCached: false,
        cacheTtl: ttl,
      );
      if (position != null) {
        _cacheLocation(position, ttl: ttl);
      }
    } finally {
      _isWarmingUp = false;
    }
  }
}
