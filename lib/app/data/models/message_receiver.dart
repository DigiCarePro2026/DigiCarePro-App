class MessageReceiver {
  final String? id;
  final String fullName;

  MessageReceiver({
    this.id,
    required this.fullName,
  });

  factory MessageReceiver.fromJson(Map<String, dynamic> json) => MessageReceiver(
    id: json['id'],
    fullName: json['fullName'] ?? '',
  );
}
