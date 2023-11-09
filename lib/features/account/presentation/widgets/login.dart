import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:student_sync/utils/constants/assets.dart';
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
  bool showPassword = false;
  bool isLoading = false;

  void _onClickLogin() {
    if (_formKey.currentState?.validate() ?? false) {
      // Validation passed, do something with the email and password
      String email = _emailController.text;
      String password = _passwordController.text;

      context.go(AppRouter.home);
    }
  }

  String? _validateEmail(String? value) {
    isEmailValid = false;
    if (value?.isEmpty ?? false) {
      return 'Email is required';
    } else if (!(value?.isValidInstitutionEmail() ?? true)) {
      return 'Enter a valid institution email address';
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
    var theme = Theme.of(context);
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
                      obscureText: !showPassword,
                      validator: _validatePassword,
                      decoration: InputDecoration(
                          hintText: "Password",
                          suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  showPassword = !showPassword;
                                });
                              },
                              icon: Image.asset(
                                showPassword
                                    ? Assets.hidePasswordPNG
                                    : Assets.showPasswordPNG,
                                color: theme.primaryColor,
                                height: 25,
                              ))),
                    ),
                    Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {
                            context.go(AppRouter.forgotPassword);
                          },
                          child: const Text(
                            "Forgot Password?",
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
                                        onPressed:
                                            isEnabled ? _onClickLogin : null,
                                        child: isLoading
                                            ? LoadingAnimationWidget.flickr(
                                                leftDotColor:
                                                    theme.primaryColor,
                                                rightDotColor:
                                                    theme.colorScheme.secondary,
                                                size: 30)
                                            : const Text(
                                                'Login',
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
                                  context.go(AppRouter.signUpPage);
                                },
                                child: const Text(
                                  "No account with us? Register",
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
