import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:student_sync/controller/api_controller.dart';
import 'package:student_sync/utils/constants/extensions.dart';
import 'package:student_sync/utils/routing/app_router.dart';
import 'package:student_sync/utils/theme/colors.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final APIController apiController = GetIt.I<APIController>();
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();

  bool isEmailValid = false;
  List<String> validDomains = <String>[];

  @override
  void initState() {
    super.initState();
    _getAllInstitutes();
  }

  void _getAllInstitutes() {
    GetIt.I<APIController>().getAllInstitutes().then((value) => mounted
        ? setState(() {
            validDomains.clear();
            validDomains.addAll(value.map((e) => e.domainName));
          })
        : null);
  }

  String? _validateEmail(String? value) {
    isEmailValid = false;
    if (value?.isEmpty ?? false) {
      return 'Email is required';
    } else if (!(value?.isValidInstitutionEmail(validDomains) ?? true)) {
      return 'Enter a valid institution email address';
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
                      keyboardType: TextInputType.emailAddress,
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
                                    onPressed: () {
                                      FocusScope.of(context)
                                          .requestFocus(FocusNode());
                                    },
                                    child: const Text(
                                      'Send Email',
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
                              context.go(AppRouter.loginPage);
                            },
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
