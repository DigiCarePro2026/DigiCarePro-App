class SupportEmployee {
  final String id;
  final String fullName;
  final String? city;
  final String? postCode;
  final String? mobile;

  SupportEmployee({
    required this.id,
    required this.fullName,
    this.city,
    this.postCode,
    this.mobile,
  });

  factory SupportEmployee.fromJson(Map<String, dynamic> json) => SupportEmployee(
    id: json['id'] ?? '',
    fullName: json['fullName'] ?? '',
    city: json['city'],
    postCode: json['postCode'],
    mobile: json['mobile'],
  );
}
