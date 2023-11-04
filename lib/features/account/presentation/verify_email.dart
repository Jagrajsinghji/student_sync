import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:student_sync/utils/constants/colors.dart';
import 'package:student_sync/utils/routing/app_router.dart';

class VerifyEmail extends StatefulWidget {
  const VerifyEmail({super.key});

  @override
  State<VerifyEmail> createState() => _VerifyEmailState();
}

class _VerifyEmailState extends State<VerifyEmail> {
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
              child: TextButton(
                  style: ButtonStyle(
                      padding: const MaterialStatePropertyAll(EdgeInsets.zero),
                      shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)))),
                  onPressed: () {
                    Navigator.of(context)
                        .pushReplacementNamed(AppRouter.tellUsMore);
                  },
                  child: const Text(
                    "Resend Email",
                    style: TextStyle(fontSize: 16, color: blueColor),
                  )),
            ),
            Lottie.asset("assets/verifyEmailLottie.json")
          ],
        ),
      ),
    );
  }
}
