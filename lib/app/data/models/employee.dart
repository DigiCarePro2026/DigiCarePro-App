class Employee {
  final String firstName;
  final String lastName;
  final String? birthDate;

  Employee({
    required this.firstName,
    required this.lastName,
    this.birthDate,
  });

  factory Employee.fromJson(Map<String, dynamic> json) => Employee(
    firstName: json['firstName'] ?? '',
    lastName: json['lastName'] ?? '',
    birthDate: json['birthDate'],
  );

  String getFullName() => '$firstName $lastName';

  @override
  String toString() => getFullName();
}
