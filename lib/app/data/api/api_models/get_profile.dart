import 'package:digi_care_pro/app/data/models/profile.dart';

class GetProfileResponse {
  final String userId;
  final String accountId;
  final String employeeId;
  final String email;

  GetProfileResponse({
    required this.userId,
    required this.accountId,
    required this.employeeId,
    required this.email,
  });

  factory GetProfileResponse.fromJson(Map<String, dynamic> json) =>
      GetProfileResponse(
        userId: json['userId'] ?? '',
        accountId: json['accountId'] ?? '',
        employeeId: json['employeeId'] ?? '',
        email: json['email'] ?? '',
      );

  Profile toProfile() =>
      Profile(userId: userId, accountId: accountId,employeeId: employeeId, email: email);
}
