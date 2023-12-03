class UserInfo {
  final String id;
  final String email;
  final bool userStatus;
  final String city;
  final String country;
  final String institutionId;
  final String mobileNumber;
  final String name;
  final String province;
  final String? profileImage;
  final String? studentIdImage;
  final String postalCode;
  final String notificationToken;

  UserInfo(
      {required this.id,
      required this.email,
      required this.userStatus,
      required this.city,
      required this.country,
      required this.institutionId,
      required this.mobileNumber,
      required this.name,
      required this.province,
      required this.profileImage,
      required this.studentIdImage,
      required this.postalCode,
      required this.notificationToken});

  factory UserInfo.fromMap(Map data) {
    return UserInfo(
        id: data['_id'],
        email: data['email'],
        userStatus: data['user_status'],
        city: data['city'],
        country: data['country'],
        institutionId: data['institutionId'],
        mobileNumber: data['mobile_number'],
        name: data['name'],
        province: data['province'],
        profileImage: data['profile_img_name'],
        studentIdImage: data['student_img_name'],
        postalCode: data['postal_code'],
        notificationToken: data['notificationToken']);
  }

  Map toFollowerMap() =>
      {"name": name, "profileImg": profileImage, "email": email, "userId": id};
}
