import 'package:dio/dio.dart';
import 'package:student_sync/utils/constants/api_endpoints.dart';

class DioClient {
  Dio init({Dio? dioInstance}) {
    var dio = dioInstance ?? Dio();
    dio.interceptors.add(LogInterceptor(requestBody: true, responseBody: true));
    dio.options.baseUrl = APIEndpoints.baseUrl;
    _client = dio;
    return _client!;
  }

  Dio? _client;

  Dio get client {
    return _client ?? init();
  }
}
