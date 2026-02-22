import 'customer.dart';

class Mission {
  final String id;
  final String companyId;
  final String employeeId;
  String? plannedStartDateTime;
  String? plannedEndDateTime;
  final String? realStartTime;
  final String? realEndTime;
  final String? cancelDateTime;
  final String? signatureName;
  final String? signaturePath;
  final String? reportComment;
  final String? comment;
  final String? notes;
  final bool? endedByAdmin;
  final bool? endedManually;
  final int? status;
  final String? statusName;
  final String? customerId;
  final String? customerName;
  final String? customerPhone;
  final String? customerAddress;
  final double? customerLatitude;
  final double? customerLongitude;
  final String? customerAvatar;

  Mission({
    required this.id,
    required this.companyId,
    required this.employeeId,
    this.plannedStartDateTime,
    this.plannedEndDateTime,
    this.realStartTime,
    this.realEndTime,
    this.cancelDateTime,
    this.signatureName,
    this.signaturePath,
    this.reportComment,
    this.comment,
    this.notes,
    this.endedByAdmin,
    this.endedManually,
    this.status,
    this.statusName,
    this.customerId,
    this.customerName,
    this.customerPhone,
    this.customerAddress,
    this.customerLatitude,
    this.customerLongitude,
    this.customerAvatar,
  });

  factory Mission.fromJson(Map<String, dynamic> json) => Mission(
    id: json['id']?.toString() ?? '',
    companyId: json['companyId']?.toString() ?? '',
    employeeId: json['employeeId']?.toString() ?? '',
    plannedStartDateTime: json['plannedStartDateTime']?.toString() ?? '',
    plannedEndDateTime: json['plannedEndDateTime']?.toString() ?? '',
    realStartTime: json['realStartTime'],
    realEndTime: json['realEndTime'],
    cancelDateTime: json['cancelDateTime']?.toString() ?? '',
    signatureName: json['signatureName']?.toString() ?? '',
    signaturePath: json['signaturePath']?.toString() ?? '',
    reportComment: json['reportComment']?.toString() ?? '',
    comment: json['comment']?.toString() ?? '',
    notes: json['notes']?.toString() ?? json['Notes']?.toString() ?? '',
    endedByAdmin: json['endedByAdmin'] ?? false,
    endedManually: json['endedManually'] ?? false,
    status: (json['status'] != null) ? int.tryParse(json['status'].toString()) : null,
    statusName: json['statusName']?.toString() ?? '',
    customerId: json['customerId']?.toString() ?? '',
    customerName: json['customerName']?.toString() ?? '',
    customerPhone: json['customerPhone']?.toString() ?? '',
    customerAddress: json['customerAddress']?.toString() ?? '',
    customerLatitude: parseDouble(json['customerLatitude']),
    customerLongitude: parseDouble(json['customerLongitude']),
  );

  static double? parseDouble(dynamic value) {
    if (value == null) return null;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    return null;
  }
}
