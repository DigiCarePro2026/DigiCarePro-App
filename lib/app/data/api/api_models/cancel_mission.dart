class CancelMissionRequest {
  final String missionId;
  final String reason;
  final String comment;

  CancelMissionRequest({required this.missionId, required this.reason, required this.comment});

  Map<String, dynamic> toJson() {
    return {'reason': reason, 'comment': comment};
  }
}
