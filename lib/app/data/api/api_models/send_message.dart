class SendMessageRequest{

  final String subject;
  final String body;

  SendMessageRequest({required this.subject, required this.body});

  Map<String, dynamic> toJson() {
    return {'subject': subject, 'body': body};
  }
}