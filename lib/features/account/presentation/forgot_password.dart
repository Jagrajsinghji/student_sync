import 'package:flutter/material.dart';
import 'package:student_sync/utils/constants/colors.dart';
import 'package:student_sync/utils/constants/extensions.dart';
import 'package:student_sync/utils/routing/app_router.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();

  bool isEmailValid = false;

  String? _validateEmail(String? value) {
    isEmailValid = false;
    if (value?.isEmpty ?? false) {
      return 'Email is required';
    } else if (!(value?.isEmail() ?? true)) {
      return 'Enter a valid email address';
    }
    isEmailValid = true;
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        body: Padding(
          padding: const EdgeInsets.only(left: 20.0, right: 20),
          child: ListView(
            shrinkWrap: true,
            physics: const BouncingScrollPhysics(),
            children: [
              const SizedBox(
                height: 120,
              ),
              const Align(
                  alignment: Alignment.centerLeft,
                  child: Text("Forgot Password?",
                      style: TextStyle(
                        fontSize: 35,
                        fontWeight: FontWeight.w900,
                      ))),
              const SizedBox(
                height: 35,
              ),
              const Text(
                  "Please enter your email to receive a password reset link.",
                  style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(
                height: 30,
              ),
              Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    TextFormField(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      controller: _emailController,
                      decoration: const InputDecoration(
                        hintText: "Johndoe@mycollege.ca",
                      ),
                      validator: _validateEmail,
                    ),
                    const SizedBox(height: 10),
                    const SizedBox(height: 20),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(height: 40),
                          ValueListenableBuilder<TextEditingValue>(
                              valueListenable: _emailController,
                              builder: (con, email, _) {
                                bool isEnabled = isEmailValid;
                                return Center(
                                  child: ElevatedButton(
                                    style: ButtonStyle(
                                      shape: MaterialStateProperty.all(
                                          RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10))),
                                      minimumSize: MaterialStateProperty.all(
                                          const Size(200, 45)),
                                      backgroundColor: MaterialStateProperty
                                          .resolveWith<Color>(
                                        (Set<MaterialState> states) {
                                          if (states.contains(
                                              MaterialState.disabled)) {
                                            return Colors.grey;
                                          }
                                          return Colors.black;
                                        },
                                      ),
                                    ),
                                    onPressed : null,
                                    child: const Text(
                                      'Send Email',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                );
                              }),
                          const Padding(
                            padding: EdgeInsets.only(top: 20.0),
                            child: Center(child: Text("or")),
                          ),
                          Center(
                              child: TextButton(
                            onPressed: () {
                              Navigator.pushNamedAndRemoveUntil(context,
                                  AppRouter.loginPage, (route) => false);
                            },
                            style: ButtonStyle(
                                shape: MaterialStatePropertyAll(
                                    RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10)))),
                            child: const Text(
                              "Back to Login",
                              style: TextStyle(color: blueColor),
                            ),
                          ))
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
