class DayOff {
  final String id;
  final String leaveType;
  final String status;
  final String startDate;
  final String endDate;
  final int durationDays;

  DayOff({
    required this.id,
    required this.leaveType,
    required this.status,
    required this.startDate,
    required this.endDate,
    required this.durationDays,
  });

  factory DayOff.fromJson(Map<String, dynamic> json) => DayOff(
    id: json['id'] ?? '',
    leaveType: json['leaveType'] ?? '',
    status: json['status'],
    startDate: json['startDate'],
    endDate: json['endDate'],
    durationDays: json['durationDays'],
  );
}
