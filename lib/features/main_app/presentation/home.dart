import 'package:flutter/material.dart';
import 'package:awesome_bottom_bar/awesome_bottom_bar.dart';
import 'package:awesome_bottom_bar/widgets/inspired/inspired.dart';
import 'package:student_sync/utils/constants/colors.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
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
          actions: _getAppBarActions()),
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

  List<Widget> _getAppBarActions() {
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
      case 1:
      case 0:
      default:
        return [changeLocation];
    }
  }
}
