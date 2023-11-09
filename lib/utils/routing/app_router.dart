import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:student_sync/common_widgets/not_found_page.dart';
import 'package:student_sync/common_widgets/splash_screen.dart';
import 'package:student_sync/features/account/presentation/widgets/add_skills.dart';
import 'package:student_sync/features/account/presentation/widgets/forgot_password.dart';
import 'package:student_sync/features/account/presentation/widgets/learn_skills.dart';
import 'package:student_sync/features/account/presentation/widgets/login.dart';
import 'package:student_sync/features/account/presentation/widgets/sign_up.dart';
import 'package:student_sync/features/account/presentation/widgets/tell_us_more.dart';
import 'package:student_sync/features/account/presentation/widgets/verify_email.dart';
import 'package:student_sync/features/main_app/presentation/home.dart';
import 'package:student_sync/features/onboarding/presentation/onboarding.dart';
import 'package:student_sync/utils/constants/extensions.dart';
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
            path: "$verifyEmailPage/:email",
            redirect: (_, state) {
              return (state.pathParameters['email']
                          ?.isValidInstitutionEmail() ??
                      false)
                  ? null
                  : notFound;
            },
            pageBuilder: (_, state) {
              return buildPage(VerifyEmail(
                email: state.pathParameters['email'].toString(),
              ));
            }),
        GoRoute(
            path: tellUsMore,
            pageBuilder: (_, __) => buildPage(const TellUsMore())),
        GoRoute(
            path: addSkills,
            pageBuilder: (_, __) => buildPage(const AddSkills())),
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
