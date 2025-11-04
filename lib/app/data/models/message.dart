class Message {
  final String id;
  final String? senderId;
  final String subject;
  final String? body;
  final String sentAt;
  final bool isRead;

  Message({
    required this.id,
    this.senderId,
    required this.subject,
    this.body,
    required this.sentAt,
    required this.isRead,
  });

  factory Message.fromJson(Map<String, dynamic> json) => Message(
    id: json['id'] ?? '',
    senderId: json['senderId'] ?? '',
    subject: json['subject'],
    body: json['body'],
    sentAt: json['sentAt'],
    isRead: json['isRead'],
  );
}
