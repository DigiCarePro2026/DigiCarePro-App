class CancelMissionRequest {
  final String missionId;
  final String reason;

  CancelMissionRequest({required this.missionId, required this.reason});

  Map<String, dynamic> toJson() {
    return {'reason': reason};
  }
}
