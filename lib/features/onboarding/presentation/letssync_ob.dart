import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:student_sync/utils/constants/assets.dart';
import 'package:student_sync/utils/routing/app_router.dart';

class LetsSyncOB extends StatelessWidget {
  const LetsSyncOB({super.key});

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Spacer(),
        Image.asset(Assets.letsSyncPNG),
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: Text("Let's Sync",
              style: TextStyle(
                  fontSize: 50,
                  fontWeight: FontWeight.bold,
                  color: theme.primaryColor)),
        ),
        const Padding(
          padding: EdgeInsets.all(30.0),
          child: Text(
            "Let's sync with similar interest students, learn and share skills with others.",
            style:
                TextStyle(fontWeight: FontWeight.w400, color: Colors.blueGrey),
            textAlign: TextAlign.center,
          ),
        ),
        const Spacer(),
        Padding(
          padding: const EdgeInsets.only(bottom: 20.0),
          child: ElevatedButton(
            onPressed: () {
              context.go(AppRouter.signUpPage);
            },
            child: const Text(
              'Continue',
            ),
          ),
        ),
      ],
    );
  }
}
