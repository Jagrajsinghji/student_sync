import 'package:cloud_firestore/cloud_firestore.dart';

class ChatMessage {
  final String message;
  final String senderId;
  final String senderImage;
  final String senderName;
  final Timestamp sentAt;
  bool? read;

  ChatMessage(
      {required this.message,
      required this.senderId,
      required this.senderImage,
      required this.senderName,
      required this.sentAt,
      required this.read});

  factory ChatMessage.fromMap(Map data) {
    return ChatMessage(
        message: data['message'],
        senderId: data['sender_id'],
        senderImage: data['sender_image'],
        senderName: data['sender_name'],
        sentAt: data['sent_at'],
        read: data['read']);
  }

  Map<String, dynamic> toMap({bool asLastMessage = false}) => {
        "message": message,
        "sender_id": senderId,
        "sender_image": senderImage,
        "sender_name": senderName,
        "sent_at": sentAt,
        if (asLastMessage) "read": read ?? false
      };

  void markAsRead() {
    read = true;
  }
}
