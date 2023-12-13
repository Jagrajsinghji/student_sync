import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:student_sync/controller/api_controller.dart';
import 'package:student_sync/controller/bottom_nav_controller.dart';
import 'package:student_sync/controller/location_controller.dart';
import 'package:student_sync/controller/notification_controller.dart';
import 'package:student_sync/features/account/services/account_service.dart';
import 'package:student_sync/features/account/services/skill_service.dart';
import 'package:student_sync/features/channel/services/post_service.dart';
import 'package:student_sync/features/chats/services/chat_service.dart';
import 'package:student_sync/features/people/services/people_service.dart';
import 'package:student_sync/features/profile/services/profile_service.dart';
import 'package:student_sync/features/reviews/services/review_service.dart';
import 'package:student_sync/utils/network/dio_client.dart';

void initServiceLocator() async {
  var get = GetIt.instance;
  var dio = DioClient();
  var accountService = AccountService(dio: dio);
  var skillService = SkillService(dio: dio);
  var profileService = ProfileService(
      dioClient: dio,
      firebaseStorage: FirebaseStorage.instance,
      firebaseDatabase: FirebaseDatabase.instance,
      firebaseMessaging: FirebaseMessaging.instance);
  var chatService = ChatService(firestore: FirebaseFirestore.instance);
  var peopleService = PeopleService(dio: dio);
  var postService = PostService(dio: dio);
  var reviewService = ReviewService(dio: dio);
  var pref = await SharedPreferences.getInstance();

  /// Controllers
  get.registerLazySingleton<APIController>(() => APIController(pref,
      accountService: accountService,
      skillService: skillService,
      profileService: profileService,
      chatService: chatService,
      peopleService: peopleService,
      postService: postService,
      reviewService: reviewService));

  get.registerLazySingleton(() => BottomNavController());

  get.registerLazySingleton(
      () => LocationController(profileService: profileService));
}

void initNotifications() {
  NotificationController.init();
  FirebaseMessaging.onMessage.listen((event) async {
    await NotificationController.pushNotification(event);
  });
}
