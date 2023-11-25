import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:student_sync/features/account/presentation/controllers/AccountController.dart';
import 'package:student_sync/features/account/services/account_service.dart';
import 'package:student_sync/features/account/services/skill_service.dart';
import 'package:student_sync/features/chats/services/chat_service.dart';
import 'package:student_sync/utils/network/dio_client.dart';

void initServiceLocator() async {
  var get = GetIt.instance;
  var dio = DioClient();
  var accountService = AccountService(dio: dio);
  var skillService = SkillService(dio: dio);
  var pref = await SharedPreferences.getInstance();

  /// Services
  get.registerSingleton<AccountService>(accountService);
  get.registerSingleton<SkillService>(skillService);

  /// Controllers
  get.registerLazySingleton<AccountController>(() => AccountController(pref,
      accountService: accountService, skillService: skillService));

  get.registerLazySingleton(
      () => ChatService(firestore: FirebaseFirestore.instance));
}
