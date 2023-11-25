import 'package:awesome_bottom_bar/awesome_bottom_bar.dart';
import 'package:awesome_bottom_bar/widgets/inspired/inspired.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:student_sync/features/account/presentation/controllers/AccountController.dart';
import 'package:student_sync/features/chats/models/chat_user_info.dart';
import 'package:student_sync/features/chats/presentation/all_chats.dart';
import 'package:student_sync/features/chats/services/chat_service.dart';
import 'package:student_sync/utils/constants/assets.dart';
import 'package:student_sync/utils/routing/app_router.dart';
import 'package:student_sync/utils/theme/colors.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    List<TabItem> items = [
      const TabItem(
        icon: Icons.groups_3_outlined,
        title: 'People',
      ),
      const TabItem(
        icon: Icons.broadcast_on_home,
        title: 'Channel',
      ),
      const TabItem(
        icon: Icons.chat_outlined,
        title: 'Messages',
      ),
      const TabItem(
        icon: Icons.notifications_outlined,
        title: 'Notification',
      ),
      const TabItem(
        icon: Icons.person_outline_rounded,
        title: 'Profile',
      ),
    ];
    return Scaffold(
      appBar: AppBar(
          title: Text(_getAppBarTitle(),
              style:
                  const TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
          centerTitle: false,
          actions: _getAppBarActions(theme)),
      body: getBody(),
      bottomNavigationBar: BottomBarInspiredOutside(
        items: items,
        backgroundColor: blueColor,
        color: Colors.white,
        colorSelected: Colors.white,
        indexSelected: selectedIndex,
        onTap: (int index) => setState(() {
          selectedIndex = index;
        }),
        top: -25,
        animated: true,
        itemStyle: ItemStyle.hexagon,
        chipStyle: const ChipStyle(drawHexagon: true, background: blueColor),
      ),
    );
  }

  String _getAppBarTitle() {
    switch (selectedIndex) {
      case 4:
        return "Profile";
      case 3:
        return "Updates";
      case 2:
        return "Chats";
      case 1:
        return "General Channel";
      case 0:
      default:
        return "People Around";
    }
  }

  List<Widget> _getAppBarActions(ThemeData theme) {
    var addPost = IconButton(
        icon: const Icon(Icons.post_add_outlined),
        iconSize: 30,
        tooltip: "Add Post",
        padding: const EdgeInsets.only(right: 10),
        onPressed: () {});
    var changeLocation = IconButton(
        icon: const Icon(Icons.edit_location_outlined),
        iconSize: 30,
        tooltip: "Change Location",
        padding: const EdgeInsets.only(right: 10),
        onPressed: () {});

    switch (selectedIndex) {
      case 4:
        //profile
        return [
          IconButton(
            onPressed: () {
              GetIt.I<AccountController>().logout();
              context.go(AppRouter.loginPage);
            },
            icon: const Icon(Icons.logout_outlined),
            iconSize: 30,
            tooltip: "Logout",
            padding: const EdgeInsets.only(right: 10),
          )
        ];
      case 2:
        //chats
        return [
          IconButton(
            onPressed: () {
              ChatUserInfo sender = ChatUserInfo(userId: '655ea0900eeb394fdcfbcc3b', username: "Jagraj Singh Ji", userImage: "https://res.cloudinary.com/dudgkului/image/upload/v1700698717/profile/1700698714892.png");
              ChatUserInfo receiver = ChatUserInfo(userId: '655d7c078546b92c8076e116', username: "Jagraj Singh", userImage: "https://res.cloudinary.com/dudgkului/image/upload/v1700698717/profile/1700698714892.png");
              GetIt.I<ChatService>().sendMessageToUser(sender, receiver, "Hi Man.");
            },
            icon: Image.asset(
              Assets.sendNewMessage,
              color: theme.colorScheme.primary,
              height: 25,
              width: 25,
            ),
            tooltip: "New Message",
            padding: const EdgeInsets.only(right: 10),
          )
        ];
      case 1:
      case 0:
      default:
        return [changeLocation];
    }
  }

  Widget? getBody() {
    switch (selectedIndex) {
      //chats
      case 2:
        return const AllChats();
    }
  }
}
