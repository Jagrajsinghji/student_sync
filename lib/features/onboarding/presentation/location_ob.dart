import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

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
    return Container(
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset("assets/location.jpg"),
          const Padding(
            padding: EdgeInsets.all(20.0),
            child: Text("Know Everyone",
                style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold)),
          ),
          const Padding(
            padding: EdgeInsets.all(30.0),
            child: Text(
              "Allow location access to know what's happening around you and sync with nearby people.",
              style: TextStyle(fontWeight: FontWeight.w400, color: Colors.grey),
            ),
          )
        ],
      ),
    );
  }

  void askLocationPermissions() {
    Permission.locationWhenInUse.request();
  }
}
