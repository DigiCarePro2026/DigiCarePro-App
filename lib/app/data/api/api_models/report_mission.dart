class ReportMissionRequest {
  final String missionId;
  final String report;

  ReportMissionRequest({required this.missionId, required this.report});

  Map<String, dynamic> toJson() {
    return {'report': report};
  }
}
