import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:lottie/lottie.dart';
import 'package:student_sync/controller/api_controller.dart';
import 'package:student_sync/features/chats/models/chat_info.dart';
import 'package:student_sync/features/profile/models/user_info.dart';
import 'package:student_sync/utils/constants/assets.dart';
import 'package:student_sync/utils/routing/app_router.dart';

class AllChats extends StatefulWidget {
  const AllChats({super.key});

  @override
  State<AllChats> createState() => _AllChatsState();
}

class _AllChatsState extends State<AllChats> {
  final APIController apiController = GetIt.I<APIController>();
  late final UserInfo _userInfo;

  @override
  void initState() {
    _userInfo = apiController.getUserInfoSync();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Scaffold(
      body: StreamBuilder<List<ChatInfo>>(
          stream: apiController.getAllChatsStream(),
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
                    var receiver = info.getOtherUser(_userInfo.id);
                    bool showBoldMessage = (!(info.lastMessage.read ?? true) &&
                        info.lastMessage.senderId != _userInfo.id);
                    return Padding(
                      padding: const EdgeInsets.only(top: 5.0),
                      child: Dismissible(
                        key: UniqueKey(),
                        onDismissed: (direction) {
                          //delete chat in firebase firestore
                          apiController.deleteChat(info.chatId);
                        },
                        confirmDismiss: (direction) async {
                          return showAdaptiveDialog<bool>(
                              context: context,
                              builder: (context) {
                                if (Platform.isAndroid) {
                                  return AlertDialog(
                                    title: const Text(
                                        "Are you sure to delete the chat?"),
                                    content: const Text(
                                        "This will delete the chat for others."),
                                    actions: [
                                      TextButton(
                                          onPressed: () {
                                            Navigator.pop(context, true);
                                          },
                                          child: const Text(
                                            "Yes",
                                            style: TextStyle(color: Colors.red),
                                          )),
                                      TextButton(
                                          onPressed: () {
                                            Navigator.pop(context, false);
                                          },
                                          child: Text(
                                            "No",
                                            style: TextStyle(
                                                color:
                                                    theme.colorScheme.primary),
                                          )),
                                    ],
                                  );
                                } else {
                                  return CupertinoAlertDialog(
                                    title: const Text(
                                        "Are you sure to delete the chat?"),
                                    content: const Text(
                                        "This will delete the chat for others."),
                                    actions: [
                                      TextButton(
                                          onPressed: () {
                                            Navigator.pop(context, true);
                                          },
                                          child: const Text(
                                            "Yes",
                                            style: TextStyle(color: Colors.red),
                                          )),
                                      TextButton(
                                          onPressed: () {
                                            Navigator.pop(context, false);
                                          },
                                          child: Text(
                                            "No",
                                            style: TextStyle(
                                                color:
                                                    theme.colorScheme.primary),
                                          )),
                                    ],
                                  );
                                }
                              });
                        },
                        direction: DismissDirection.endToStart,
                        background: Container(color: Colors.red),
                        child: ListTile(
                          onTap: () {
                            context.push(AppRouter.chatScreen, extra: info);
                          },
                          leading: ClipRRect(
                            borderRadius: BorderRadius.circular(50),
                            child: Container(
                              width: 50,
                              height: 50,
                              decoration:
                                  const BoxDecoration(shape: BoxShape.circle),
                              child: CachedNetworkImage(
                                  imageUrl: receiver.userImage,
                                  fit: BoxFit.cover),
                            ),
                          ),
                          title: Text(receiver.username,
                              style: const TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.normal)),
                          subtitle: Text(
                            info.lastMessage.message,
                            maxLines: 1,
                            style: TextStyle(
                                fontSize: 12,
                                fontWeight: showBoldMessage
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                                color: showBoldMessage
                                    ? theme.colorScheme.primary
                                    : Colors.grey),
                          ),
                        ),
                      ),
                    );
                  });
            } else {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Lottie.asset(Assets.startMessagingLottie,
                        height: 160, width: 160),
                    const Text("Start Chatting"),
                  ],
                ),
              );
            }
          }),
    );
  }
}
