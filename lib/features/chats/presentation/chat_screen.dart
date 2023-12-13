import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:lottie/lottie.dart';
import 'package:student_sync/controller/api_controller.dart';
import 'package:student_sync/features/chats/models/chat_info.dart';
import 'package:student_sync/features/chats/models/chat_message.dart';
import 'package:student_sync/features/chats/models/chat_user_info.dart';
import 'package:student_sync/features/profile/models/user_info.dart';
import 'package:student_sync/utils/constants/assets.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key, required this.chatInfo});

  final ChatInfo chatInfo;

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final APIController apiController = GetIt.I<APIController>();
  final TextEditingController _messageFieldController = TextEditingController();

  late final ChatInfo info;

  late final ChatUserInfo receiver, sender;

  late final UserInfo _userInfo;

  @override
  void initState() {
    info = widget.chatInfo;
    _userInfo = apiController.getUserInfoSync();
    receiver = info.getOtherUser(_userInfo.id);
    sender = info.getMyInfo(_userInfo.id);
    super.initState();
    bool readLastMessage = (!(info.lastMessage.read ?? true) &&
        info.lastMessage.senderId != _userInfo.id);
    if (readLastMessage) {
      apiController.seenLastMessage(info.chatId, _userInfo.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(120),
          child: Padding(
            padding: const EdgeInsets.only(top: 50),
            child: SizedBox(
              height: double.maxFinite,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Align(
                    alignment: Alignment.topLeft,
                    child: BackButton(onPressed: () {
                      context.pop();
                    }),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(30),
                        child: Container(
                          width: 60,
                          height: 60,
                          decoration:
                              const BoxDecoration(shape: BoxShape.circle),
                          child: CachedNetworkImage(
                              imageUrl: receiver.userImage, fit: BoxFit.cover),
                        ),
                      ),
                      Expanded(child: Text(receiver.username)),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        body: Column(
          children: [
            Expanded(
              child: StreamBuilder<List<ChatMessage>>(
                  stream: apiController.getChatHistoryStream(info.chatId),
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
                          ChatMessage message = listOfChats[index];
                          bool sentByMe = message.senderId == _userInfo.id;
                          if (sentByMe) {
                            return Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ConstrainedBox(
                                    constraints:
                                        const BoxConstraints(maxWidth: 300),
                                    child: Padding(
                                      padding:
                                          const EdgeInsets.only(right: 10.0),
                                      child: Text(
                                        message.message,
                                        style: const TextStyle(fontSize: 14),
                                        textAlign: TextAlign.justify,
                                      ),
                                    ),
                                  ),
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(15),
                                    child: Container(
                                      width: 30,
                                      height: 30,
                                      decoration: const BoxDecoration(
                                          shape: BoxShape.circle),
                                      child: CachedNetworkImage(
                                          imageUrl: message.senderImage,
                                          fit: BoxFit.cover),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          } else {
                            return Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(15),
                                    child: Container(
                                      width: 30,
                                      height: 30,
                                      decoration: const BoxDecoration(
                                          shape: BoxShape.circle),
                                      child: CachedNetworkImage(
                                          imageUrl: message.senderImage,
                                          fit: BoxFit.cover),
                                    ),
                                  ),
                                  ConstrainedBox(
                                    constraints:
                                        const BoxConstraints(maxWidth: 300),
                                    child: Padding(
                                      padding:
                                          const EdgeInsets.only(left: 10.0),
                                      child: Text(
                                        message.message,
                                        style: const TextStyle(fontSize: 14),
                                        textAlign: TextAlign.justify,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }
                        },
                        reverse: true,
                      );
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
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 10.0, right: 10, bottom: 25, top: 0),
              child: TextField(
                  controller: _messageFieldController,
                  maxLines: null,
                  keyboardType: TextInputType.multiline,
                  textCapitalization: TextCapitalization.sentences,
                  decoration: InputDecoration(
                      isDense: true,
                      hintText: "Start typing...",
                      suffixIcon: IconButton(
                          onPressed: () {
                            String message =
                                _messageFieldController.text.trim();
                            if (message.isNotEmpty) {
                              apiController.sendMessageToUser(
                                  sender, receiver, message);
                              _messageFieldController.clear();
                            }
                          },
                          icon: const Icon(Icons.send),
                          iconSize: 25,
                          color: theme.primaryColor),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide:
                              BorderSide(color: Colors.grey.shade300)))),
            ),
          ],
        ),
      ),
    );
  }
}
