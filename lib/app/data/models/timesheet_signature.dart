class TimesheetSignature {
  String? employeeSignaturePath;
  String? employeeSignDate;
  String? managerSignaturePath;
  String? managerSignDate;

  TimesheetSignature({
    this.employeeSignaturePath,
    this.employeeSignDate,
    this.managerSignaturePath,
    this.managerSignDate,
  });

  factory TimesheetSignature.fromJson(Map<String, dynamic> json) => TimesheetSignature(
    employeeSignaturePath: json['employeeSignaturePath'],
    employeeSignDate: json['employeeSignDate'],
    managerSignaturePath: json['managerSignaturePath'],
    managerSignDate: json['managerSignDate'],
  );
}
