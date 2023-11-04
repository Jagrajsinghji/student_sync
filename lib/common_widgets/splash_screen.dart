import 'dart:async';

import 'package:flutter/material.dart';
import 'package:student_sync/utils/constants/colors.dart';
import 'package:student_sync/utils/routing/app_router.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late Timer timer;
  final splashDuration = const Duration(seconds: 3);

  @override
  void initState() {
    super.initState();
    timer = Timer(splashDuration, () {
      Navigator.of(context).pushReplacementNamed(AppRouter.onboarding);
    });
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: TweenAnimationBuilder(
        builder: (_, value, __) {
          double imageSize = 150 * value;
          return Center(
            child: Stack(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      "assets/icon.png",
                      height: imageSize,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Text("Student Sync",
                          style: TextStyle(
                              fontSize: 35 * value, color: blueColor)),
                    )
                  ],
                ),
              ],
            ),
          );
        },
        duration: const Duration(seconds: 3),
        curve: Curves.easeOutCubic,
        tween: Tween(begin: 0.0, end: 1.0),
      ),
    );
  }
}
