class StartMissionRequest {
  final String missionId;
  final double latitude;
  final double longitude;
  final double? expectedLat;
  final double? expectedLng;

  StartMissionRequest({
    required this.missionId,
    required this.latitude,
    required this.longitude,
    this.expectedLat,
    this.expectedLng,
  });

  Map<String, dynamic> toJson() => {
    'latitude': latitude,
    'longitude': longitude,
    'expectedLat': expectedLat,
    'expectedLng': expectedLng,
  };
}
