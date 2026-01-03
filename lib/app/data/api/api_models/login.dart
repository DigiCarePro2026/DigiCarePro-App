class LoginRequest {
  final String email;
  final String password;
  final String companyId;

  LoginRequest({required this.email, required this.password, required this.companyId});

  Map<String, dynamic> toJson() {
    return {'email': email, 'password': password, 'companyId': companyId};
  }
}

class LoginResponse {
  final String accessToken;
  final String refreshToken;

  LoginResponse({required this.accessToken, required this.refreshToken});

  factory LoginResponse.fromJson(Map<String, dynamic> json) =>
      LoginResponse(accessToken: json['access_token'], refreshToken: json['refresh_token']);
}
