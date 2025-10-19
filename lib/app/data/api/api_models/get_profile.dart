import 'package:digi_care_pro/app/data/models/profile.dart';

class GetProfileResponse {
  final String userId;
  final String accountId;
  final String employeeId;
  final String email;
  final String fullName;
  final bool receiveNotifications;

  GetProfileResponse({
    required this.userId,
    required this.accountId,
    required this.employeeId,
    required this.email,
    required this.fullName,
    required this.receiveNotifications,
  });

  factory GetProfileResponse.fromJson(Map<String, dynamic> json) =>
      GetProfileResponse(
        userId: json['userId'] ?? '',
        accountId: json['accountId'] ?? '',
        employeeId: json['employeeId'] ?? '',
        email: json['email'] ?? '',
        fullName: json['fullName'] ?? '',
        receiveNotifications: json['receiveNotifications'] ?? false,
      );

  Profile toProfile() => Profile(
    userId: userId,
    accountId: accountId,
    employeeId: employeeId,
    email: email,
    fullName: fullName,
    receiveNotifications: receiveNotifications,
  );
}
