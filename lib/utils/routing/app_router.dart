import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:student_sync/common_widgets/not_found_page.dart';
import 'package:student_sync/common_widgets/splash_screen.dart';
import 'package:student_sync/features/account/presentation/screens/add_skills.dart';
import 'package:student_sync/features/account/presentation/screens/forgot_password.dart';
import 'package:student_sync/features/account/presentation/screens/learn_skills.dart';
import 'package:student_sync/features/account/presentation/screens/login.dart';
import 'package:student_sync/features/account/presentation/screens/sign_up.dart';
import 'package:student_sync/features/account/presentation/screens/student_id_capture.dart';
import 'package:student_sync/features/account/presentation/screens/tell_us_more.dart';
import 'package:student_sync/features/account/presentation/screens/verify_email.dart';
import 'package:student_sync/features/main_app/presentation/home.dart';
import 'package:student_sync/features/onboarding/presentation/onboarding.dart';
import 'package:student_sync/utils/routing/route_builder.dart';

abstract class AppRouter {
  static const String signUpPage = "/signUpPage";
  static const String loginPage = "/loginPage";
  static const String forgotPassword = "/forgotPassword";
  static const String verifyEmailPage = "/verifyEmail";
  static const String onboarding = "/onboarding";
  static const String addSkills = "/addSkills";
  static const String learnSkills = "/learnSkills";
  static const String tellUsMore = "/tellUsMore";
  static const String home = "/home";
  static const String notFound = "/notFound";
  static const String studentIdCapture = "/studentIdCapture";

  static final RouterConfig<Object>? routerConfig = _getRouterConfig();

  static RouterConfig<Object>? _getRouterConfig() {
    return GoRouter(
      initialLocation: "/",
      routes: [
        GoRoute(
            path: "/", pageBuilder: (_, __) => buildPage(const SplashScreen())),
        GoRoute(
            path: onboarding,
            pageBuilder: (_, __) => buildPage(const Onboarding())),
        GoRoute(
            path: signUpPage,
            pageBuilder: (_, __) => buildPage(const SignUpPage())),
        GoRoute(
            path: loginPage,
            pageBuilder: (_, __) => buildPage(const LoginPage())),
        GoRoute(
            path: forgotPassword,
            pageBuilder: (_, __) => buildPage(const ForgotPassword())),
        GoRoute(
            path: verifyEmailPage,
            pageBuilder: (_, __) => buildPage(const VerifyEmail())),
        GoRoute(
            path: tellUsMore,
            pageBuilder: (_, state) => buildPage(const TellUsMore())),
        GoRoute(
            path: studentIdCapture,
            pageBuilder: (_, __) => buildPage(const StudentIdCapture())),
        GoRoute(
            path: addSkills,
            pageBuilder: (_, state) => buildPage(const AddSkills())),
        GoRoute(
            path: learnSkills,
            pageBuilder: (_, __) => buildPage(const LearnSkills())),
        GoRoute(path: home, pageBuilder: (_, __) => buildPage(const Home())),
        GoRoute(
            path: notFound,
            pageBuilder: (_, __) => buildPage(const NotFoundPage())),
      ],
    );
  }
}
