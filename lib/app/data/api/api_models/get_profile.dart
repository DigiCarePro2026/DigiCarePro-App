import 'package:digi_care_pro/app/data/models/profile.dart';

class GetProfileResponse {
  final String userId;
  final String accountId;
  final String email;

  GetProfileResponse({required this.userId, required this.accountId, required this.email});

  factory GetProfileResponse.fromJson(Map<String, dynamic> json) =>
      GetProfileResponse(userId: json['userId'] ?? '', accountId: json['accountId'] ?? '', email: json['email'] ?? '');

  Profile toProfile() => Profile(userId: userId, accountId: accountId, email: email);
}
