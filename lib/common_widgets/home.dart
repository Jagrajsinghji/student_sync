import 'dart:io';

import 'package:awesome_bottom_bar/awesome_bottom_bar.dart';
import 'package:awesome_bottom_bar/widgets/inspired/inspired.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:student_sync/controller/api_controller.dart';
import 'package:student_sync/controller/bottom_nav_controller.dart';
import 'package:student_sync/features/channel/presentation/general_channel.dart';
import 'package:student_sync/features/chats/presentation/all_chats.dart';
import 'package:student_sync/features/profile/presentation/profile.dart';
import 'package:student_sync/utils/constants/assets.dart';
import 'package:student_sync/utils/routing/app_router.dart';
import 'package:student_sync/utils/theme/colors.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final APIController apiController = GetIt.I<APIController>();
  final BottomNavController bottomNavController =
      GetIt.I<BottomNavController>();


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
        icon: Icons.person_outline_rounded,
        title: 'Profile',
      ),
    ];
    return ValueListenableBuilder<int>(
        valueListenable: bottomNavController.currentIndex,
        builder: (context, selectedIndex, _) {
          return Scaffold(
            appBar: AppBar(
                title: Text(_getAppBarTitle(selectedIndex),
                    style: const TextStyle(
                        fontSize: 25, fontWeight: FontWeight.bold)),
                centerTitle: false,
                actions: _getAppBarActions(theme, selectedIndex)),
            body: getBody(selectedIndex),
            bottomNavigationBar: BottomBarInspiredOutside(
              items: items,
              backgroundColor: blueColor,
              color: Colors.white,
              colorSelected: Colors.white,
              indexSelected: selectedIndex,
              onTap: (int index) => bottomNavController.setIndex(index),
              top: -25,
              animated: true,
              itemStyle: ItemStyle.hexagon,
              chipStyle:
                  const ChipStyle(drawHexagon: true, background: blueColor),
            ),
          );
        });
  }

  String _getAppBarTitle(int selectedIndex) {
    switch (selectedIndex) {
      case 3:
        return "Profile";
      case 2:
        return "Chats";
      case 1:
        return "General Channel";
      case 0:
      default:
        return "People Around";
    }
  }

  List<Widget> _getAppBarActions(ThemeData theme, int selectedIndex) {
    var changeLocation = IconButton(
        icon: const Icon(Icons.edit_location_outlined),
        iconSize: 30,
        tooltip: "Change Location",
        padding: const EdgeInsets.only(right: 10),
        onPressed: () {});

    switch (selectedIndex) {
      case 3:
        //profile
        return [
          IconButton(
            onPressed: () async {
              context.push(AppRouter.editProfile,
                  extra: apiController.getUserInfoSync());
            },
            icon: Image.asset(
              Assets.editProfilePNG,
              height: 30,
              width: 30,
              color: theme.colorScheme.primary,
            ),
            tooltip: "Edit Profile",
            padding: const EdgeInsets.only(right: 10),
          ),
          IconButton(
            onPressed: () {
              apiController.logout();
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
            onPressed: () {},
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
        // general channel
        return [
          IconButton(
              icon: const Icon(Icons.post_add_outlined),
              iconSize: 30,
              tooltip: "Add Post",
              padding: const EdgeInsets.only(right: 10),
              onPressed: () async {
                var file = await _pickImage();
                if (file == null) return;
                if (mounted) {
                  await context.push(AppRouter.addPost, extra: File(file.path));
                  if (mounted) {
                    setState(() {});
                  }
                }
              })
        ];
      case 0:
      default:
        return [changeLocation];
    }
  }

  Widget? getBody(int selectedIndex) {
    switch (selectedIndex) {
      //profile
      case 3:
        return const Profile();
      //chats
      case 2:
        return const AllChats();
      //general channel
      case 1:
        return const GeneralChannel();
    }
    return null;
  }

  Future<XFile?> _pickImage() async {
    var source = await showDialog<ImageSource?>(
      context: context,
      builder: (context) => AlertDialog(
        content: const Text(
          'Choose an image source',
          style: TextStyle(fontSize: 16),
        ),
        actions: [
          Center(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context, ImageSource.camera),
                child: const Text('Camera'),
              ),
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context, ImageSource.gallery),
                child: const Text('Gallery'),
              ),
            ),
          ),
        ],
      ),
    );
    if (source == null) return null;
    final pickedFile = await ImagePicker().pickImage(source: source);
    if (pickedFile == null) return null;
    return pickedFile;
  }
}
