class GetTimesheetRequest {
  final String month;

  GetTimesheetRequest({required this.month});

  Map<String, dynamic> toJson() {
    return {'month': month};
  }
}
