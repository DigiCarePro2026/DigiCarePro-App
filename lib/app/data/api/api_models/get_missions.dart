class GetMissionsRequest {
  final String? customerId;
  final int year;
  final int month;

  GetMissionsRequest({this.customerId, required this.year, required this.month});

  Map<String, dynamic> toJson() {
    return {'customerId': customerId};
  }
}
