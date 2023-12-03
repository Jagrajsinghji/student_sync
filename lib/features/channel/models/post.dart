class Post {
  Post(
      {required this.id,
      required this.userId,
      required this.caption,
      required this.postImg,
      required this.coordinate,
      required this.locationName,
      required this.createdAt,
      required this.numOfLike,
      required this.profileImage,
      required this.name});

  final String id;
  final String userId;
  final String caption;
  final String postImg;
  final int numOfLike;
  final List coordinate;
  final String locationName;
  final String? profileImage;
  final String? name;
  final DateTime createdAt;

  factory Post.fromMap(Map data) {
    return Post(
        id: data['_id'],
        userId: data['userId'],
        caption: data['caption'],
        postImg: data['postImg'],
        coordinate: data['coordinate'],
        locationName: data['locationName'],
        numOfLike: data['numOfLike'],
        createdAt: DateTime.parse(data['createdAt']),
        profileImage: data['profile_img_name'],
        name: data['name']);
  }

  bool isLiked = false;
}
