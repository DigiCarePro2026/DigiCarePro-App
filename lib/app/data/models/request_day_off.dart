class RequestDayOffRequest {
  final String employeeId;
  final int leaveTypeId;
  final String startDate;
  final String endDate;
  final String? description;

  RequestDayOffRequest({
    required this.employeeId,
    required this.leaveTypeId,
    required this.startDate,
    required this.endDate,
    this.description,
  });

  Map<String, dynamic> toJson() => {
    'employeeId': employeeId,
    'leaveTypeId': leaveTypeId,
    'startDate': startDate,
    'endDate': endDate,
    'description': description,
  };
}
