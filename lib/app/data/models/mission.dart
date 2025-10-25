class Mission {
  final String id;
  final String companyId;
  final String customerId;
  final String employeeId;
  final String? plannedStartDateTime;
  final String? plannedEndDateTime;
  final String? realStartTime;
  final String? realEndTime;
  final String? cancelDateTime;
  final String? signatureName;
  final String? signaturePath;
  final String? reportComment;
  final String? comment;
  final bool? endedByAdmin;
  final bool? endedManually;
  final int? status;

  Mission({
    required this.id,
    required this.companyId,
    required this.customerId,
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
    this.endedByAdmin,
    this.endedManually,
    this.status,
  });

  factory Mission.fromJson(Map<String, dynamic> json) => Mission(
    id: json['id']?.toString() ?? '',
    companyId: json['companyId']?.toString() ?? '',
    customerId: json['customerId']?.toString() ?? '',
    employeeId: json['employeeId']?.toString() ?? '',
    plannedStartDateTime: json['plannedStartDateTime']?.toString() ?? '',
    plannedEndDateTime: json['plannedEndDateTime']?.toString() ?? '',
    realStartTime: json['realStartTime']?.toString() ?? '',
    realEndTime: json['realEndTime']?.toString() ?? '',
    cancelDateTime: json['cancelDateTime']?.toString() ?? '',
    signatureName: json['signatureName']?.toString() ?? '',
    signaturePath: json['signaturePath']?.toString() ?? '',
    reportComment: json['reportComment']?.toString() ?? '',
    comment: json['comment']?.toString() ?? '',
    endedByAdmin: json['endedByAdmin'] ?? false,
    endedManually: json['endedManually'] ?? false,
    status:  (json['status'] != null)
        ? int.tryParse(json['status'].toString())
        : null,

  );
}
