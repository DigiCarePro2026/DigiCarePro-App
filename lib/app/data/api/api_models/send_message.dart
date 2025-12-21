class SendMessageRequest {
  final String subject;
  final String receiverId;
  final String body;

  SendMessageRequest({required this.subject, required this.receiverId, required this.body});

  Map<String, dynamic> toJson() {
    return {'subject': subject, 'receiverId': receiverId, 'body': body};
  }
}
