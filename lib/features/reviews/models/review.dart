class Review {
  final String id;
  final String userId;
  final int rating;
  final String reviewComment;
  final String revieweName;
  final String revieweProfileImg;
  final DateTime createdAt;
  final String reviewerUserId;

  Review(
      {required this.id,
      required this.userId,
      required this.rating,
      required this.reviewComment,
      required this.revieweName,
      required this.revieweProfileImg,
      required this.createdAt,
      required this.reviewerUserId});

  factory Review.fromMap(Map data) {
    return Review(
        id: data['_id'],
        userId: data['userId'],
        rating: data['rating'],
        reviewComment: data['review_comment'],
        revieweName: data['reviewe_name'],
        revieweProfileImg: data['reviewe_profile_img_name'],
        createdAt: DateTime.parse(data['createdAt']),
        reviewerUserId: data['reviewer_user_id']);
  }
}
