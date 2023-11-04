import 'package:flutter/material.dart';
import 'package:student_sync/utils/routing/app_router.dart';

class LetsSyncOB extends StatelessWidget {
  const LetsSyncOB({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Spacer(),
          Image.asset("assets/letsync.jpg"),
          const Padding(
            padding: EdgeInsets.all(20.0),
            child: Text("Let's Sync",
                style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold)),
          ),
          const Padding(
            padding: EdgeInsets.all(30.0),
            child: Text(
              "Let's sync with similar interest students, learn and share skills with others.",
              style: TextStyle(fontWeight: FontWeight.w400, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.only(bottom: 20.0),
            child: ElevatedButton(
              style: ButtonStyle(
                shape: MaterialStateProperty.all(RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10))),
                minimumSize: MaterialStateProperty.all(const Size(200, 45)),
                backgroundColor: MaterialStateProperty.resolveWith<Color>(
                  (Set<MaterialState> states) {
                    if (states.contains(MaterialState.disabled)) {
                      return Colors.grey;
                    }
                    return Colors.black;
                  },
                ),
              ),
              onPressed: () {
                Navigator.pushNamedAndRemoveUntil(
                    context, AppRouter.signUpPage, (route) => false);
              },
              child: const Text('Continue',style: TextStyle(color: Colors.white),),
            ),
          ),
        ],
      ),
    );
  }
}
