import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:student_sync/controller/api_controller.dart';
import 'package:student_sync/controller/location_controller.dart';
import 'package:student_sync/utils/constants/assets.dart';
import 'package:student_sync/utils/constants/enums.dart';
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
    timer = Timer(splashDuration, () async {
      APIController controller = GetIt.I<APIController>();
      UserOnboardingState state = controller.getUserOnboardingState();
      String? email = controller.getSavedUserEmail();
      String? userId = controller.getSavedUserId();
      print(state);
      print(email);
      print(userId);
      if (email == null || userId == null) {
        state = UserOnboardingState.none;
      }
      switch (state) {
        case UserOnboardingState.none:
          context.go(AppRouter.onboarding);
          break;
        case UserOnboardingState.preRegistered:
          context.go(AppRouter.verifyEmailPage);
          break;
        case UserOnboardingState.verifiedEmail:
          context.go(AppRouter.tellUsMore);
          break;
        case UserOnboardingState.registered:
          context.go(AppRouter.studentIdCapture);
          break;
        case UserOnboardingState.idAdded:
          context.go(AppRouter.addSkills);
          break;
        case UserOnboardingState.addedOwnSkills:
          context.go(AppRouter.learnSkills);
          break;
        case UserOnboardingState.onboarded:
          await GetIt.I<LocationController>().getCurrentGPSLocation();
          await controller.getUserInfo();
          if (mounted) {
            context.go(AppRouter.home);
          }
          break;
      }
    });
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
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
                      Assets.iconPng,
                      height: imageSize,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Text("Student Sync",
                          style: TextStyle(
                              fontSize: 35 * value, color: theme.primaryColor)),
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
