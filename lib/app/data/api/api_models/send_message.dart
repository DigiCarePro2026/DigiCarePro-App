class SendMessageRequest {
  final String subject;
  final String? receiverId;
  final String body;

  SendMessageRequest({required this.subject, this.receiverId, required this.body});

  Map<String, dynamic> toJson() {
    return {'subject': subject, 'receiverId': receiverId, 'body': body};
  }
}
