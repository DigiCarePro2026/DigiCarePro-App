class CreateMissionRequest {
  final String customerId;
  final String date;
  final String startTime;
  final String endTime;
  final String? comment;

  CreateMissionRequest({
    required this.customerId,
    required this.date,
    required this.startTime,
    required this.endTime,
    this.comment,
  });

  Map<String, dynamic> toJson() => {
    'customerId': customerId,
    'date': date,
    'startTime': startTime,
    'endTime': endTime,
    'comment': comment,
  };
}
