import 'package:digi_care_pro/app/data/enum/leave_status.dart';

class DayOff {
  final String id;
  final int leaveType;
  final LeaveStatus status;
  final String startDate;
  final String endDate;
  final int durationDays;
  final String? description;

  DayOff({
    required this.id,
    required this.leaveType,
    required this.status,
    required this.startDate,
    required this.endDate,
    required this.durationDays,
    this.description,
  });

  factory DayOff.fromJson(Map<String, dynamic> json) => DayOff(
    id: json['id'] ?? '',
    leaveType: int.parse(json['leaveType'] ?? '1'),
    status: LeaveStatus.values[int.parse(json['status'].toString())],
    startDate: json['startDate'],
    endDate: json['endDate'],
    durationDays: json['durationDays'],
    description: json['description'] ?? '',
  );
}
