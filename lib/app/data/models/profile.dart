class Profile {
  final String userId;
  final String accountId;
  final String employeeId;
  final String email;
  bool? remindMission;

  Profile({
    required this.userId,
    required this.accountId,
    required this.employeeId,
    required this.email,
    this.remindMission,
  });

  Map<String, dynamic> toJson() => {
    'userId': userId,
    'accountId': accountId,
    'employeeId': employeeId,
    'email': email,
    'remindMission': remindMission,
  };

  factory Profile.fromJson(Map<String, dynamic> json) => Profile(
    userId: json['userId'] ?? '',
    accountId: json['accountId'] ?? '',
    employeeId: json['employeeId'] ?? '',
    email: json['email'] ?? '',
    remindMission: json['remindMission'] ?? false,
  );
}
