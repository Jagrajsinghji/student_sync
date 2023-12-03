import 'dart:io';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:student_sync/features/profile/models/user_info.dart';
import 'package:student_sync/features/profile/models/user_profile_details.dart';
import 'package:student_sync/utils/constants/api_endpoints.dart';
import 'package:student_sync/utils/constants/enums.dart';
import 'package:student_sync/utils/globals/functions.dart';
import 'package:student_sync/utils/network/dio_client.dart';

class ProfileService {
  final DioClient _dio;
  final FirebaseStorage _firebaseStorage;
  final FirebaseDatabase _firebaseDatabase;

  ProfileService(
      {required DioClient dioClient,
      required FirebaseStorage firebaseStorage,
      required FirebaseDatabase firebaseDatabase})
      : _dio = dioClient,
        _firebaseStorage = firebaseStorage,
        _firebaseDatabase = firebaseDatabase;

  Future<UserInfo?> updateUser({
    required String userId,
    String? name,
    String? institutionId,
    String? city,
    String? province,
    String? country,
    String? mobileNumber,
    String? studentIdImage,
    String? profileImage,
    String? postalCode,
  }) async {
    Position position = await getCurrentLocation();
    String? notificationToken;
    try {
      notificationToken = await FirebaseMessaging.instance.getToken();
    } catch (e, s) {
      debugPrintStack(label: e.toString(), stackTrace: s);
    }
    try {
      var data = {
        if (name != null) "name": name,
        if (institutionId != null) "institutionId": institutionId,
        if (city != null) "city": city,
        if (province != null) "province": province,
        if (country != null) "country": country,
        if (mobileNumber != null) "mobile_number": mobileNumber,
        if (studentIdImage != null) "student_id_img_name": studentIdImage,
        if (profileImage != null) "profile_img_name": profileImage,
        if (postalCode != null) "postal_code": postalCode,
        if (notificationToken != null) "notificationToken": notificationToken,
        "location": {
          "type": "Point",
          "coordinates": [position.latitude, position.longitude]
        },
      };
      var resp =
          await _dio.client.patch(APIEndpoints.updateUser + userId, data: data);
      if (resp.statusCode == 200) {
        return UserInfo.fromMap(resp.data);
      }
    } catch (e, s) {
      debugPrintStack(label: e.toString(), stackTrace: s);
    }
    return null;
  }

  Future uploadPhoto(
      {required String userId,
      required File file,
      required PhotoType type}) async {
    String fileName = type.name;
    if (type == PhotoType.Post) {
      fileName = "Post_${DateTime.now()}";
    }
    var task = await _firebaseStorage.ref("$userId/$fileName").putFile(file);
    return task.ref.getDownloadURL();
  }

  Future<UserProfileDetails?> getProfileInfo(String userId) async {
    try {
      var response = await _dio.client.get(APIEndpoints.userInfoById + userId);
      if (response.statusCode == 200) {
        return UserProfileDetails.fromMap(response.data);
      }
    } catch (e, s) {
      debugPrintStack(stackTrace: s, label: e.toString());
    }
    return null;
  }

  void followUser(UserInfo otherUser, UserInfo myInfo) async {
    var res = await _firebaseDatabase
        .ref("${otherUser.id}/followers/")
        .runTransaction((data) {
      var list = <Object?>[];
      if (data != null) {
        list.addAll(data as List<Object?>);
        if (!list.any((element) => (element as Map)['userId'] == myInfo.id)) {
          list.add(myInfo.toFollowerMap());
        }
      } else {
        list.add(myInfo.toFollowerMap());
      }
      return Transaction.success(list);
    }, applyLocally: false);
    if (res.committed) {
      _firebaseDatabase.ref("${myInfo.id}/following/").runTransaction((data) {
        var list = <Object?>[];
        if (data != null) {
          list.addAll(data as List<Object?>);
          if (!list
              .any((element) => (element as Map)['userId'] == otherUser.id)) {
            list.add(otherUser.toFollowerMap());
          }
        } else {
          list.add(otherUser.toFollowerMap());
        }
        return Transaction.success(list);
      }, applyLocally: false);
    }
  }

  void unFollowUser(String otherUserId, String myUserId) async {
    var res = await _firebaseDatabase
        .ref("$otherUserId/followers/")
        .runTransaction((data) {
      if (data != null) {
        var list = [...data as List<Object?>];
        list.removeWhere((element) => (element as Map?)?['userId'] == myUserId);
        return Transaction.success(list);
      } else {
        return Transaction.success(data);
      }
    }, applyLocally: false);
    if (res.committed) {
      _firebaseDatabase.ref("$myUserId/following/").runTransaction((data) {
        if (data != null) {
          var list = [...data as List<Object?>];
          list.removeWhere(
              (element) => (element as Map?)?['userId'] == otherUserId);
          return Transaction.success(list);
        } else {
          return Transaction.success(data);
        }
      }, applyLocally: false);
    }
  }

  Stream<bool> isFollowingStream(String myUserId, String otherUserId) {
    return _firebaseDatabase.ref("$myUserId/following/").onValue.map((event) =>
        (event.snapshot.value as List<Object?>)
            .any((element) => (element as Map)['userId'] == otherUserId));
  }
}
