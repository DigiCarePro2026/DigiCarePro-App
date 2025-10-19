class Profile {
  final String userId;
  final String accountId;
  final String email;
  bool? remindMission;

  Profile({
    required this.userId,
    required this.accountId,
    required this.email,
    this.remindMission,
  });

  Map<String, dynamic> toJson() => {
    'userId': userId,
    'accountId': accountId,
    'email': email,
    'remindMission': remindMission,
  };

  factory Profile.fromJson(Map<String, dynamic> json) => Profile(
    userId: json['userId'] ?? '',
    accountId: json['accountId'] ?? '',
    email: json['email'] ?? '',
    remindMission: json['remindMission'] ?? false,
  );
}
