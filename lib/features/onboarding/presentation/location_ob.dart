import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:student_sync/utils/constants/assets.dart';

class LocationOB extends StatefulWidget {
  const LocationOB({super.key});

  @override
  State<LocationOB> createState() => _LocationOBState();
}

class _LocationOBState extends State<LocationOB> {
  @override
  void initState() {
    super.initState();
    askLocationPermissions();
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(Assets.locationPNG),
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: Text("Know Everyone",
              style: TextStyle(
                  fontSize: 50,
                  fontWeight: FontWeight.bold,
                  color: theme.primaryColor)),
        ),
        const Padding(
          padding: EdgeInsets.all(30.0),
          child: Text(
            "Allow location access to know what's happening around you and sync with nearby people.",
            style:
                TextStyle(fontWeight: FontWeight.w400, color: Colors.blueGrey),
            textAlign: TextAlign.center,
          ),
        )
      ],
    );
  }

  void askLocationPermissions() {
    Permission.locationWhenInUse.request();
  }
}
