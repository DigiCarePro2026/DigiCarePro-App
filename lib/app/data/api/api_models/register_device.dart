class RegisterDeviceRequest {
  final String? deviceId;
  final String deviceType;
  final String? token;

  RegisterDeviceRequest({this.deviceId, required this.deviceType, this.token});

  Map<String, dynamic> toJson() => {'deviceId': deviceId, 'deviceType': deviceType, 'token': token};
}
