class StartMissionRequest {
  final String missionId;
  final double latitude;
  final double longitude;

  StartMissionRequest({
    required this.missionId,
    required this.latitude,
    required this.longitude,
  });

  Map<String, dynamic> toJson() => {
    'latitude': latitude,
    'longitude': longitude,
  };
}
