class GetDayOffRequest {
  final String month;

  GetDayOffRequest({
    required this.month,
  });

  Map<String, dynamic> toJson() => {
    'month': month,
  };
}
