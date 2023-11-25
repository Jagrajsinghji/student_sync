import 'package:student_sync/features/chats/models/chat_message.dart';
import 'package:student_sync/features/chats/models/chat_user_info.dart';

class ChatInfo {
  final ChatMessage lastMessage;
  final List<String> users;
  final List<ChatUserInfo> userInfo;

  ChatInfo(
      {required this.lastMessage, required this.users, required this.userInfo});

  factory ChatInfo.fromMap(Map<String, dynamic> data) {
    return ChatInfo(
        lastMessage: ChatMessage.fromMap(data['last_message']),
        users: (data['users'] as List).cast<String>() ,
        userInfo: (data['user_info'] as List)
            .map((e) => ChatUserInfo.fromMap(e))
            .toList());
  }

  Map<String, dynamic> toMap() => {
        "last_message": lastMessage.toMap(asLastMessage: true),
        "users": users,
        "user_info": userInfo.map((e) => e.toMap()).toList()
      };
}
