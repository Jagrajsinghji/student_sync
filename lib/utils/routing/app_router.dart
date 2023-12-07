import 'dart:io';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:student_sync/common_widgets/home.dart';
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
import 'package:student_sync/features/channel/models/post.dart';
import 'package:student_sync/features/channel/presentation/add_post.dart';
import 'package:student_sync/features/chats/models/chat_info.dart';
import 'package:student_sync/features/chats/presentation/chat_screen.dart';
import 'package:student_sync/features/maps/presentation/pick_location_from_map.dart';
import 'package:student_sync/features/onboarding/presentation/onboarding.dart';
import 'package:student_sync/features/people/presentation/people_near_me.dart';
import 'package:student_sync/features/profile/models/user_info.dart';
import 'package:student_sync/features/profile/presentation/edit_profile.dart';
import 'package:student_sync/features/profile/presentation/profile.dart';
import 'package:student_sync/features/profile/presentation/show_post_image.dart';
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
  static const String chatScreen = "/chat";
  static const String peopleNearMe = "/peopleNearMe";
  static const String editProfile = "/editProfile";
  static const String addPost = "/addPost";
  static const String profile = "/profile";
  static const String showPostPhoto = "/showPostPhoto";
  static const String mapScreen = "/pickLocation";

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
            pageBuilder: (_, state) => buildPage(
                AddSkills(editSkills: (state.extra as bool?) ?? false))),
        GoRoute(
            path: learnSkills,
            pageBuilder: (_, state) => buildPage(LearnSkills(
                  editSkills: (state.extra as bool?) ?? false,
                ))),
        GoRoute(path: home, pageBuilder: (_, __) => buildPage(const Home())),
        GoRoute(
            path: addPost,
            pageBuilder: (_, state) => buildPage(AddPost(
                  image: state.extra as File,
                ))),
        GoRoute(
            path: editProfile,
            pageBuilder: (_, state) => buildPage(EditProfile(
                  userInfo: state.extra as UserInfo,
                ))),
        GoRoute(
            path: peopleNearMe,
            pageBuilder: (_, __) => buildPage(const PeopleNearMe())),
        GoRoute(
            path: chatScreen,
            pageBuilder: (_, state) => buildPage(ChatScreen(
                  chatInfo: state.extra as ChatInfo,
                ))),
        GoRoute(
            path: profile,
            pageBuilder: (_, state) => buildPage(Profile(
                  userId: state.extra as String?,
                ))),
        GoRoute(
            path: showPostPhoto,
            pageBuilder: (_, state) => buildPage(ShowPostPhoto(
                  post: state.extra as Post,
                ))),
        GoRoute(
            path: mapScreen,
            pageBuilder: (_, state) => buildPage(const PickLocationFromMap())),
        GoRoute(
            path: notFound,
            pageBuilder: (_, __) => buildPage(const NotFoundPage())),
      ],
    );
  }
}
