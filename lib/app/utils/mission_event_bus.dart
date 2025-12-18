import 'dart:async';

import 'package:get/get_state_manager/src/rx_flutter/rx_disposable.dart';

class MissionEventBus extends GetxService {
  final delayUpdated = StreamController<bool>.broadcast();

  void sendUpdate(bool reloadMissions) {
    delayUpdated.add(reloadMissions);
  }

  @override
  void onClose() {
    delayUpdated.close();
    super.onClose();
  }
}
