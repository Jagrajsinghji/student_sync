import 'package:flutter/material.dart';
import 'package:onboarding_animation/onboarding_animation.dart';
import 'package:student_sync/features/onboarding/presentation/letssync_ob.dart';
import 'package:student_sync/features/onboarding/presentation/location_ob.dart';
import 'package:student_sync/features/onboarding/presentation/notifications_ob.dart';

class Onboarding extends StatefulWidget {
  const Onboarding({super.key});

  @override
  State<Onboarding> createState() => _OnboardingState();
}

class _OnboardingState extends State<Onboarding> {
  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      body: OnBoardingAnimation(
        pages: const [NotificationOB(), LocationOB(), LetsSyncOB()],
        indicatorPaintStyle: PaintingStyle.stroke,
        indicatorWormType: WormType.underground,
        indicatorSwapType: SwapType.yRotation,
        indicatorActiveDotColor: theme.primaryColor,
      ),
    );
  }
}
