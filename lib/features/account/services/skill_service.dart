import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:student_sync/features/account/models/skill.dart';
import 'package:student_sync/utils/constants/api_endpoints.dart';
import 'package:student_sync/utils/network/dio_client.dart';

class SkillService {
  final DioClient _dio;

  SkillService({required DioClient dio}) : _dio = dio;

  Future<List<Skill>> getAllSkills() async {
    var list = <Skill>[];
    try {
      var resp = await _dio.client.get(APIEndpoints.getAllSkills);
      if (resp.statusCode == 200) {
        for (var inst in (resp.data as List)) {
          list.add(Skill.fromMap(inst as Map));
        }
      }
    } catch (e, s) {
      debugPrintStack(stackTrace: s, label: e.toString());
    }
    return list;
  }

  Future<Response> addUserOwnSkills(String userId, List<Skill> skills) {
    var data = {"ownSkills": skills.map((e) => e.id).toList()};
    return _dio.client
        .post(APIEndpoints.addOwnSkillByUserId + userId, data: data);
  }

  Future<Response> addUserWantSkills(String userId, List<Skill> skills) {
    var data = {"wantSkills": skills.map((e) => e.id).toList()};
    return _dio.client
        .post(APIEndpoints.addWantSkillByUserId + userId, data: data);
  }

  Future<List<String>> getUserOwnSkills(String userId) async {
    try {
      var response =
          await _dio.client.get(APIEndpoints.getUserOwnSkills + userId);
      if (response.statusCode == 200) {
        return ((response.data as Map)['ownSkills'] as List)
            .map((e) => e.toString())
            .toList();
      }
    } catch (e, s) {
      debugPrintStack(stackTrace: s, label: e.toString());
    }
    return [];
  }

  Future<List<String>> getUserWantSkills(String userId) async{
    try {
      var response =
          await _dio.client.get(APIEndpoints.getUserWantSkills + userId);
      if (response.statusCode == 200) {
        return ((response.data as Map)['wantSkills'] as List)
            .map((e) => e.toString())
            .toList();
      }
    } catch (e, s) {
      debugPrintStack(stackTrace: s, label: e.toString());
    }
    return [];
  }
}
