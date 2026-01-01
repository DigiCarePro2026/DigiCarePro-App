import 'package:digi_care_pro/app/data/models/company.dart';

class PreLoginRequest {
  final String email;

  PreLoginRequest({required this.email});
}

class PreLoginResponse{

  List<Company> companies;

  PreLoginResponse({required this.companies});

  factory PreLoginResponse.fromJson(Map<String, dynamic> json) => PreLoginResponse(
    companies: List<Company>.from(json["companies"].map((x) => Company.fromJson(x))),
  );
}
