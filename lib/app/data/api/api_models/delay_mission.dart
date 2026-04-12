class DelayMissionRequest {
  final String missionId;
  final int delayMinutes;

  DelayMissionRequest({required this.missionId, required this.delayMinutes});

  Map<String, dynamic> toJson() {
    return {'delayMinutes': delayMinutes};
  }
}
