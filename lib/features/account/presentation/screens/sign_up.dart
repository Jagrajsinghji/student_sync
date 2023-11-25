import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:student_sync/features/account/presentation/controllers/AccountController.dart';
import 'package:student_sync/features/account/services/account_service.dart';
import 'package:student_sync/utils/constants/assets.dart';
import 'package:student_sync/utils/constants/enums.dart';
import 'package:student_sync/utils/constants/extensions.dart';
import 'package:student_sync/utils/routing/app_router.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  bool hasLetters = false;
  bool hasNumbers = false;
  bool hasSpecialCharacters = false;
  bool isPasswordStrong = false;
  bool isEmailValid = false;
  bool isPasswordMatching = false;
  bool showPassword = false;
  bool showConfirmPassword = false;
  bool isLoading = false;
  List<String> validDomains = <String>[];

  @override
  void initState() {
    super.initState();
    _getAllInstitutes();
  }

  void _getAllInstitutes() {
    GetIt.I<AccountController>().getAllInstitutes().then((value) => mounted
        ? setState(() {
            validDomains.clear();
            validDomains.addAll(value.map((e) => e.domainName));
          })
        : null);
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
        backgroundColor: theme.colorScheme.background,
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
                  child: Text("Register",
                      style: TextStyle(
                        fontSize: 35,
                        fontWeight: FontWeight.w900,
                      ))),
              const SizedBox(
                height: 35,
              ),
              const Text("Please enter your institution email and password.",
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
                      validator: _validatePassword,
                      obscureText: !showPassword,
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      controller: _confirmPasswordController,
                      decoration: InputDecoration(
                          hintText: "Confirm Password",
                          suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  showConfirmPassword = !showConfirmPassword;
                                });
                              },
                              icon: Image.asset(
                                showConfirmPassword
                                    ? Assets.hidePasswordPNG
                                    : Assets.showPasswordPNG,
                                height: 25,
                                color: theme.primaryColor,
                              ))),
                      obscureText: !showConfirmPassword,
                      validator: _validateConfirmPassword,
                    ),
                    const SizedBox(height: 20),
                    ValueListenableBuilder<TextEditingValue>(
                      builder: (c, passwordValue, _) {
                        return Align(
                          alignment: Alignment.centerLeft,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                'Password Strength',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Row(
                                children: [
                                  const Text('- At least 8 characters'),
                                  if (passwordValue.text.length >= 8)
                                    const Icon(
                                      Icons.check,
                                      color: Colors.green,
                                      size: 16,
                                    )
                                ],
                              ),
                              Row(
                                children: [
                                  const Text(
                                      '- Contains both letters and numbers'),
                                  if (hasNumbers & hasLetters)
                                    const Icon(
                                      Icons.check,
                                      color: Colors.green,
                                      size: 16,
                                    )
                                ],
                              ),
                              Row(
                                children: [
                                  const Text(
                                      '- Contains at least one special character'),
                                  if (hasSpecialCharacters)
                                    const Icon(
                                      Icons.check,
                                      color: Colors.green,
                                      size: 16,
                                    )
                                ],
                              ),
                              const SizedBox(height: 40),
                              ValueListenableBuilder<TextEditingValue>(
                                  valueListenable: _emailController,
                                  builder: (con, email, _) {
                                    return ValueListenableBuilder<
                                            TextEditingValue>(
                                        valueListenable:
                                            _confirmPasswordController,
                                        builder: (con, confirmPass, _) {
                                          bool isEnabled = isPasswordStrong &
                                              isEmailValid &
                                              isPasswordMatching;
                                          return Center(
                                            child: ElevatedButton(
                                              onPressed:
                                                  (isEnabled & !isLoading)
                                                      ? _onClickSignUp
                                                      : null,
                                              child: isLoading
                                                  ? LoadingAnimationWidget
                                                      .flickr(
                                                          leftDotColor: theme
                                                              .primaryColor,
                                                          rightDotColor: theme
                                                              .colorScheme
                                                              .secondary,
                                                          size: 30)
                                                  : const Text('Sign Up'),
                                            ),
                                          );
                                        });
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
                                  "Already have an account? Login",
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

  void _onClickSignUp() async {
    FocusScope.of(context).requestFocus(FocusNode());
    if (_formKey.currentState?.validate() ?? false) {
      String email = _emailController.text;
      String password = _passwordController.text;

      try {
        if (mounted) {
          setState(() {
            isLoading = true;
          });
        }
        var response = await GetIt.I<AccountService>()
            .registerUser(email: email, password: password);
        if (response.statusCode == 201) {
          // user created
          if (mounted) {
            var data = response.data as Map;
            GetIt.I<AccountController>()
              ..updateUserOnboardingState(UserOnboardingState.preRegistered)
              ..saveUserData(data['email'], data['_id']);
            context.go(AppRouter.verifyEmailPage);
          }
        } else {
          debugPrint(response.statusCode.toString());
          debugPrint(response.statusMessage.toString());
          Fluttertoast.showToast(
              msg: "${response.data}", toastLength: Toast.LENGTH_LONG);
        }
      } on DioException catch (e, s) {
        debugPrintStack(stackTrace: s, label: e.toString());
        Fluttertoast.showToast(
            msg: "Error while registering the user. ${e.response?.data}",
            toastLength: Toast.LENGTH_LONG);
      } on Exception catch (e, s) {
        debugPrintStack(stackTrace: s, label: e.toString());
        Fluttertoast.showToast(
            msg: "Error while registering the user. ${e.toString()}",
            toastLength: Toast.LENGTH_LONG);
      } finally {
        if (mounted) {
          setState(() {
            isLoading = false;
          });
        }
      }
    }
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

  String? _validatePassword(String? password) {
    String msg = "Weak password";

    const specialCharacters = r'!@#$%^&*()_-+={[]};:<>,.?/';

    hasLetters = false;
    hasNumbers = false;
    hasSpecialCharacters = false;
    isPasswordStrong = false;

    for (var char in (password?.runes ?? <int>[])) {
      final character = String.fromCharCode(char);
      if (RegExp(r'[a-zA-Z]').hasMatch(character)) {
        hasLetters = true;
      } else if (RegExp(r'[0-9]').hasMatch(character)) {
        hasNumbers = true;
      } else if (specialCharacters.contains(character)) {
        hasSpecialCharacters = true;
      }
    }
    if ((password?.length ?? 0) < 8) {
      return msg;
    } else if (hasLetters && hasNumbers && hasSpecialCharacters) {
      isPasswordStrong = true;
      return null;
    } else if (hasLetters && hasNumbers) {
      return msg;
    } else {
      return msg;
    }
  }

  String? _validateConfirmPassword(String? password) {
    isPasswordMatching = false;
    if (_passwordController.text != password) {
      return "Passwords does not match";
    }
    isPasswordMatching = true;
    return null;
  }
}
