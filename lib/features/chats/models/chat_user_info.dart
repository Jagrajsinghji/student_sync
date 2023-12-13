class ChatUserInfo {
  final String userId;
  final String username;
  final String userImage;
  final String? notificationToken;

  ChatUserInfo(
      {required this.userId,
      required this.username,
      required this.userImage,
      required this.notificationToken});

  factory ChatUserInfo.fromMap(Map data) {
    return ChatUserInfo(
        userId: data['user_id'],
        username: data['username'],
        userImage: data['user_image'],
        notificationToken: data['notificationToken']);
  }

  Map<String, dynamic> toMap() => {
        "user_id": userId,
        "username": username,
        "user_image": userImage,
        "notificationToken": notificationToken
      };
}
