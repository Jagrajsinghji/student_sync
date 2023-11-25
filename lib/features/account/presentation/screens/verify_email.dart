import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import 'package:student_sync/features/account/presentation/controllers/AccountController.dart';
import 'package:student_sync/features/account/services/account_service.dart';
import 'package:student_sync/utils/constants/enums.dart';
import 'package:student_sync/utils/routing/app_router.dart';

class VerifyEmail extends StatefulWidget {
  const VerifyEmail({super.key});

  @override
  State<VerifyEmail> createState() => _VerifyEmailState();
}

class _VerifyEmailState extends State<VerifyEmail> {
  static const _timerDuration = 60;
  final StreamController _timerStream = StreamController<int>();
  Timer? _resendCodeTimer;

  @override
  void initState() {
    super.initState();
    _sendVerificationEmail();
  }

  @override
  void dispose() {
    _timerStream.close();
    _resendCodeTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(left: 20.0, right: 20),
        child: ListView(
          shrinkWrap: true,
          physics: const BouncingScrollPhysics(),
          children: [
            const SizedBox(
              height: 80,
            ),
            const Align(
                alignment: Alignment.centerLeft,
                child: Text("Let's Verify",
                    style: TextStyle(
                      fontSize: 35,
                      fontWeight: FontWeight.w900,
                    ))),
            const SizedBox(
              height: 25,
            ),
            const Text(
                "We have sent you a link to verify your institution's email. Please check your email to complete verification.",
                style: TextStyle(fontSize: 16)),
            Align(
              alignment: Alignment.centerLeft,
              child: StreamBuilder(
                stream: _timerStream.stream,
                builder: (BuildContext ctx, AsyncSnapshot snapshot) {
                  return TextButton(
                    style: const ButtonStyle(
                      padding: MaterialStatePropertyAll(EdgeInsets.zero),
                    ),
                    onPressed:
                        snapshot.data == 0 ? _sendVerificationEmail : null,
                    child: snapshot.data == 0
                        ? const Text(
                            'Resend Email',
                            style: TextStyle(fontSize: 16),
                          )
                        : Text(
                            'Resend Email in ${snapshot.hasData ? snapshot.data.toString() : 30} seconds ',
                            style: const TextStyle(fontSize: 16),
                          ),
                  );
                },
              ),
            ),
            Container(
                color: Colors.transparent,
                child: Lottie.asset("assets/verifyEmailLottie.json")),
            ElevatedButton(
                onPressed: () {
                  context.go(AppRouter.tellUsMore);
                  GetIt.I<AccountController>().updateUserOnboardingState(
                      UserOnboardingState.verifiedEmail);
                },
                child: const Text("Continue"))
          ],
        ),
      ),
    );
  }

  void _sendVerificationEmail() {
    var accountController = GetIt.I<AccountController>();
    String? email = accountController.getSavedUserEmail();
    throwIf(email == null,
        "No email saved for the user. Restart from onboarding or login");
    GetIt.I<AccountService>().sendVerificationEmail(email!).then((value) {
      _timerStream.sink.add(_timerDuration);
      _activateResendTimer();
    });
  }

  void _activateResendTimer() {
    _resendCodeTimer?.cancel();
    _resendCodeTimer = null;
    _resendCodeTimer =
        Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      var timeLeft = _timerDuration - timer.tick;
      if (timeLeft > 0) {
        _timerStream.sink.add(timeLeft);
      } else {
        _timerStream.sink.add(0);
        _resendCodeTimer?.cancel();
        _resendCodeTimer = null;
      }
    });
  }
}
