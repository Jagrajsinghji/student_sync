import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:student_sync/controller/api_controller.dart';
import 'package:student_sync/controller/location_controller.dart';
import 'package:student_sync/utils/constants/assets.dart';
import 'package:student_sync/utils/constants/enums.dart';
import 'package:student_sync/utils/constants/extensions.dart';
import 'package:student_sync/utils/routing/app_router.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final APIController apiController = GetIt.I<APIController>();
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool isPasswordValid = false;
  bool isEmailValid = false;
  bool showPassword = false;
  bool isLoading = false;

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

  void _onClickLogin() async {
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
        var response = await apiController.login(
            email: email.toLowerCase(), password: password);
        if (response.statusCode == 200) {
          if (mounted) {
            apiController
              ..updateUserOnboardingState(UserOnboardingState.onboarded)
              ..saveUserData(response.data['email'], response.data['_id']);
            await apiController.getUserInfo();
            await GetIt.I<LocationController>().getCurrentGPSLocation();
            if (mounted) {
              context.go(AppRouter.home);
            }
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
            msg: "Error while logging in the user. ${e.response?.data}",
            toastLength: Toast.LENGTH_LONG);
      } on Exception catch (e, s) {
        debugPrintStack(stackTrace: s, label: e.toString());
        Fluttertoast.showToast(
            msg: "Error while logging in the user. ${e.toString()}",
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
                      keyboardType: TextInputType.emailAddress,
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
                      keyboardType:
                          showPassword ? TextInputType.visiblePassword : null,
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
