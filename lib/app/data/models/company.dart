class Company {
  final String companyId;
  final String companyName;
  final bool isDefault;

  Company({required this.companyId, required this.companyName, required this.isDefault});

  factory Company.fromJson(Map<String, dynamic> json) {
    return Company(companyId: json['companyId'], companyName: json['companyName'], isDefault: json['isDefault']);
  }
}
