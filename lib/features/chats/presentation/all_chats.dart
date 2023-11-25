import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:student_sync/features/account/presentation/controllers/AccountController.dart';
import 'package:student_sync/features/chats/models/chat_info.dart';
import 'package:student_sync/features/chats/services/chat_service.dart';

class AllChats extends StatefulWidget {
  const AllChats({super.key});

  @override
  State<AllChats> createState() => _AllChatsState();
}

class _AllChatsState extends State<AllChats> {
  ChatService chatService = GetIt.I<ChatService>();
  String userId = GetIt.I<AccountController>().getSavedUserId() ??
      "655ea0900eeb394fdcfbcc3b";

  @override
  Widget build(BuildContext context) {
    print(userId);
    var theme = Theme.of(context);
    return Scaffold(
      body: StreamBuilder<List<ChatInfo>>(
          stream: chatService.getAllChatsStream(userId),
          builder: (_, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: LoadingAnimationWidget.flickr(
                    leftDotColor: theme.primaryColor,
                    rightDotColor: theme.colorScheme.primary,
                    size: 50),
              );
            }
            if (snapshot.hasData && snapshot.data!.isNotEmpty) {
              var listOfChats = snapshot.data!;
              return ListView.builder(
                  itemCount: listOfChats.length,
                  itemBuilder: (_, index) {
                    ChatInfo info = listOfChats[index];
                    return Text(info.lastMessage.message);
                  });
            } else {
              return Text("No Chats");
            }
          }),
    );
  }
}
