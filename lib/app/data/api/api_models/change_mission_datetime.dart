class ChangeMissionDatetimeRequest {
  final String missionId;
  final String plannedStart;
  final String plannedEnd;
  final String reason;

  ChangeMissionDatetimeRequest({
    required this.missionId,
    required this.plannedStart,
    required this.plannedEnd,
    required this.reason,
  });

  Map<String, dynamic> toJson() {
    return {'plannedStart': plannedStart, 'plannedEnd': plannedEnd, 'reason': reason};
  }
}
