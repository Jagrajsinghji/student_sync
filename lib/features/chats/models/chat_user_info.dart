class ChatUserInfo {
  final String userId;
  final String username;
  final String userImage;

  ChatUserInfo(
      {required this.userId, required this.username, required this.userImage});

  factory ChatUserInfo.fromMap(Map data) {
    return ChatUserInfo(
        userId: data['user_id'],
        username: data['username'],
        userImage: data['user_image']);
  }

  Map<String, dynamic> toMap() =>
      {"user_id": userId, "username": username, "user_image": userImage};
}
