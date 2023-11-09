import 'package:get_it/get_it.dart';
import 'package:student_sync/features/account/services/account_service.dart';
import 'package:student_sync/utils/network/dio_client.dart';

void initServiceLocator() {
  var get = GetIt.instance;
  var dio = DioClient();
  get.registerLazySingleton(() => AccountService(dio: dio));
}
