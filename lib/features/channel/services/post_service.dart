import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:student_sync/features/channel/models/post.dart';
import 'package:student_sync/utils/constants/api_endpoints.dart';
import 'package:student_sync/utils/network/dio_client.dart';

class PostService {
  final DioClient _dio;

  PostService({required DioClient dio}) : _dio = dio;

  Future<Response> createPost(
      {required String userId,
      required String caption,
      required String imgUrl,
      required LatLng position,
      required String locationName}) async {
    var body = {
      "coordinates": [position.longitude, position.latitude],
      "locationName": locationName,
      "userId": userId,
      "caption": caption,
      "coordinate": [43.450053, 80.4935],
      "postImg": imgUrl,
      "numOfLike": 0
    };
    return _dio.client.post(APIEndpoints.createPost, data: body);
  }

  Future<List<Post>> getAllPosts() async {
    var list = <Post>[];
    try {
      var response = await _dio.client.get(APIEndpoints.getAllPosts);
      if (response.statusCode == 200) {
        list.addAll((response.data as List).map((e) => Post.fromMap(e)));
      }
    } catch (e, s) {
      debugPrintStack(stackTrace: s, label: e.toString());
    }
    return list;
  }

  Future<List<Post>> getAllPostsByUserId(String userId) async {
    var list = <Post>[];
    try {
      var response = await _dio.client.get(APIEndpoints.getAllPostsByUserId,
          queryParameters: {"userId": userId});
      if (response.statusCode == 200) {
        list.addAll((response.data as List).map((e) => Post.fromMap(e)));
      }
    } catch (e, s) {
      debugPrintStack(stackTrace: s, label: e.toString());
    }
    return list;
  }

  Future<List<Post>> getNearByPosts(LatLng position, double radiusInMeters) async {
    var body = {
      "lat": position.latitude,
      "long": position.longitude,
      "radiusInMeters": radiusInMeters
    };
    var list = <Post>[];
    try {
      var response =
          await _dio.client.post(APIEndpoints.getNearbyPosts, data: body);
      if (response.statusCode == 200) {
        list.addAll((response.data as List).map((e) => Post.fromMap(e)));
      }
    } catch (e, s) {
      debugPrintStack(stackTrace: s, label: e.toString());
    }
    return list;
  }

  Future<bool> likePost(
      {required String userId, required String postId}) async {
    var body = {"userId": userId, "postId": postId};
    try {
      var response = await _dio.client.post(APIEndpoints.likePost, data: body);
      return response.data['isLiked'];
    } catch (e, s) {
      debugPrintStack(stackTrace: s, label: e.toString());
    }
    return false;
  }
}
