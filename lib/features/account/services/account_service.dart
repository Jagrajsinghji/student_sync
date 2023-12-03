import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';
import 'package:student_sync/features/account/models/institution.dart';
import 'package:student_sync/utils/constants/api_endpoints.dart';
import 'package:student_sync/utils/globals/functions.dart';
import 'package:student_sync/utils/network/dio_client.dart';

class AccountService {
  final DioClient _dio;

  AccountService({
    required DioClient dio,
  }) : _dio = dio;

  Future<Response> registerUser(
      {required String email, required String password}) async {
    Position position = await getCurrentLocation();
    var data = {
      "location": {
        "type": "Point",
        "coordinates": [position.latitude, position.longitude],
      },
      "email": email,
      "password": password
    };
    return _dio.client.post(APIEndpoints.registerUser, data: data);
  }

  Future<List<Institution>> getAllInstitutions() async {
    var list = <Institution>[];
    try {
      var resp = await _dio.client.get(APIEndpoints.getAllInstitutions);
      if (resp.statusCode == 200) {
        for (var inst in (resp.data as List)) {
          list.add(Institution.fromMap(inst as Map));
        }
      }
    } catch (e, s) {
      debugPrintStack(stackTrace: s, label: e.toString());
    }
    return list;
  }

  Future<Response> sendVerificationEmail(String email) {
    var data = {"email": email};
    return _dio.client.post(APIEndpoints.sendVerificationEmail, data: data);
  }

  Future<Response> login(
      {required String email, required String password}) async {
    var data = {"email": email, "password": password};
    return _dio.client.post(APIEndpoints.login, data: data);
  }
}
