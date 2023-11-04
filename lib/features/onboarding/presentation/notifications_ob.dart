import 'dart:async';

import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class NotificationOB extends StatefulWidget {
  const NotificationOB({super.key});

  @override
  State<NotificationOB> createState() => _NotificationOBState();
}

class _NotificationOBState extends State<NotificationOB> {
  @override
  void initState() {
    super.initState();
    askNotificationPermissions();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xffd1e0e5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset("assets/notifications.jpg"),
          const Padding(
            padding: EdgeInsets.all(20.0),
            child: Text("Feel Connected",
                style: TextStyle(fontSize: 45, fontWeight: FontWeight.bold)),
          ),
          const Padding(
            padding: EdgeInsets.all(30.0),
            child: Text(
              "Notifications and Chats to get latest updates and feel connected with the community.",
              style: TextStyle(fontWeight: FontWeight.w400, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
          )
        ],
      ),
    );
  }

  Future<void> askNotificationPermissions() async {
    Permission.notification.request();
  }
}
