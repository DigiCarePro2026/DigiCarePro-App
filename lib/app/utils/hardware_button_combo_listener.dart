import 'dart:async';

import 'package:collection/collection.dart';
import 'package:digi_care_pro/app/routes/app_routes.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:hardware_button_listener/hardware_button_listener.dart';
import 'package:hardware_button_listener/models/hardware_button.dart';

class HardwareButtonComboListener {
  final _hardwareButtonListener = HardwareButtonListener();
  late StreamSubscription<HardwareButton> _buttonSubscription;

  final List<String> _pressedKeys = [];
  final int _maxHistory = 4;

  void startListening() {
    _buttonSubscription = _hardwareButtonListener.listen((event) {
      final key = event.buttonName.toString();
      _addKeyToHistory(key);
      _checkCombo();
    });
  }

  void _addKeyToHistory(String key) {
    _pressedKeys.add(key.toLowerCase());
    if (_pressedKeys.length > _maxHistory) {
      _pressedKeys.removeAt(0);
    }
  }

  void _checkCombo() {
    const targetCombo = ['volume_down','volume_down', 'volume_up', 'volume_up'];

    if (_pressedKeys.length == targetCombo.length && const ListEquality().equals(_pressedKeys, targetCombo)) {

      Get.toNamed(Routes.SET_SERVER_URL);
      _pressedKeys.clear();
    }
  }

  void dispose() {
    _buttonSubscription.cancel();
  }
}
