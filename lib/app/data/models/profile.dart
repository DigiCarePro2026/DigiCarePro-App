class Profile {
  final String userId;
  final String accountId;
  final String employeeId;
  final String email;
  final String fullName;
  bool receiveNotifications;

  Profile({
    required this.userId,
    required this.accountId,
    required this.employeeId,
    required this.email,
    required this.fullName,
    required this.receiveNotifications,
  });

  Map<String, dynamic> toJson() => {
    'userId': userId,
    'accountId': accountId,
    'employeeId': employeeId,
    'email': email,
    'fullName': fullName,
    'receiveNotifications': receiveNotifications,
  };

  factory Profile.fromJson(Map<String, dynamic> json) => Profile(
    userId: json['userId'] ?? '',
    accountId: json['accountId'] ?? '',
    employeeId: json['employeeId'] ?? '',
    email: json['email'] ?? '',
    fullName: json['fullName'] ?? '',
    receiveNotifications: json['receiveNotifications'] ?? false,
  );
}
