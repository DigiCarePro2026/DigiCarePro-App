class ChangeSettingsRequest {
  final bool receiveNotifications;

  ChangeSettingsRequest({
    required this.receiveNotifications,
  });

  Map<String, dynamic> toJson() => {
    'receiveNotifications': receiveNotifications,
  };
}
