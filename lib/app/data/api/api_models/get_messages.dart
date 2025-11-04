import 'dart:core';
import 'package:digi_care_pro/app/data/models/message.dart';
import 'package:digi_care_pro/app/data/models/paging_model.dart';

class GetMessagesResponse {
  final List<Message> messages;
  final PagingModel pagingModel;

  GetMessagesResponse({required this.messages, required this.pagingModel});

  factory GetMessagesResponse.fromJson(Map<String, dynamic> json) => GetMessagesResponse(
    messages: (json['items'] as List).map((item) => Message.fromJson(item)).toList(),
    pagingModel: PagingModel(page: json['page'], pageSize: json['pageSize'], totalCount: json['totalCount']),
  );
}
