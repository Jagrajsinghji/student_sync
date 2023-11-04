import 'package:flutter/material.dart';
import 'package:student_sync/common_widgets/not_found_page.dart';
import 'package:student_sync/common_widgets/splash_screen.dart';
import 'package:student_sync/features/account/presentation/add_skills.dart';
import 'package:student_sync/features/account/presentation/forgot_password.dart';
import 'package:student_sync/features/account/presentation/tell_us_more.dart';
import 'package:student_sync/features/account/presentation/learn_skills.dart';
import 'package:student_sync/features/account/presentation/login.dart';
import 'package:student_sync/features/account/presentation/sign_up.dart';
import 'package:student_sync/features/account/presentation/verify_email.dart';
import 'package:student_sync/features/main_app/presentation/home.dart';
import 'package:student_sync/features/onboarding/presentation/onboarding.dart';
import 'package:student_sync/utils/routing/route_builder.dart';

abstract class AppRouter {
  static const String signUpPage = "signUpPage";
  static const String loginPage = "loginPage";
  static const String forgotPassword = "forgotPassword";
  static const String verifyEmailPage = "verifyEmailPage";
  static const String onboarding = "onboarding";
  static const String addSkills = "addSkills";
  static const String learnSkills = "learnSkills";
  static const String tellUsMore = "tellUsMore";
  static const String home = "home";

  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    var name = settings.name;
    switch (name) {
      case "/":
        return buildRoute(const SplashScreen());
      case onboarding:
        return buildRoute(const Onboarding());
      case signUpPage:
        return buildRoute(const SignUpPage());
      case loginPage:
        return buildRoute(const LoginPage());
      case forgotPassword:
        return buildRoute(const ForgotPassword());
      case verifyEmailPage:
        return buildRoute(const VerifyEmail());
      case tellUsMore:
        return buildRoute(const TellUsMore());
      case addSkills:
        return buildRoute(const AddSkills());
      case learnSkills:
        return buildRoute(const LearnSkills());
      case home:
        return buildRoute(const Home());
    }
    return buildRoute(const NotFoundPage());
  }
}
