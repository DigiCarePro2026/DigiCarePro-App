class Customer {
  final String id;
  final String firstName;
  final String lastName;
  final String? birthDate;
  final String? nationalId;
  final int gender;
  final String? phone;
  final String? mobile;
  final String? email;
  final String city;
  final String? address;
  final String? postCode;
  final String? insuranceCompanyId;
  final String? insuranceNumber;
  final String? insuranceCompanyNumber;
  final double? latitude;
  final double? longitude;
  final int careGrade;
  final String? careSince;
  final String? genderPreference;
  final String? notes;
  final String? profileImageUrl;
  final bool active;

  Customer({
    required this.id,
    required this.firstName,
    required this.lastName,
    this.birthDate,
    this.nationalId,
    required this.gender,
    this.phone,
    this.mobile,
    this.email,
    required this.city,
    this.address,
    this.postCode,
    this.insuranceCompanyId,
    this.insuranceNumber,
    this.insuranceCompanyNumber,
    this.latitude,
    this.longitude,
    required this.careGrade,
    this.careSince,
    this.genderPreference,
    this.notes,
    this.profileImageUrl,
    required this.active,
  });

  factory Customer.fromJson(Map<String, dynamic> json) => Customer(
    id: json['id']?.toString() ?? '',
    firstName: json['firstName'] ?? '',
    lastName: json['lastName'] ?? '',
    birthDate: json['birthDate'],
    nationalId: json['nationalId'],
    gender: json['gender'] is int
        ? json['gender']
        : int.tryParse(json['gender']?.toString() ?? '0') ?? 0,
    phone: json['phone'],
    mobile: json['mobile'],
    email: json['email'],
    city: json['city'] ?? '',
    address: json['address'],
    postCode: json['postCode'],
    insuranceCompanyId: json['insuranceCompanyId'],
    insuranceNumber: json['insuranceNumber'],
    insuranceCompanyNumber: json['insuranceCompanyNumber'],
    latitude: (json['latitude'] != null)
        ? double.tryParse(json['latitude'].toString())
        : null,
    longitude: (json['longitude'] != null)
        ? double.tryParse(json['longitude'].toString())
        : null,
    careGrade: json['careGrade'] is int
        ? json['careGrade']
        : int.tryParse(json['careGrade']?.toString() ?? '0') ?? 0,
    careSince: json['careSince'],
    genderPreference: json['genderPreference'],
    notes: json['notes'],
    profileImageUrl: json['profileImageUrl'],
    active: json['active'] == true ||
        json['active'] == 1 ||
        json['active'] == 'true',
  );

  String getFullName() => '$firstName $lastName';

  @override
  String toString() => getFullName();
}
