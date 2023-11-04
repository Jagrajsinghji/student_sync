import 'package:flutter/material.dart';
import 'package:student_sync/utils/constants/colors.dart';
import 'package:student_sync/utils/constants/extensions.dart';
import 'package:student_sync/utils/routing/app_router.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool isPasswordValid = false;
  bool isEmailValid = false;

  void _onClickLogin() {
    if (_formKey.currentState?.validate() ?? false) {
      // Validation passed, do something with the email and password
      String email = _emailController.text;
      String password = _passwordController.text;

      Navigator.of(context).pushReplacementNamed(AppRouter.home);
    }
  }

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

  String? _validatePassword(String? password) {
    String msg = "Invalid password";
    isPasswordValid = false;
    if ((password?.length ?? 0) < 8) {
      return msg;
    }
    isPasswordValid = true;
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
                  child: Text("Login",
                      style: TextStyle(
                        fontSize: 35,
                        fontWeight: FontWeight.w900,
                      ))),
              const SizedBox(
                height: 35,
              ),
              const Text("Please enter your email and password to login.",
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
                    TextFormField(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      controller: _passwordController,
                      decoration: const InputDecoration(
                        hintText: "Password",
                      ),
                      obscureText: true,
                      validator: _validatePassword,
                    ),
                    Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {
                            Navigator.of(context)
                                .pushNamed(AppRouter.forgotPassword);
                          },
                          style: ButtonStyle(
                              shape: MaterialStatePropertyAll(
                                  RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(10)))),
                          child: const Text(
                            "Forgot Password?",
                            style: TextStyle(color: blueColor),
                          ),
                        )),
                    const SizedBox(height: 20),
                    ValueListenableBuilder<TextEditingValue>(
                      builder: (c, value, _) {
                        return Align(
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
                                    bool isEnabled =
                                        isPasswordValid & isEmailValid;
                                    return Center(
                                      child: ElevatedButton(
                                        style: ButtonStyle(
                                          shape: MaterialStateProperty.all(
                                              RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10))),
                                          minimumSize:
                                              MaterialStateProperty.all(
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
                                        onPressed:
                                            isEnabled ? _onClickLogin : null,
                                        child: const Text(
                                          'Login',
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
                                      AppRouter.signUpPage, (route) => false);
                                },
                                style: ButtonStyle(
                                    shape: MaterialStatePropertyAll(
                                        RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10)))),
                                child: const Text(
                                  "No account with us? Register",
                                  style: TextStyle(color: blueColor),
                                ),
                              ))
                            ],
                          ),
                        );
                      },
                      valueListenable: _passwordController,
                    ),
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
