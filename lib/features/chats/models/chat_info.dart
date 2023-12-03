import 'package:student_sync/features/chats/models/chat_message.dart';
import 'package:student_sync/features/chats/models/chat_user_info.dart';

class ChatInfo {
  final String chatId;
  final ChatMessage lastMessage;
  final List<String> users;
  final List<ChatUserInfo> userInfo;

  ChatInfo(
      {required this.chatId,
      required this.lastMessage,
      required this.users,
      required this.userInfo});

  factory ChatInfo.fromMap(String chatId, Map<String, dynamic> data) {
    return ChatInfo(
        chatId: chatId,
        lastMessage: ChatMessage.fromMap(data['last_message']),
        users: (data['users'] as List).cast<String>(),
        userInfo: (data['user_info'] as List)
            .map((e) => ChatUserInfo.fromMap(e))
            .toList());
  }

  Map<String, dynamic> toMap() => {
        "last_message": lastMessage.toMap(asLastMessage: true),
        "users": users,
        "user_info": userInfo.map((e) => e.toMap()).toList()
      };

  ChatUserInfo getOtherUser(String myUserId) =>
      userInfo.firstWhere((element) => element.userId != myUserId);

  ChatUserInfo getMyInfo(String userId) =>
      userInfo.firstWhere((element) => element.userId == userId);

  factory ChatInfo.fromChatInfo(String id, ChatInfo info) {
    return ChatInfo(
        chatId: id,
        lastMessage: info.lastMessage,
        users: info.users,
        userInfo: info.userInfo);
  }
}
