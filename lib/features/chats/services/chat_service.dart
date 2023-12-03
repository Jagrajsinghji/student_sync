import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:student_sync/features/chats/models/chat_info.dart';
import 'package:student_sync/features/chats/models/chat_message.dart';
import 'package:student_sync/features/chats/models/chat_user_info.dart';

class ChatService {
  final FirebaseFirestore _firestore;

  ChatService({required FirebaseFirestore firestore}) : _firestore = firestore;

  Stream<List<ChatInfo>> getAllChatsStream(String userId) => _firestore
      .collection("Chats")
      .where("users", arrayContains: userId)
      .snapshots()
      .map((event) => event.docs
          .map((doc) => ChatInfo.fromMap(doc.id, doc.data()))
          .toList());

  Stream<List<ChatMessage>> getChatHistoryStream(String chatId) => _firestore
      .collection("Chats")
      .doc(chatId)
      .collection("History")
      .orderBy("sent_at", descending: true)
      .snapshots()
      .map((event) =>
          event.docs.map((doc) => ChatMessage.fromMap(doc.data())).toList());

  Future<ChatInfo> sendMessageToUser(
      ChatUserInfo sender, ChatUserInfo receiver, String message,
      {String? chatId}) async {
    // check if sender and receiver already has a chat session
    if (chatId == null) {
      var snapshot = await _firestore
          .collection("Chats")
          .where("users", arrayContains: sender.userId)
          .get(const GetOptions(source: Source.serverAndCache));
      try {
        chatId = snapshot.docs
            .firstWhere((doc) => ChatInfo.fromMap(doc.id, doc.data())
                .users
                .contains(receiver.userId))
            .id;
      } on StateError {
        debugPrint("no chat id present, starting a new session");
      }
    }

    ChatMessage chatMessage = ChatMessage(
        message: message,
        senderId: sender.userId,
        senderImage: sender.userImage,
        senderName: sender.username,
        sentAt: Timestamp.fromDate(DateTime.now()),
        read: false);

    ChatInfo info = ChatInfo(
        chatId: chatId ?? "",
        lastMessage: chatMessage,
        users: [sender.userId, receiver.userId],
        userInfo: [sender, receiver]);

    await _firestore.runTransaction((transaction) async {
      chatId ??= (await _firestore.collection("Chats").add(info.toMap())).id;
      var docRef = _firestore.collection("Chats").doc(chatId);
      var historyRef = _firestore
          .collection("Chats")
          .doc(chatId)
          .collection("History")
          .doc();
      return transaction
          // update last message
          .update(docRef, info.toMap())
          //update chat history
          .set(historyRef, chatMessage.toMap());
    });
    return ChatInfo.fromChatInfo(chatId!, info);
  }

  Future seenLastMessage(String chatId, String userId) {
    return _firestore.runTransaction((transaction) async {
      var docRef = _firestore.collection("Chats").doc(chatId);
      var snapshot = await transaction.get(docRef);
      if (snapshot.exists && snapshot.data() != null) {
        ChatInfo chatInfo = ChatInfo.fromMap(snapshot.id, snapshot.data()!);
        // if last message is not sent by user then mark it as seen
        if (chatInfo.lastMessage.senderId != userId) {
          chatInfo.lastMessage.markAsRead();
          transaction.set(docRef, chatInfo.toMap(), SetOptions(merge: true));
        }
      }
    });
  }

  Future<void> deleteChat(String chatId) async {
    return _firestore.collection("Chats").doc(chatId).delete();
  }
}
