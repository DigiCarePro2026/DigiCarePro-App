class Message {
  final String id;
  final String? senderId;
  final String? senderName;
  final String? receiverName;
  final String subject;
  final String? body;
  final String sentAt;
  bool isRead;

  Message({
    required this.id,
    this.senderId,
    this.senderName,
    this.receiverName,
    required this.subject,
    this.body,
    required this.sentAt,
    required this.isRead,
  });

  factory Message.fromJson(Map<String, dynamic> json) => Message(
    id: json['id'] ?? '',
    senderId: json['senderId'] ?? '',
    senderName: _readString(json, ['senderName', 'senderFullName', 'fromName']),
    receiverName: _readString(json, ['receiverName', 'recipientName', 'toName']),
    subject: json['subject'],
    body: json['body'],
    sentAt: json['sentAt'],
    isRead: json['isRead'],
  );

  static String? _readString(Map<String, dynamic> json, List<String> keys) {
    for (final key in keys) {
      final value = json[key];
      if (value is String && value.trim().isNotEmpty) {
        return value;
      }
    }
    return null;
  }
}
