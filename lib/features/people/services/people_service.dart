import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:student_sync/features/profile/models/user_profile_details.dart';
import 'package:student_sync/utils/constants/api_endpoints.dart';
import 'package:student_sync/utils/network/dio_client.dart';

class PeopleService {
  final DioClient _dio;

  PeopleService({required DioClient dio}) : _dio = dio;

  Future<List<UserProfileDetails>> getNearbyPeople(
      String userId, LatLng position, double radiusInMeters) async {
    var body = {
      "userId": userId,
      "lat": position.latitude,
      "long": position.longitude,
      "radiusInMeters": radiusInMeters
    };
    try {
      var response =
          await _dio.client.post(APIEndpoints.getPeopleNearby, data: body);
      if (response.statusCode == 200) {
        return (response.data['users'] as List)
            .map((e) => UserProfileDetails.fromMap(e))
            .toList();
      }
    } catch (e, s) {
      debugPrintStack(stackTrace: s, label: e.toString());
    }
    return [];
  }

}
