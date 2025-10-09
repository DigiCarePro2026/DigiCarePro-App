class Profile {
  final String userId;
  final String accountId;
  final String email;

  Profile({required this.userId, required this.accountId, required this.email});

  Map<String, dynamic> toJson() => {'userId': userId, 'accountId': accountId, 'email': email};

  factory Profile.fromJson(Map<String, dynamic> json) =>
      Profile(userId: json['userId'] ?? '', accountId: json['accountId'] ?? '', email: json['email'] ?? '');
}
