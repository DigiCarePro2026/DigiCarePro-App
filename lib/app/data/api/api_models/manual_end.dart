class ManualEndRequest {
  final String missionId;
  final String reason;

  ManualEndRequest({
    required this.missionId,
    required this.reason,
  });

  Map<String, dynamic> toJson() => {
    'reason': reason,
  };
}
