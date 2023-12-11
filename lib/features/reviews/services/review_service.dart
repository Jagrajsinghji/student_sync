import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:student_sync/features/reviews/models/review.dart';
import 'package:student_sync/utils/constants/api_endpoints.dart';
import 'package:student_sync/utils/network/dio_client.dart';

class ReviewService {
  final DioClient _dio;

  ReviewService({required DioClient dio}) : _dio = dio;

  Future<List<Review>> getAllReviews(String userId) async {
    var body = {"user_id": userId};
    try {
      var response = await _dio.client
          .post(APIEndpoints.getAllReviewsByUserId, data: body);
      if (response.statusCode == 200) {
        return (response.data as List).map((e) => Review.fromMap(e)).toList();
      }
    } catch (e, s) {
      debugPrintStack(stackTrace: s, label: e.toString());
    }
    return [];
  }

  Future<Response> createReview(
      {required String userId,
      required String reviewerUserId,
      required int rating,
      required String comment}) {
    var body = {
      "user_id": userId,
      "rating": rating,
      "review_comment": comment,
      "reviewer_user_id": reviewerUserId
    };
    return _dio.client.post(APIEndpoints.createReview, data: body);
  }
}
