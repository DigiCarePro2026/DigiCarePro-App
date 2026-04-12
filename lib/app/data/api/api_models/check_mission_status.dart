class CheckMissionStatusRequest {
  final String missionId;
  final double latitude;
  final double longitude;

  CheckMissionStatusRequest({
    required this.missionId,
    required this.latitude,
    required this.longitude,
  });

  Map<String, dynamic> toJson() => {
    'latitude': latitude,
    'longitude': longitude,
  };
}
